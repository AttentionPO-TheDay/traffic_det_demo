import lightning as pl
import torch
import torch.nn as nn
from torch.nn import functional as F
from torch.utils.data import DataLoader,Dataset
#import datasets
from sklearn.model_selection import train_test_split
from lightning.pytorch.callbacks import EarlyStopping
import os
import pandas as pd
import numpy as np
from tqdm import tqdm
import math
from imblearn.over_sampling import RandomOverSampler,SMOTE
from lightning.pytorch.loggers import TensorBoardLogger
from torchmetrics import Accuracy,Precision,Recall,F1Score

def get_classification_report(cm, labels=None):
    rows = []
    for i in range(cm.shape[0]):
        tp = cm[i, i]
        tp_fp = cm[:, i].sum()
        p = cm[i, :].sum()
        precision = tp / tp_fp
        recall = tp / p
        if labels: label = labels[i]
        else: label = i
        row = {"label": label, "precision": precision, "recall": recall}
        rows.append(row)
    return pd.DataFrame(rows)
    
def confusion_matrix(dataloader, model, num_class):
    model.eval()
    cm = np.zeros((num_class, num_class), dtype=np.float64)
    for x,y in tqdm(dataloader,desc="evaluate metrics"):
        y_hat = model(x)
        y_hat = torch.argmax(F.log_softmax(y_hat, dim=1), dim=1)
        for i in range(len(y)):
            cm[y[i], y_hat[i]] += 1
    return cm

class CustomDataset(Dataset):
    def __init__(self, df):
        self.features = df.iloc[:, 1:].values
        self.labels = df.iloc[:,0].values

    def __len__(self):
        return len(self.labels)

    def __getitem__(self, idx):
        feature = torch.tensor(np.array([self.features[idx]]), dtype=torch.float32)
        label = torch.tensor(self.labels[idx], dtype=torch.long)
        return feature, label

def train_dataloader(datapath,batch_size=48,train=True):
    data_frame = pd.read_csv(datapath) 
    # 提取标签和特征
    X =data_frame.iloc[:, :-3]# 特征
    # print(X.shape)
    y = data_frame.iloc[:, -2] #标签
    #初始化 SMOTE
    # smote = SMOTE(random_state=42)
    # smote = RandomOverSampler(random_state=42)
    #进行过采样
    # X_resampled, y_resampled = smote.fit_resample(X, y)
    #将结果转换回DataFrame（可选）
    # resampled_df = pd.DataFrame(X_resampled, columns=X.columns)
    # resampled_df = pd.concat([y_resampled, X_resampled], axis=1) # 将标签插入到第一列
    train_df, test_df = train_test_split(pd.concat([y, X], axis=1) , test_size=0.1, random_state=0)
    # Save the test set to a CSV file if a path is provided
    train_df.to_csv("dataset/csv/ScenarioB-CSV/TimeBasedFeatures-Dataset-15s-Train.csv", index=False)
    test_df.to_csv("dataset/csv/ScenarioB-CSV/TimeBasedFeatures-Dataset-15s-TestMulti.csv", index=False)

    # Create dataset and data loader
    if train:
        dataset = CustomDataset(train_df)
        data_loader = DataLoader(dataset, batch_size=batch_size, shuffle=True, num_workers=6,pin_memory=True)
    else:
        dataset = CustomDataset(test_df)
        data_loader = DataLoader(dataset, batch_size=40*batch_size, shuffle=False, num_workers=6,pin_memory=True)
    return data_loader




class TransformerModel(pl.LightningModule):
    def __init__(
        self,
        input_dim=1,          # 输入特征维度（默认为1）
        signal_length=23,    # 信号长度（如时间步数）
        d_model=256,           # 隐藏层维度 
        num_heads=2,          # 多头注意力的头数
        num_layers=2,         # Transformer 层数
        dropout=0.03,          # Dropout 概率
        n_classes=12,          # 输出类别数（固定为12）
    ):
        super().__init__()
        self.save_hyperparameters() # Save parameters to checkpoint
        self.n_classes = n_classes
        # Initialize metrics
        self.accuracy = Accuracy(task="multiclass", num_classes=n_classes)
        self.precision = Precision(task="multiclass", num_classes=n_classes)
        self.recall = Recall(task="multiclass", num_classes=n_classes)
        self.f1_score = F1Score(task="multiclass", num_classes=n_classes)

        self.test_accuracy = Accuracy(task="multiclass", num_classes=n_classes)
        self.test_precision = Precision(task="multiclass", num_classes=n_classes)
        self.test_recall = Recall(task="multiclass", num_classes=n_classes)
        self.test_f1_score = F1Score(task="multiclass", num_classes=n_classes)
        # Input embedding layer
        self.signal_length = signal_length
        # 1. 输入预处理
        self.proj_layer = nn.Sequential(
            nn.InstanceNorm1d(1),
            nn.Conv1d(input_dim, d_model//2, kernel_size=3, padding=1),    # 加深特征提取
            nn.GELU(),
            nn.InstanceNorm1d(d_model//2),#BatchNorm1d(d_model),
            nn.Conv1d(d_model//2, d_model//2, kernel_size=3, padding=1),    # 加深特征提取
            nn.GELU(),
            nn.InstanceNorm1d(d_model//2),#BatchNorm1d(d_model),
            nn.Conv1d(d_model//2, d_model, kernel_size=7, padding=3),    # 加深特征提取
            nn.GELU(),
            nn.InstanceNorm1d(d_model),#BatchNorm1d(d_model),
            nn.Conv1d(d_model, d_model, kernel_size=7, padding=3),    # 加深特征提取
            nn.GELU(),
            nn.InstanceNorm1d(d_model),#BatchNorm1d(d_model),
            nn.Conv1d(d_model, d_model, kernel_size=13, padding=6),    # 加深特征提取
            nn.GELU()
        )
        # 2. 可学习的位置编码
        self.pos_embedding = self._get_sinusoidal_encoding(signal_length, d_model)
        # 3. Transformer 编码器层
        encoder_layer = nn.TransformerEncoderLayer(
            d_model=d_model,
            nhead=num_heads, # 多头注意力参数
            dim_feedforward=4*d_model,   # FFN 隐藏层维度（通常为4倍d_model）
            dropout=dropout,
            activation="gelu",
            batch_first=True,             # 输入格式为 [batch_size, seq_len, features]
            norm_first=True             # 先做LayerNorm
        )

        self.transformer_encoder = nn.TransformerEncoder(
            encoder_layer,
            num_layers=num_layers
        )
        # 4. 分类头（全局平均池化 + 全连接层）
        self.pooling = nn.AdaptiveAvgPool1d(21)  # 将序列长度压缩为1
        self.fl1 = nn.Linear(d_model*21, 512)
        self.fl2 = nn.Linear(512, 256)
        self.gelu = nn.GELU()
        self.drop = nn.Dropout(p=0.03)
        self.fc_out = nn.Linear(256, n_classes)

    def forward(self, x):
        """
        Args:
            x (Tensor): 输入信号，形状 [batch_size, input_dim, signal_length]

        Returns:
            logits (Tensor): 输出分类结果，形状 [batch_size, 12]
        """
        # 线性投影层 d_model可以理解为channel
        # print(x.shape) # [batch, 1, 1500]
        x = self.proj_layer(x)   # [B, d_model, L]
        x = x.permute(0, 2, 1) # [B, 1, L]-> [B, L, 1]
        # 添加位置编码
        pos_emb = self.pos_embedding[:, :x.size(1), :]  # 动态适配信号长度
        x = x + pos_emb
        # Transformer 编码器层
        x = self.transformer_encoder(x)    # [B, L, d_model]
        x = self.gelu(x)
        # 池化到固定维度
        x = x.permute(0, 2, 1)            # 转换为 [B, d_model, L] 适配池化层
        x = self.pooling(x)                # 全局平均池化 → [B, d_model, 128]
        # 展平并映射到类别数
        x = torch.flatten(x, start_dim=1)  # [B, d_model*128]
        x = self.drop(self.fl1(x))          # [B, 128]
        x = self.gelu(x)                    # [B, 128]
        x = self.gelu(self.fl2(x))          # [B, 256]
        logits = self.fc_out(x)            # [B, 12]
        return logits

    def configure_optimizers(self):
        optimizer = torch.optim.Adam(self.parameters(),lr=0.002)
        scheduler = {
            'scheduler': torch.optim.lr_scheduler.StepLR(optimizer, step_size=10, gamma=0.1),
            'interval': 'epoch',  # Update the learning rate every epoch
            'frequency': 4,       # Apply the scheduler once every epoch
        }
        return [optimizer], [scheduler]

    def training_step(self, batch, batch_idx):
        x, y = batch
        y_hat = self(x)
        y_pred = torch.argmax(y_hat, dim=1)
        # print(y_hat,y)
        loss = nn.functional.cross_entropy(y_hat, y)
        # Update metrics
        self.accuracy(y_pred, y)
        self.precision(y_pred, y)
        self.recall(y_pred, y)
        self.f1_score(y_pred, y)
        values = {"loss": loss,"accuracy": self.accuracy,"precision": self.precision,"recall": self.recall,"f1_score": self.f1_score}
        self.log_dict(values, prog_bar=True,on_step=False, on_epoch=True)
        return loss
    
    def test_step(self, batch, batch_idx):
        x, y = batch
        y_hat = self(x)
        y_pred = torch.argmax(y_hat, dim=1)
        loss = nn.functional.cross_entropy(y_hat, y)
        # Update metrics
        self.test_accuracy(y_pred, y)
        self.test_precision(y_pred, y)
        self.test_recall(y_pred, y)
        self.test_f1_score(y_pred, y)

        values = {"loss": loss,"accuracy": self.test_accuracy,"precision": self.test_precision,"recall": self.test_recall,"f1_score": self.test_f1_score}
        self.log_dict(values, prog_bar=True)
        return values
    
    # 可学习的位置编码
    def _get_sinusoidal_encoding(self,signal_length, d_model):
        position = torch.arange(signal_length).unsqueeze(1)
        div_term = torch.exp(torch.arange(0, d_model, 2) * (-math.log(10000.0) / d_model))
        pe = torch.zeros(signal_length, d_model)
        pe[:, 0::2] = torch.sin(position * div_term)
        pe[:, 1::2] = torch.cos(position * div_term)
        return pe.unsqueeze(0).to("cpu")
        # return pe.unsqueeze(0).to("cuda")
    
def train_traffic_classification_transformer_model(data_path,model_path):
    pl.seed_everything(44)
    traindata_loader = train_dataloader(data_path,batch_size=48)
    testdata_loader = train_dataloader(data_path,batch_size=1024, train=False)
    logger = TensorBoardLogger("tb_logs", name="transformer_model")
    model = TransformerModel(num_heads=2, num_layers=4, d_model=128, signal_length=23, n_classes=12)
    trainer = pl.Trainer(
        logger=logger,
        # val_check_interval=1.0,
        max_epochs=100,
        # callbacks=[
        #     EarlyStopping(
        #         monitor="training_loss", mode="min", check_on_train_epoch_end=True
        #     )
        # ],
    )
    trainer.fit(model,train_dataloaders=traindata_loader)
    # 计算指标
    val = trainer.test(model, testdata_loader)
    print(val)

    script = model.to_torchscript()  # 无需传入文件路径
    # 定义保存路径
    save_path = os.path.join(model_path, "transformer_model.pt")
    # 保存 TorchScript 模型
    torch.jit.save(script, save_path)

if __name__ == "__main__":
    train_traffic_classification_transformer_model("dataset/csv/ScenarioB-CSV/CSV/TimeBasedFeatures-Dataset-15s-New.csv", "models/traffic_classifcation_transformer_model")
    # tensorboard --logdir tb_logs/
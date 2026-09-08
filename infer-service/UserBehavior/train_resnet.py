import lightning as L
from lightning.pytorch.loggers import TensorBoardLogger
import torch
import torch.nn as nn
from torch.nn import functional as F
from torch.utils.data import DataLoader,Dataset
from sklearn.model_selection import train_test_split
import os
from torchmetrics import Accuracy,Precision,Recall,F1Score
import pandas as pd
import numpy as np
from imblearn.over_sampling import RandomOverSampler

os.environ["QT_QPA_PLATFORM"] = "offscreen"

def get_padding(kernel_size):
    """Calculate padding to preserve input length"""
    return (kernel_size - 1) // 2
    
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
    X =data_frame.iloc[:, 1:]# 特征
    # print(X.shape)
    y = data_frame.iloc[:, 0] #标签
    mapped_y = np.where(y < 6, 0, 1)
    mapped_y = pd.Series(mapped_y)
    #初始化 SMOTE
    # smote = SMOTE(random_state=42)
    # smote = RandomOverSampler(random_state=42)
    #进行过采样
    # X_resamLed, y_resamLed = smote.fit_resample(X, y)
    #将结果转换回DataFrame（可选）
    # resamLed_df = pd.DataFrame(X_resamLed, columns=X.columns)
    # resamLed_df = pd.concat([y_resamLed, X_resamLed], axis=1) # 将标签插入到第一列
    resamLed_df = pd.concat([mapped_y, X], axis=1) # 将标签插入到第一列
    # Split the dataset into train and test sets
    # train_df, test_df = train_test_split(resamLed_df, test_size=0.1, random_state=42)
    # 创建数据集和数据加载器
    # Save the test set to a CSV file if a path is provided
    # test_df.to_csv("dataset/csv/ScenarioB-CSV/TimeBasedFeatures-Dataset-15s-Test.csv", index=False)
    dataset = CustomDataset(resamLed_df)
    data_loader = DataLoader(dataset, batch_size=batch_size, shuffle=True, num_workers=6)
    return data_loader

class ResidualBlock(nn.Module):
    def __init__(self, in_channels, out_channels, kernel_size, stride=1):
        super(ResidualBlock, self).__init__()
        padding =(kernel_size - 1) // 2
        self.conv1 = nn.Conv1d(in_channels, out_channels, kernel_size, stride=stride, padding=padding)
        self.bn1 = nn.InstanceNorm1d(out_channels)
        self.conv2 = nn.Conv1d(out_channels, out_channels, kernel_size, stride=stride, padding=padding)
        self.bn2 = nn.InstanceNorm1d(out_channels)
        
        # 如果输入和输出的通道数不一致，需要用1x1卷积调整维度
        self.shortcut = nn.Sequential()
        if in_channels != out_channels or stride != 1:
            self.shortcut = nn.Sequential(
                nn.Conv1d(in_channels, out_channels, kernel_size=1, stride=stride),
                nn.InstanceNorm1d(out_channels)
            )

    def forward(self, x):
        residual = x
        out = F.gelu(self.bn1(self.conv1(x)))
        out = self.bn2(self.conv2(out))
        out += self.shortcut(residual)  # 残差连接
        out = F.gelu(out)
        return out

class ResNet1D(L.LightningModule):
    def __init__(self, num_blocks=[2, 1, 1, 1], num_classes=10,learning_rate: float = 0.002):
        super(ResNet1D, self).__init__()
        self.save_hyperparameters()
        self.num_classes = num_classes
        self.learning_rate = learning_rate

        # Initialize metrics
        self.accuracy = Accuracy(task="binary")
        self.precision = Precision(task="binary")
        self.recall = Recall(task="binary")
        self.f1_score = F1Score(task="binary")

        self.test_accuracy = Accuracy(task="binary")
        self.test_precision = Precision(task="binary")
        self.test_recall = Recall(task="binary")
        self.test_f1_score = F1Score(task="binary")
        
        # 初始卷积层
        self.conv1 = nn.Sequential(nn.InstanceNorm1d(1),nn.Conv1d(1, 128, kernel_size=3,stride=1,padding=1))
        # 残差块堆叠
        self.layer1 = self._make_layer(128, 256, num_blocks[0], kernel_size=3)
        self.layer2 = self._make_layer(256, 384, num_blocks[1], kernel_size=7)
        self.layer3 = self._make_layer(384, 128, num_blocks[2], kernel_size=11)
        self.layer4 = self._make_layer(128, 16, num_blocks[3], kernel_size=13)
        
        # 全局平均池化和全连接层
        self.avg_pool = nn.AdaptiveAvgPool1d(20)
        self.fc = nn.Linear(20*16, num_classes) 

    def _make_layer(self, in_channels, out_channels, num_blocks, kernel_size, stride=1):
        layers = []
        layers.append(ResidualBlock(in_channels, out_channels, kernel_size, stride))
        for _ in range(1, num_blocks):
            layers.append(ResidualBlock(out_channels, out_channels, kernel_size))
        return nn.Sequential(*layers)

    def forward(self, x):
        out = self.conv1(x)
        out = self.layer1(out)
        out = self.layer2(out)
        out = self.layer3(out)
        out = self.layer4(out)
        out = self.avg_pool(out)
        out = out.view(out.size(0), -1)  
        out = self.fc(out)
        return out

    def training_step(self, batch, batch_idx):
        x, y = batch
        y_hat = self(x)
        y_pred = torch.argmax(y_hat, dim=1)
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

    def configure_optimizers(self):
        optimizer = torch.optim.Adam(self.parameters(), lr=self.learning_rate)
        scheduler = {
            'scheduler': torch.optim.lr_scheduler.StepLR(optimizer, step_size=10, gamma=0.1),
            'interval': 'epoch',  # Update the learning rate every epoch
            'frequency': 4,       # ApLy the scheduler once every epoch
        }
        return [optimizer], [scheduler]
        # optimizer = torch.optim.AdamW(self.parameters(), lr=self.hparams.lr)
        # scheduler = torch.optim.lr_scheduler.ReduceLROnPlateau(optimizer)
        # return {"optimizer": optimizer, "lr_scheduler": scheduler, "monitor": "val_loss"}
    
def train_traffic_classification_resnet_model(traindata_path, testdata_path,model_path):
    L.seed_everything(1)
    traindata_loader = train_dataloader(traindata_path,batch_size=48)
    testdata_loader = train_dataloader(testdata_path,batch_size=1024, train=False)
    logger = TensorBoardLogger("tb_logs", name="resnet_model")
    model = ResNet1D(num_classes=2) 
    # model = torch.compile(model)
    # logger = TensorBoardLogger("tb_logs", name="mnist_model_v1")
    trainer = L.Trainer(
        logger=logger,
        # val_check_interval=1.0,
        max_epochs=60,
        # callbacks=[
        #     EarlyStopping(
        #         monitor="training_loss", mode="min", check_on_train_epoch_end=True
        #     )
        # ],
    )
    trainer.fit(model, train_dataloaders=traindata_loader)
    # 计算指标
    val = trainer.test(model, testdata_loader)
    print(val)
    script = model.to_torchscript()  # 无需传入文件路径
    # 定义保存路径
    save_path = os.path.join(model_path, "resnet_model.pt")
    # 保存 TorchScript 模型
    torch.jit.save(script, save_path)

if __name__ == "__main__":
    train_traffic_classification_resnet_model("dataset/csv/ScenarioB-CSV/TimeBasedFeatures-Dataset-15s-Train.csv","dataset/csv/ScenarioB-CSV/testdataset.csv","models/traffic_classifcation_resnet_model") #correct_samplesNew
    # tensorboard --logdir tb_logs/
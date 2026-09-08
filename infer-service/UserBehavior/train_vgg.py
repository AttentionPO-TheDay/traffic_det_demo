import lightning as L
from lightning.pytorch.loggers import TensorBoardLogger
import torch
import torch.nn as nn
from torch.utils.data import DataLoader,Dataset,random_split
import os
from torchmetrics import Accuracy,Precision,Recall,F1Score
import pandas as pd
import numpy as np
from imblearn.over_sampling import RandomOverSampler

os.environ["QT_QPA_PLATFORM"] = "offscreen"
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
    y = data_frame.iloc[:, 0] #标签
    mapped_y = np.where(y < 6, 0, 1)
    mapped_y = pd.Series(mapped_y)
    resamLed_df = pd.DataFrame(X, columns=X.columns)
    resamLed_df = pd.concat([mapped_y, X], axis=1) 
    dataset = CustomDataset(resamLed_df)
    data_loader = DataLoader(dataset, batch_size=batch_size, shuffle=True,num_workers=6, pin_memory=True) if train else DataLoader(dataset, batch_size=batch_size, shuffle=False,num_workers=6)
    return data_loader

class VGG1D(L.LightningModule):
    def __init__(self,input_length=23, num_classes=2, learning_rate: float = 0.002):
        super(VGG1D, self).__init__()
        self.save_hyperparameters()
        self.num_classes = num_classes
        self.learning_rate = learning_rate
        # Initialize metrics
        self.accuracy = Accuracy(task="binary")
        self.precision = Precision(task="binary")
        self.recall = Recall(task="binary")
        self.f1_score = F1Score(task="binary")
        # 强化特征提取模块
        self.features = nn.Sequential(
            # Block 1 (2 conv layers)
            nn.InstanceNorm1d(1),
            nn.Conv1d(1, 32, kernel_size=3, padding=1),
            nn.GELU(),
            nn.Conv1d(32, 64, kernel_size=3, padding=1),
            nn.InstanceNorm1d(64),
            nn.GELU(),
            nn.Conv1d(64, 128, kernel_size=3, padding=1),
            nn.InstanceNorm1d(64),
            nn.GELU(),

            # Block 2 (2 conv layers)
            nn.Conv1d(128, 128, kernel_size=7, padding=(7 - 1) // 2),
            nn.InstanceNorm1d(128),
            nn.GELU(),
            nn.Conv1d(128, 256, kernel_size=7, padding=3),
            nn.InstanceNorm1d(256),
            nn.GELU(),

            # Block 3 (3 conv layers)
            nn.Conv1d(256, 384, kernel_size=11, padding=(11 - 1) // 2),
            nn.InstanceNorm1d(384),
            nn.GELU(),
            nn.Conv1d(384, 256, kernel_size=11, padding=(11 - 1) // 2),
            nn.InstanceNorm1d(256),
            nn.GELU(),
            
            # Block 4 (3 conv layers)
            nn.Conv1d(256, 128, kernel_size=13, padding=(11 - 1) // 2),
            nn.InstanceNorm1d(128),
            nn.GELU(),
            nn.Conv1d(128, 128, kernel_size=13, padding=(13 - 1) // 2),
            nn.InstanceNorm1d(128),
            nn.GELU(),
            nn.Conv1d(128, 64, kernel_size=13, padding=(13 - 1) // 2),
            nn.InstanceNorm1d(64),
            nn.GELU(),
            nn.Conv1d(64, 32, kernel_size=13, padding=(13 - 1) // 2),
            nn.InstanceNorm1d(32),
            nn.GELU(),
        )
        
        # 动态计算全连接层输入维度
        self._init_fc(input_length)
        
        # 分类头
        self.classifier = nn.Sequential(
            nn.Linear(32 * 21, 336),
            nn.GELU(),
            # nn.Dropout(0.5),
            nn.Linear(336, 256),
            # nn.GELU(),
            nn.Dropout(0.03),
            nn.Linear(256, num_classes)
        )
        

    def _init_fc(self, input_length):
        """自动计算全连接层输入维度"""
        dummy_input = torch.randn(1, 1, input_length)
        with torch.no_grad():
            dummy_output = self.features(dummy_input)
        self.fc_input_dim = dummy_output.view(-1).shape[0]

    def forward(self, x):
        x = self.features(x)
        x = x.view(x.size(0), -1)
        return self.classifier(x)

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
        self.accuracy(y_pred, y)
        self.precision(y_pred, y)
        self.recall(y_pred, y)
        self.f1_score(y_pred, y)

        values = {"loss": loss,"accuracy": self.accuracy,"precision": self.precision,"recall": self.recall,"f1_score": self.f1_score}
        self.log_dict(values, prog_bar=True)
        return values

    def configure_optimizers(self):
        optimizer = torch.optim.SGD(self.parameters(), lr=self.learning_rate)
        scheduler = {
            'scheduler': torch.optim.lr_scheduler.StepLR(optimizer, step_size=10, gamma=0.1),
            'interval': 'epoch',  # Update the learning rate every epoch
            'frequency': 4,       # ApLy the scheduler once every epoch
        }
        return [optimizer], [scheduler]
    
def train_traffic_classification_vgg_model(traindata_path, testdata_path,model_path):
    L.seed_everything(42)
    traindata_loader = train_dataloader(traindata_path,batch_size=48)
    testdata_loader = train_dataloader(testdata_path,batch_size=2048, train=False)
    # train_set, valid_set = data.random_split(train_set, [train_set_size, valid_set_size], generator=seed)
    logger = TensorBoardLogger("tb_logs", name="VGG_model")
    model = VGG1D(num_classes=2) 
    # model = torch.compile(model)
    trainer = L.Trainer(logger=logger,max_epochs=60,# val_check_interval=1.0,
        # callbacks=[EarlyStopping(monitor="training_loss", mode="min", check_on_train_epoch_end=True)],
    )
    trainer.fit(model, train_dataloaders=traindata_loader)
    # 计算指标
    val = trainer.test(model, testdata_loader)
    print(val)
    script = model.to_torchscript()  # 无需传入文件路径
    # 定义保存路径
    save_path = os.path.join(model_path, "vgg_model.pt")
    # 保存 TorchScript 模型
    torch.jit.save(script, save_path)

if __name__ == "__main__":
    train_traffic_classification_vgg_model("dataset/csv/ScenarioB-CSV/TimeBasedFeatures-Dataset-15s-Train.csv","dataset/csv/ScenarioB-CSV/testdataset.csv","models/traffic_classifcation_vgg_model") #correct_samplesNew
    # tensorboard --logdir tb_logs/
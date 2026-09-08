import torch
import torch.nn as nn
import torchmetrics
import torch
import torch.nn as nn
import lightning as L
import torchmetrics
from DataModule import NB15DataModule
from lightning.pytorch.loggers import TensorBoardLogger
import os

class ResidualBlock(nn.Module):
    def __init__(self, in_channels, out_channels, kernel_size, padding):
        super(ResidualBlock, self).__init__()
        self.conv1 = nn.Conv1d(in_channels, out_channels, kernel_size, padding=padding)
        self.bn1 = nn.BatchNorm1d(out_channels)
        self.act1 = nn.GELU()
        self.conv2 = nn.Conv1d(out_channels, out_channels, kernel_size, padding=padding)
        # self.bn2 = nn.BatchNorm1d(out_channels)
        self.act2 = nn.GELU()
        
        # 确保输入和输出维度匹配
        self.shortcut = nn.Conv1d(in_channels, out_channels, kernel_size=1) if in_channels != out_channels else None

    def forward(self, x):
        identity = x if self.shortcut is None else self.shortcut(x)
        out = self.conv1(x)
        out = self.bn1(out)
        out = self.act1(out)
        out = self.conv2(out)
        # out = self.bn2(out)
        out += identity  # 残差连接
        out = self.act2(out)
        return out
    
class MyImprovedModel(L.LightningModule):
    def __init__(self, num_classes: int = 10, learning_rate: float = 0.001):
        super(MyImprovedModel, self).__init__()
        self.save_hyperparameters()
        self.num_classes = num_classes
        self.learning_rate = learning_rate
        
        metrics_kwargs = {
            "task": "multiclass",
            "num_classes": num_classes,
            # "average": "macro"  # 添加平均方式
        }
        
        # 训练指标
        self.train_metrics = torchmetrics.MetricCollection(
            {
                "acc":torchmetrics.Accuracy(num_classes=num_classes, task="multiclass"),
                # "precision":torchmetrics.Precision(num_classes=num_classes, task="multiclass"),
                # "recall":torchmetrics.Recall(num_classes=num_classes, task="multiclass"),
                # "f1_score":torchmetrics.F1Score(num_classes=num_classes, task="multiclass")
            },
            prefix="train_",
        )
        # 验证指标
        self.val_metrics = self.train_metrics.clone(prefix="valid_")
        # Log file for metrics
        self.log_file = "metrics_log.txt"

        # Initialize the log file
        with open(self.log_file, "w") as f:
            f.write("epoch,val_loss,val_accuracy,val_precision,val_recall,val_f1_score\n")

        self.proj_layer = nn.Sequential(
            nn.InstanceNorm1d(1),
            ResidualBlock(1, 16, kernel_size=63, padding=31),
            ResidualBlock(16, 16, kernel_size=33, padding=16),
            ResidualBlock(16, 32, kernel_size=13, padding=6),
            ResidualBlock(32, 32, kernel_size=7, padding=3),
            ResidualBlock(32, 64, kernel_size=3, padding=1),
            ResidualBlock(64, 64, kernel_size=3, padding=1)
        )

        self.lstm2 = nn.LSTM(input_size=64, hidden_size=128, batch_first=True, bidirectional=True, num_layers=4, dropout=0.3)

        self.dropout = nn.Dropout(0.03)          
        self.fc = nn.Sequential(nn.Linear(256, 128),
                                nn.BatchNorm1d(128),
                                nn.GELU(),
                                nn.Linear(128, 64),
                                nn.BatchNorm1d(64),
                                nn.GELU(),
                                nn.Linear(64, self.num_classes))
        self.gelu = nn.GELU()

    def forward(self, x):
        # input [batch_size, 1, 155]
        x = self.proj_layer(x) # [batch_size, channel, 155]
        # LSTM Layer 1
        x = x.permute(0, 2, 1)  # (batch_size, seq_len, features)
        x, _ = self.lstm2(x)
        x = x[:, -1, :]
        # Final Dropout and Fully Connected Layer
        x = self.dropout(x)     # x = self.adaptive_layer(x)
        x = self.fc(x)
        return x
    
    def training_step(self, batch, batch_idx):
        x, y = batch
        y_hat = self(x)
        loss = nn.functional.cross_entropy(y_hat, y)
        y_pred = torch.argmax(y_hat, dim=1)
        batch_value = self.train_metrics(y_pred, y)
        self.log_dict(batch_value, prog_bar=True, on_step=False, on_epoch=True)
        return loss

    def on_train_epoch_end(self):
        self.train_metrics.reset()

    def validation_step(self, batch, batch_idx):
        x, y = batch
        y_hat = self(x)
        loss = nn.functional.cross_entropy(y_hat, y)
        y_pred_val = torch.argmax(y_hat, dim=1)
        
        # 更新验证指标
        self.val_metrics.update(y_pred_val, y)
        # 仅记录验证loss
        return loss

    def on_validation_epoch_end(self):
        # 计算并记录验证指标
        self.log_dict(self.val_metrics.compute(),prog_bar=True, on_step=False, on_epoch=True)
        self.val_metrics.reset()
        
    # def test_step(self, batch, batch_idx):
    #     x, y = batch
    #     y_hat = self(x)
    #     loss = nn.functional.cross_entropy(y_hat, y)
    #     values = {"loss": loss, "accuracy": self.accuracy(y_hat, y)}
    #     self.log_dict(values, prog_bar=True)
    #     return self.accuracy(y_hat, y)

    def configure_optimizers(self):
        optimizer = torch.optim.Adam(self.parameters(), lr=self.learning_rate) # Adam
        scheduler = {
            'scheduler': torch.optim.lr_scheduler.StepLR(optimizer, step_size=10, gamma=0.1),
            'interval': 'epoch',  
            'frequency': 5,       
        }
        return [optimizer], [scheduler]

if __name__ == "__main__":
    dm = NB15DataModule('dataset/CSV Files/chrTrainingandTestingSets', batchsize=3064)  # 2048
    logger = TensorBoardLogger("tb_logs", name="lstm")
    model = MyImprovedModel(num_classes=8, learning_rate=0.002)
    trainer = L.Trainer(logger=logger, max_epochs=150, check_val_every_n_epoch=5) # 
    trainer.fit(model, datamodule=dm)
    script = model.to_torchscript()  # 无需传入文件路径
    # 定义保存路径
    save_path = os.path.join('models', "LSTM_model.pt")
    # 保存 TorchScript 模型
    torch.jit.save(script, save_path)
import torch
import torch.nn as nn
import lightning as L
import torchmetrics
from DataModuleBinary import NB15DataModule
import optuna
import json
import torch.nn.functional as F
import math

class ResidualBlock(nn.Module):
    def __init__(self, in_channels, out_channels, kernel_size, stride=1):
        super(ResidualBlock, self).__init__()
        
        # 计算 padding 值以保持输出长度
        padding = int(math.ceil((kernel_size - 1)) / 2)  # 确保输出长度不变
        
        self.conv1 = nn.Conv1d(in_channels, out_channels, kernel_size, stride=stride, padding='same')
        self.bn1 = nn.BatchNorm1d(out_channels)
        self.conv2 = nn.Conv1d(out_channels, out_channels, kernel_size, stride=1, padding='same')
        self.bn2 = nn.BatchNorm1d(out_channels)
        
        # 如果输入和输出的通道数不一致，需要用1x1卷积调整维度
        self.shortcut = nn.Sequential()
        if in_channels != out_channels or stride != 1:
            self.shortcut = nn.Sequential(
                nn.Conv1d(in_channels, out_channels, kernel_size=1, stride=stride),
                nn.BatchNorm1d(out_channels)
            )

    def forward(self, x):
        residual = x
        out = F.relu(self.bn1(self.conv1(x)))
        out = self.bn2(self.conv2(out))
        out += self.shortcut(residual)  # 残差连接
        out = F.relu(out)
        return out

# 定义50层ResNet
class ResNet1D(L.LightningModule):
    def __init__(self, num_blocks=[1, 1, 2, 2], num_classes=10,learning_rate: float = 0.001):
        super(ResNet1D, self).__init__()
        self.in_channels = 64
        self.save_hyperparameters()
        self.num_classes = num_classes
        self.learning_rate = learning_rate
        self.accuracy = torchmetrics.Accuracy(task="multiclass", num_classes=self.num_classes)
        
        # 初始卷积层
        self.conv1 = nn.Conv1d(1, 64, kernel_size=64, padding='same')
        self.bn1 = nn.BatchNorm1d(64)
        
        # 残差块堆叠
        self.layer1 = self._make_layer(64, 64, num_blocks[0], kernel_size=63)
        self.layer2 = self._make_layer(64, 128, num_blocks[1], kernel_size=31, )
        self.layer3 = self._make_layer(128, 256, num_blocks[2], kernel_size=15 )
        self.layer4 = self._make_layer(256, 512, num_blocks[3], kernel_size=7 )
        
        # 全局平均池化和全连接层
        self.avg_pool = nn.AdaptiveAvgPool1d(1)
        self.fc = nn.Linear(512, num_classes)

    def _make_layer(self, in_channels, out_channels, num_blocks, kernel_size, stride=1):
        layers = []
        layers.append(ResidualBlock(in_channels, out_channels, kernel_size, stride))
        for _ in range(1, num_blocks):
            layers.append(ResidualBlock(out_channels, out_channels, kernel_size))
        return nn.Sequential(*layers)

    def forward(self, x):
        out = F.relu(self.bn1(self.conv1(x)))
        out = self.layer1(out)
        out = self.layer2(out)
        out = self.layer3(out)
        out = self.layer4(out)
        out = self.avg_pool(out)
        out = out.view(out.size(0), -1)  # 展平
        out = self.fc(out)
        return out

    def training_step(self, batch, batch_idx):
        x, y = batch
        y_hat = self(x)
        print(y_hat,type(y_hat))
        loss = nn.functional.cross_entropy(y_hat, y)
        values = {"loss": loss, "accuracy": self.accuracy(y_hat, y)}
        self.log_dict(values, prog_bar=True)
        return loss
    
    def test_step(self, batch, batch_idx):
        x, y = batch
        y_hat = self(x)
        loss = nn.functional.cross_entropy(y_hat, y)
        values = {"loss": loss, "accuracy": self.accuracy(y_hat, y)}
        self.log_dict(values, prog_bar=True)
        return self.accuracy(y_hat, y)

    def configure_optimizers(self):
        optimizer = torch.optim.Adam(self.parameters(), lr=self.learning_rate)
        scheduler = {
            'scheduler': torch.optim.lr_scheduler.StepLR(optimizer, step_size=10, gamma=0.1),
            'interval': 'epoch',  # Update the learning rate every epoch
            'frequency': 1,       # Apply the scheduler once every epoch
        }
        return [optimizer], [scheduler]
        # return torch.optim.SGD(self.parameters(), lr=self.learning_rate)
        # return torch.optim.Adam(self.parameters(), lr=self.learning_rate)
        # return torch.optim.Adam(self.parameters(), lr=0.001)

def objective(trial):
    dm = NB15DataModule('dataset/CSV Files/Training and Testing Sets', batchsize=2048)
    model = ResNet1D(num_classes=2, learning_rate=trial.suggest_float("lr", 1e-5, 1e-1, log=True))
    trainer = L.Trainer(max_epochs=50)
    trainer.fit(model, datamodule=dm)
    acc = trainer.test(model, datamodule=dm)
    script = model.to_torchscript()
    # save for use in production environment
    torch.jit.save(script, "preliminaryModelRESNET.pt")
    return acc[0].get("accuracy")

if __name__=="__main__":
    study = optuna.create_study(direction="maximize")
    study.optimize(objective, n_trials=10)
    print("Best parameters:", study.best_params)
    print("Best Value:", study.best_value)
    # 输出最佳参数
    print("Best trial:")
    trial = study.best_trial
    print(f"  Value: {trial.value}")
    print("  Params:")
    for key, value in trial.params.items():
        print(f"    {key}: {value}")

    # 保存最佳参数
    with open('best_params.json', 'w') as f:
        json.dump(trial.params, f)
    # dm = NB15DataModule('dataset/CSV Files/Training and Testing Sets', batchsize=1024)
    # model = MyModel(num_classes=10, learning_rate=0.001)
    # trainer = L.Trainer(max_epochs=150)
    # tuner = Tuner(trainer)
    # lr_finder = tuner.lr_find(model, datamodule=dm)
    # print(lr_finder.results)
    # fig = lr_finder.plot(suggest=True)
    # fig.show()

    # Pick point based on plot, or get suggestion
    # new_lr = lr_finder.suggestion()
    # model.hparams.lr = new_lr
    # trainer.fit(model, datamodule=dm)
    # trainer.test(model, datamodule=dm)
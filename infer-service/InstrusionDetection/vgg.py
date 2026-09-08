import torch
import torch.nn as nn
import lightning as L
import torchmetrics
from DataModuleBinary import NB15DataModule
import optuna
import json
import torch.nn.functional as F
import math
from torchvision import models

# 定义50层ResNet
class VGG1D(L.LightningModule):
    def __init__(self, num_classes=10,learning_rate: float = 0.001):
        super(VGG1D, self).__init__()
        self.save_hyperparameters()
        self.num_classes = num_classes
        self.learning_rate = learning_rate
        self.accuracy = torchmetrics.Accuracy(task="multiclass", num_classes=self.num_classes)
        
        # 第一个卷积块：输入通道 1，输出通道 64
        self.conv_block1 = nn.Sequential(
            nn.Conv1d(1, 64, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.Conv1d(64, 64, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool1d(kernel_size=2, stride=2)
        )

        # 第二个卷积块：输出通道 128
        self.conv_block2 = nn.Sequential(
            nn.Conv1d(64, 128, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.Conv1d(128, 128, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool1d(kernel_size=2, stride=2)
        )

        # 第三个卷积块：输出通道 256
        self.conv_block3 = nn.Sequential(
            nn.Conv1d(128, 256, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.Conv1d(256, 256, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool1d(kernel_size=2, stride=2)
        )

        # 全连接层
        self.fc = nn.Sequential(
            nn.Linear(256 * (193 // 8), 512),  # 根据输入长度和池化次数计算特征维度
            nn.ReLU(),
            nn.Dropout(0.5),
            nn.Linear(512, num_classes)
        )

    def forward(self, x):
        # torch.Size([2048, 1, 193])
        # After Block1: torch.Size([2048, 64, 96])
        # After Block2: torch.Size([2048, 128, 48])
        # After Block3: torch.Size([2048, 256, 24])
        # 卷积块部分
        out = self.conv_block1(x)
        # print("After Block1:", out.size())  # 打印中间形状，方便调试

        out = self.conv_block2(out)
        # print("After Block2:", out.size())

        out = self.conv_block3(out)
        # print("After Block3:", out.size())

        # 展平处理
        out = out.view(out.size(0), -1)
        # print("Flattened shape:", out.size())

        # 全连接层部分
        out = self.fc(out)
        return out

    def training_step(self, batch, batch_idx):
        x, y = batch
        y_hat = self(x)
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
    model = VGG1D(num_classes=2, learning_rate=trial.suggest_float("lr", 1e-5, 1e-1, log=True))
    trainer = L.Trainer(max_epochs=50)
    trainer.fit(model, datamodule=dm)
    acc = trainer.test(model, datamodule=dm)
    script = model.to_torchscript()
    # save for use in production environment
    torch.jit.save(script, "preliminaryModelVGG.pt")
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
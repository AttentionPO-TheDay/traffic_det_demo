import argparse
import torch
from torch.utils.data import DataLoader, Dataset
import numpy as np
import pandas as pd
from torchmetrics import Accuracy, Precision, Recall, F1Score, ConfusionMatrix
import json
import os
from pathlib import Path
import matplotlib.pyplot as plt
import seaborn as sns

os.environ["QT_QPA_PLATFORM"] = "offscreen"

class CustomDataset(Dataset):
    def __init__(self, df):
        self.df = df  # 保存完整的DataFrame
        self.features = df.iloc[:, 1:].values
        self.labels = df.iloc[:, 0].values
        self.indices = df.index.values  # 保存原始索引

    def __len__(self):
        return len(self.labels)

    def __getitem__(self, idx):
        feature = torch.tensor(np.array([self.features[idx]]), dtype=torch.float32)
        label = torch.tensor(self.labels[idx], dtype=torch.long)
        index = self.indices[idx]
        return feature, label, index  # 返回特征、标签和索引

def create_dataloader(datapath, batch_size=48, train=False, num_class:int=2):
    data_frame = pd.read_csv(datapath)
    
    # 处理不同类别数的数据
    if num_class == 2:
        y = data_frame.iloc[:, 0] #标签
        mapped_y = np.where(y < 6, 0, 1)
        mapped_y = pd.Series(mapped_y)
        resampled_df = pd.concat([mapped_y, data_frame.iloc[:, 1:]], axis=1)
    else:
        resampled_df = data_frame
    
    resampled_df = resampled_df.reset_index(drop=True)  # 重置索引
    dataset = CustomDataset(resampled_df)
    return DataLoader(dataset, batch_size=batch_size, shuffle=train, num_workers=6, pin_memory=True), resampled_df

def main(args):
    # 初始化评估指标
    # 初始化评估指标
    if args.task == "binary":
        # 二分类配置（保持不变）
        accuracy_kwargs = {"task": "binary", "threshold": 0.5}
        prf_kwargs = {"task": "binary", "threshold": 0.5}
        cm_config = {"task": "binary", "threshold": 0.5}
    else:
        # 多分类配置修正
        accuracy_kwargs = {
            "task": "multiclass",
            "num_classes": args.num_class
        }
        prf_kwargs = {
            "task": "multiclass",
            "num_classes": args.num_class,
            "average": "macro"  # 仅限P/R/F使用宏平均
        }
        cm_config = {
            "task": "multiclass",
            "num_classes": args.num_class
        }

    # 初始化指标（关键修正）
    accuracy = Accuracy(**accuracy_kwargs)
    precision = Precision(**prf_kwargs)
    recall = Recall(**prf_kwargs)
    f1 = F1Score(**prf_kwargs)
    cm = ConfusionMatrix(**cm_config)

    # 加载模型和数据
    # model = torch.jit.load(args.model, map_location=torch.device('cuda:0'))
    device = torch.device("cpu") # 强制使用CPU
    model = torch.jit.load(args.model, map_location=device)
    data_loader, resampled_df = create_dataloader(
        args.dpath, 
        batch_size=2048, 
        train=False, 
        num_class=args.num_class
    )

    # 存储完整预测结果
    all_preds = []
    all_targets = []
    all_indices = []

    model.eval()
    with torch.no_grad():
        for features, labels, indices in data_loader:
            # outputs = model(features.float().to("cuda:0"))
            outputs = model(features.float().to(device))
            preds = torch.argmax(outputs, dim=1)
            
            all_preds.append(preds.cpu())
            all_targets.append(labels.cpu())
            all_indices.append(indices.cpu())

    # 合并所有batch结果
    full_preds = torch.cat(all_preds)
    full_targets = torch.cat(all_targets)
    full_indices = torch.cat(all_indices)

    # 转换为numpy数组
    full_preds_np = full_preds.numpy()
    full_targets_np = full_targets.numpy()
    full_indices_np = full_indices.numpy()

    # 创建正确/错误样本掩码
    correct_mask = (full_preds_np == full_targets_np)
    correct_indices = full_indices_np[correct_mask]
    wrong_indices = full_indices_np[~correct_mask]

    # 提取对应样本数据
    correct_samples = resampled_df.iloc[correct_indices]
    wrong_samples = resampled_df.iloc[wrong_indices]

    # 创建输出目录
    output_dir = Path(args.output)
    output_dir.mkdir(parents=True, exist_ok=True)

    # 保存样本数据
    correct_path = output_dir / "correct_samples.csv"
    wrong_path = output_dir / "wrong_samples.csv"
    correct_samples.to_csv(correct_path, index=False)
    wrong_samples.to_csv(wrong_path, index=False)
    # 计算混淆矩阵
    confmat = cm(full_preds, full_targets).cpu().numpy()
    # 计算评估指标
    metrics = {
        "accuracy": accuracy(full_preds, full_targets).item(),
        "precision": precision(full_preds, full_targets).item(),
        "recall": recall(full_preds, full_targets).item(),
        "f1_score": f1(full_preds, full_targets).item(),
        "confusion_matrix": confmat.tolist()
    }

    # 新增TPR和FPR计算
    n_classes = confmat.shape[0]
    tpr_list = []
    fpr_list = []
    for i in range(n_classes):
        tp = confmat[i, i]
        fn = confmat[i, :].sum() - tp
        fp = confmat[:, i].sum() - tp
        tn = confmat.sum() - (tp + fn + fp)
        
        tpr = tp / (tp + fn) if (tp + fn) != 0 else 0.0
        fpr = fp / (fp + tn) if (fp + tn) != 0 else 0.0
        
        tpr_list.append(float(tpr))
        fpr_list.append(float(fpr))
    
    metrics["tpr_per_class"] = tpr_list
    metrics["fpr_per_class"] = fpr_list
    metrics["macro_tpr"] = float(np.mean(tpr_list))
    metrics["macro_fpr"] = float(np.mean(fpr_list))


    # 保存评估结果
    results_path = output_dir / f"{Path(args.model).stem}_results.json"
    with open(results_path, "w") as f:
        json.dump(metrics, f, indent=4)

    # 绘制混淆矩阵
    confmat = cm(full_preds, full_targets).cpu().numpy()
    plt.figure(figsize=(8, 6))
    sns.heatmap(confmat, annot=True, fmt='d', cmap='Blues', cbar=False)
    plt.xlabel('Predicted')
    plt.ylabel('Actual')
    plt.title('Confusion Matrix')

    # 4. 保存图片
    plt.savefig(output_dir / f'{Path(args.model).stem}_confusionmatrix.png', dpi=300, bbox_inches='tight')
    plt.close()
    # print(f"\n评估结果已保存至: {results_path}")
    # print(f"正确样本保存至: {correct_path}")
    # print(f"错误样本保存至: {wrong_path}")
    print("\n详细指标:")
    print(json.dumps(metrics, indent=2))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="模型评估")
    parser.add_argument("--model", type=str, default="models/traffic_classifcation_resnet_model/resnet_model.pt")
    parser.add_argument("--dpath", type=str, default="dataset/csv/ScenarioB-CSV/correct_samplesNew.csv")
    parser.add_argument("--num_class", type=int, default=2)
    parser.add_argument("--output", type=str, default="evaluationResults")
    parser.add_argument("--task", type=str, default="binary", choices=["binary", "multiclass"])
    
    args = parser.parse_args()
    main(args) # python evaluateCSV.py --model models/traffic_classifcation_transformer_model/transformer_model.pt --dpath dataset/csv/ScenarioB-CSV/TimeBasedFeatures-Dataset-15s-TestMulti.csv --num_class 12 --task multiclass --output evaluationResults
    
# python evaluateCSV.py --model models/traffic_classifcation_vgg_model/vgg_model.pt --dpath dataset/csv/ScenarioB-CSV/testdataset.csv --num_class 2 --task binary --output evaluationResults/vgg
# python evaluateCSV.py --model models/traffic_classifcation_resnet_model/resnet_model.pt --dpath dataset/csv/ScenarioB-CSV/testdataset.csv --num_class 2 --task binary --output evaluationResults/resnet
# python evaluateCSV.py --model models/traffic_classifcation_transformer_model/transformer_model.pt --dpath dataset/csv/ScenarioB-CSV/testdataset.csv --num_class 12 --task multiclass --output evaluationResults/transformer
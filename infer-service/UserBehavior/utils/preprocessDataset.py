import pandas as pd
import json

# 读取CSV文件
df = pd.read_csv('dataset/csv/ScenarioB-CSV/TimeBasedFeatures-Dataset-15s.csv')
df = df[~df['class1'].isin(['P2P', 'VPN-P2P'])] # 删除类别

df.sort_values(by='class1', ascending=True, inplace=True) # 按照某列排序
# 提取标签列
labels = df.iloc[:, -1].astype(str)

# 生成编码映射
unique_labels = labels.unique()
label_to_code = {label: idx for idx, label in enumerate(unique_labels)}

# 保存编码映射到JSON文件
with open('utils/label_mapping.json', 'w') as f:
    json.dump(label_to_code, f, indent=4)

# 生成编码后的标签列
encoded_labels = labels.map(label_to_code)

# 将编码后的标签添加到DataFrame
df['encoded_label'] = encoded_labels

# 添加 binary_label 列，包含 "VPN" 的标签为 1，否则为 0
df['binary_label'] = labels.str.contains("VPN").astype(int)

# 保存新的CSV文件
df.to_csv('dataset/csv/ScenarioB-CSV/TimeBasedFeatures-Dataset-15s-New.csv', index=False)

print("新的CSV文件已成功保存。")
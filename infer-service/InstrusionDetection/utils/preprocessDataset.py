import pandas as pd
import json

# 读取CSV文件
df = pd.read_csv('../dataset/CSV Files/chrTrainingandTestingSets/UNSW_NB15_testing-set.csv')
df = df[~df['attack_cat'].isin(["Normal"])] # 删除类别
df = df[df['attack_cat'] != 'Worms'] # 删除极少样本类别，对8种异常流量分类

df.sort_values(by='attack_cat', ascending=True, inplace=True) # 按照某列排序
# 提取标签列
labels = df.iloc[:, -2].astype(str)
protos = df.iloc[:, 2].astype(str)

# 生成编码映射
unique_labels = labels.unique()
label_to_code = {label: idx for idx, label in enumerate(unique_labels)}

protos_to_code = {proto: idx for idx, proto in enumerate(protos.unique())}

# 保存编码映射到JSON文件
with open('label_mapping.json', 'w') as f:
    json.dump(label_to_code, f, indent=4)
with open('proto_mapping.json', 'w') as f:
    json.dump(protos_to_code, f, indent=4)

# 生成编码后的标签列
encoded_labels = labels.map(label_to_code)
encoded_protos = protos.map(protos_to_code)
# 将编码后的标签添加到DataFrame
df['encoded_label'] = encoded_labels
df['proto'] = encoded_protos
# 添加 binary_label 列，包含 "VPN" 的标签为 1，否则为 0
# df['binary_label'] = labels.str.contains("VPN").astype(int)

# 保存新的CSV文件
df.to_csv('../dataset/CSV Files/chrTrainingandTestingSets/UNSW_NB15_testing-set2.csv', index=False)

print("新的CSV文件已成功保存。")
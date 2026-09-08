import lightning as L
from torchvision import transforms
import pandas as pd
from torch.utils.data import Dataset, DataLoader
from imblearn.over_sampling import RandomOverSampler
from imblearn.under_sampling import RandomUnderSampler
import joblib
import numpy as np
import torch
from sklearn.model_selection import train_test_split 

#One-hot encoding
def one_hot(df, cols):
    """
    @param df pandas DataFrame
    @param cols a list of columns to encode
    @return a DataFrame with one-hot encoding
    """
    for each in cols:
        dummies = pd.get_dummies(df[each], prefix=each, drop_first=True)
        df = pd.concat([df, dummies], axis=1)
        df = df.drop(each, axis=1)
    return df

#Function to min-max normalize
def normalize(df, cols):
    """
    @param df pandas DataFrame
    @param cols a list of columns to encode
    @return a DataFrame with normalized specified features
    """
    result = df.copy() # do not touch the original df
    for feature_name in cols:
        max_value = df[feature_name].max()
        min_value = df[feature_name].min()
        if max_value > min_value:
            result[feature_name] = (df[feature_name] - min_value) / (max_value - min_value)
    return result

class CustomDataset(Dataset):
    def __init__(self, features, labels):
        """
        Initialize the dataset with features and labels.
        
        @param features: The input features.
        @param labels: The target labels.
        """
        self.features = torch.tensor(features, dtype=torch.float32)
        self.labels = torch.tensor(labels, dtype=torch.long)
        

    def __len__(self):
        """Return the total number of samples."""
        return len(self.labels)

    def __getitem__(self, idx):
        """Retrieve the sample at the given index."""
        return self.features[idx], self.labels[idx]
    

class NB15DataModule(L.LightningDataModule):
    def __init__(self, data_dir:str="path/to/dir", batchsize:int=32):
        super().__init__()
        self.data_dir = data_dir
        self.batch_size = batchsize
        self.tranform = transforms.Compose([
            transforms.ToTensor(),])
        
    # 异常值检测与处理
    def handle_outliers(df, k=1.5, method='clip'):
        """
        对数据框 df 的数值列执行 IQR 异常值处理。
        - method 'clip': 将超出阈值的值截断到阈值边界
        - method 'remove': 直接删除包含异常值的样本
        返回处理后的 DataFrame、以及一个布尔型 Series 标识哪些样本被移除了（若使用 remove）。
        """
        numeric_cols = df.select_dtypes(include=[np.number]).columns
        if len(numeric_cols) == 0:
            return df, pd.Series([False] * len(df), index=df.index)

        # 计算每列的 Q1, Q3, IQR
        Q1 = df[numeric_cols].quantile(0.25)
        Q3 = df[numeric_cols].quantile(0.75)
        IQR = Q3 - Q1
        lower_bound = Q1 - k * IQR
        upper_bound = Q3 + k * IQR

        # 逐行检查是否有任意数值列超过边界
        out_of_bounds = (df[numeric_cols] < lower_bound) | (df[numeric_cols] > upper_bound)
        # 行级布尔，用于判定整行是否包含异常值
        row_has_outlier = out_of_bounds.any(axis=1)

        if method == 'remove':
            # 仅保留没有异常值的样本
            df_clean = df[~row_has_outlier].copy()
            return df_clean, row_has_outlier
        else:
            # clip: 对超出边界的值进行截断
            df_copy = df.copy()
            for col in numeric_cols:
                df_copy[col] = df_copy[col].clip(lower_bound[col], upper_bound[col])
            return df_copy, row_has_outlier
        
    def setup(self, stage: str):  
        # 读取原始数据集
        train_df = pd.read_csv(f"{self.data_dir}/UNSW_NB15_training-set2.csv") # dataframe格式化读取
        test_df = pd.read_csv(f"{self.data_dir}/UNSW_NB15_testing-set2.csv") # dataframe格式化读取
        
        # 统一数据预处理
        def preprocess(df):
            df = df.drop(['id', 'label','encoded_label'], axis=1) # 删除无关字段
            df = df[df['attack_cat'] != 'Normal']  # 删除无关类别
            df = df[df['attack_cat'] != 'Worms']   # 删除无关类别
            df = df.replace({True: 1, False: 0})   # 重组
            return df
        
        # 处理数据集
        train_df = preprocess(train_df)
        train_df.drop_duplicates(inplace=True)  # 删除重复样本
        train_df.dropna(inplace=True)           # 删除缺失样本
        # 创建标签编码映射
        attack_categories = train_df['attack_cat'].astype('category')
        self.label_mapping = dict(enumerate(attack_categories.cat.categories))
        
        # 保存标签映射到文件
        import json
        with open(f"{self.data_dir}/label_mapping.json", 'w') as f:
            json.dump(self.label_mapping, f, indent=4)
        
        self.y_train = attack_categories.cat.codes.values
        self.x_train = train_df.drop('attack_cat', axis=1).values
        
        # 处理测试集 
        test_df = preprocess(test_df)
        self.y_test = test_df['attack_cat'].astype(
            'category').cat.rename_categories(self.label_mapping).cat.codes.values
        self.x_test = test_df.drop('attack_cat', axis=1).values
        
        # 数据标准化（仅用训练集参数）
        from sklearn.preprocessing import StandardScaler
        scaler = StandardScaler().fit(pd.concat([pd.DataFrame(self.x_train), pd.DataFrame(self.x_test)], axis=0))
        self.x_train = scaler.transform(self.x_train)
        self.x_test = scaler.transform(self.x_test)
        # 保存标准化参数
        joblib.dump(scaler, 'scaler.pkl')  # 将标准化参数保存到文件
        # 转换为3D张量格式 [samples, channels, features]
        self.x_train = self.x_train.reshape(-1, 1, self.x_train.shape[1])
        self.x_test = self.x_test.reshape(-1, 1, self.x_test.shape[1])
        
        # 创建数据集
        if stage == "fit":
            self.data_train = CustomDataset(self.x_train, self.y_train)
        elif stage == "test":
            self.data_test = CustomDataset(self.x_test, self.y_test)

    # def setup(self, stage:str):
    #     df = pd.read_csv(f"{self.data_dir}/UNSW_NB15_training-set.csv")
    #     qp = pd.read_csv(f"{self.data_dir}/UNSW_NB15_testing-set.csv")
    #     df = df.drop('id', axis=1) # we don't need it in this project
    #     df = df.drop('label', axis=1) # we don't need it in this project
    #     qp = qp.drop('id', axis=1)
    #     qp = qp.drop('label', axis=1)

    #     # cols = [] # 'proto','state','service'
    #     combined_data = pd.concat([df,qp])
    #     combined_data = combined_data[combined_data['attack_cat'] != 'Normal'] # 删除正常流量样本，仅对异常流量分类
    #     # combined_data = combined_data[combined_data['attack_cat'] != 'Worms'] # 删除极少样本类别，对8种异常流量分类

    #     tmp = combined_data.pop('attack_cat')
    #     # combined_data = one_hot(combined_data,cols)
    #     combined_data.replace({True: 1, False: 0},inplace=True)
    #     new_train_df = normalize(combined_data,combined_data.columns)
    #     new_train_df["Class"] = tmp
    #     y_train=new_train_df["Class"]
    #     combined_data_X = new_train_df.drop('Class', axis=1)
    #     oversample = RandomOverSampler(sampling_strategy='minority')
    #     train_X, test_X = combined_data_X, combined_data_X
    #     train_y, test_y = y_train, y_train
    #     # train_X, test_X, train_y, test_y = train_test_split(combined_data_X,y_train, test_size=0.0, random_state=40)
    #     # train_X_over,train_y_over=train_X,train_y
    #     train_X_over,train_y_over= oversample.fit_resample(train_X, train_y)
        
    #     x_columns_train = new_train_df.columns.drop('Class')
    #     x_train_array = train_X_over[x_columns_train].values
    #     self.x_train_1=np.reshape(x_train_array, (x_train_array.shape[0],1, x_train_array.shape[1]))
        
    #     dummies = pd.get_dummies(train_y_over) # Classification
    #     y_train_1 = dummies.values
    #     self.y_train_1 = np.argmax(y_train_1.astype(int),axis=1) # crossEntropy 标签不需要独热编码
    #     x_columns_test = new_train_df.columns.drop('Class')
    #     x_test_array = test_X[x_columns_test].values
    #     self.x_test_2=np.reshape(x_test_array, (x_test_array.shape[0],1, x_test_array.shape[1]))
    #     dummies_test = pd.get_dummies(test_y) # Classification
    #     y_test_2 = dummies_test.values
    #     self.y_test_2 = np.argmax(y_test_2.astype(int),axis=1) # crossEntropy 标签不需要独热编码
    #     if stage == "fit":
    #         self.data_train = CustomDataset(self.x_train_1, self.y_train_1)
    #     elif stage == "test":
    #         self.data_test = CustomDataset(self.x_test_2, self.y_test_2)
            
    #     elif stage == "predict":
    #         raise NotImplementedError
            # self.data_predict = pd.read_csv(f"{self.data_dir}/UNSW_NB15_predict-set.csv")
    
    def train_dataloader(self):
        return DataLoader(self.data_train, batch_size=self.batch_size, shuffle=True, num_workers=8, pin_memory=True)
    
    def val_dataloader(self):
        self.data_val = CustomDataset(self.x_test, self.y_test)
        return DataLoader(self.data_val, batch_size=self.batch_size, shuffle=False, num_workers=8, pin_memory=True)
    
    def test_dataloader(self):
        return DataLoader(self.data_test, batch_size=self.batch_size, shuffle=False, num_workers=8, pin_memory=True)
    
    def save_TFRecords(features, labels, out_path, feature_dim):
        """
        features: numpy array of shape [num_samples, 1, feature_dim] or [num_samples, feature_dim]
        labels: numpy array of shape [num_samples]
        out_path: path to save tfrecord file
        feature_dim: int, dimension of feature vector (flattened)
        """
        with tf.io.TFRecordWriter(out_path) as writer:
            for i in range(features.shape[0]):
                feat = features[i]
                # Ensure 1D vector
                feat_flat = feat.reshape(-1)
                if feat_flat.size != feature_dim:
                    raise ValueError(f"Feature dimension mismatch: got {feat_flat.size}, expected {feature_dim}")
                example = tf.train.Example(features=tf.train.Features(feature={
                    'label': _int64_feature([int(labels[i])]),
                    'features': _float_feature(feat_flat.tolist())
                }))
                writer.write(example.SerializeToString())
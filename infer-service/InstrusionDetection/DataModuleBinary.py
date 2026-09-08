import lightning as L
from torchvision import transforms
import pandas as pd
from torch.utils.data import Dataset, DataLoader
from imblearn.over_sampling import RandomOverSampler
from imblearn.under_sampling import RandomUnderSampler
from imblearn.over_sampling import SMOTE
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
        
        
    def setup(self, stage:str):
        df = pd.read_csv(f"{self.data_dir}/UNSW_NB15_training-set.csv")
        qp = pd.read_csv(f"{self.data_dir}/UNSW_NB15_testing-set.csv")
        df = df.drop('id', axis=1) # we don't need it in this project
        df = df.drop('attack_cat', axis=1) # we don't need it in this project
        qp = qp.drop('id', axis=1)
        qp = qp.drop('attack_cat', axis=1)

        cols = ['proto','state','service']
        combined_data = pd.concat([df,qp])
        tmp = combined_data.pop('label')
        combined_data = one_hot(combined_data,cols)
        combined_data.replace({True: 1, False: 0},inplace=True)
        new_train_df = normalize(combined_data,combined_data.columns)
        new_train_df["Class"] = tmp
        y_train=new_train_df["Class"]
        combined_data_X = new_train_df.drop('Class', axis=1)
        oversample = RandomOverSampler(sampling_strategy='minority')
        # train_X, test_X = combined_data_X, combined_data_X
        # train_y, test_y = y_train, y_train
        train_X, test_X, train_y, test_y = train_test_split(combined_data_X,y_train, test_size=0.1, random_state=40)
        # train_X_over,train_y_over= oversample.fit_resample(train_X, train_y)
        train_X_over,train_y_over= SMOTE(random_state=42).fit_resample(train_X, train_y)
        # train_X_over,train_y_over= RandomUnderSampler(random_state=42).fit_resample(train_X, train_y)
        
        x_columns_train = new_train_df.columns.drop('Class')
        x_train_array = train_X_over[x_columns_train].values
        self.x_train_1=np.reshape(x_train_array, (x_train_array.shape[0],1, x_train_array.shape[1]))
        
        dummies = pd.get_dummies(train_y_over) # Classification
        y_train_1 = dummies.values
        self.y_train_1 = np.argmax(y_train_1.astype(int),axis=1) # crossEntropy 标签不需要独热编码
        x_columns_test = new_train_df.columns.drop('Class')
        x_test_array = test_X[x_columns_test].values
        self.x_test_2=np.reshape(x_test_array, (x_test_array.shape[0],1, x_test_array.shape[1]))
        dummies_test = pd.get_dummies(test_y) # Classification
        y_test_2 = dummies_test.values
        self.y_test_2 = np.argmax(y_test_2.astype(int),axis=1) # crossEntropy 标签不需要独热编码
        if stage == "fit":
            self.data_train = CustomDataset(self.x_train_1, self.y_train_1)
        elif stage == "test":
            self.data_test = CustomDataset(self.x_test_2, self.y_test_2)
        elif stage == "predict":
            raise NotImplementedError
            # self.data_predict = pd.read_csv(f"{self.data_dir}/UNSW_NB15_predict-set.csv")
    
    def train_dataloader(self):
        return DataLoader(self.data_train, batch_size=self.batch_size, shuffle=True, num_workers=8, pin_memory=True)
    
    def test_dataloader(self):
        return DataLoader(self.data_test, batch_size=self.batch_size, shuffle=False, num_workers=8, pin_memory=True)
import pandas as pd
import numpy as np
# from sklearn.model_selection import StratifiedKFold
from imblearn.over_sampling import RandomOverSampler
import torch
import torch.nn as nn
import lightning as pl
# from sklearn import metrics
import torchmetrics
# from scipy.stats import zscore
# from sklearn.model_selection import train_test_split
from torch.utils.data import Dataset, DataLoader

#One-hot encoding
def one_hot(df, cols):
    """
    @param df pandas DataFrame
    @param cols a list of columns to encode
    @return a DataFrame with one-hot encoding
    """
    for each in cols:
        dummies = pd.get_dummies(df[each], prefix=each, drop_first=False)
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


class MyModel(pl.LightningModule):
    def __init__(self):
        super(MyModel, self).__init__()
        self.save_hyperparameters()
        # Define the layers of the model
        self.conv1 = nn.Conv1d(in_channels=1, out_channels=64, kernel_size=64, padding='same') # input(292082,1,196)
        self.pool1 = nn.MaxPool1d(kernel_size=10)
        self.batch_norm1 = nn.BatchNorm1d(64)
        self.lstm1 = nn.LSTM(input_size=64, hidden_size=64, batch_first=True, bidirectional=True)
        self.pool2 = nn.MaxPool1d(kernel_size=5)
        self.batch_norm2 = nn.BatchNorm1d(25)
        self.lstm2 = nn.LSTM(input_size=25, hidden_size=128, batch_first=True, bidirectional=True)
        self.dropout = nn.Dropout(0.4)
        self.fc = nn.Linear(256, 10)  # 256 = 128 (from LSTM) * 2 (bidirectional)
        self.softmax = nn.Softmax(dim=1)
        self.accuracy = torchmetrics.Accuracy(task="multiclass", num_classes=10)

    def forward(self, x):
        # Forward pass through the network
        x = self.conv1(x)  # Shape: (batch_size, 64, length)
        x = self.pool1(x)  # Shape: (batch_size, 64, reduced_length)
        x = self.batch_norm1(x)

        x = x.permute(0, 2, 1)  # Change shape for LSTM: (batch_size, seq_len, features)
        x, _ = self.lstm1(x)  # Output shape: (batch_size, seq_len, 128)
        x = x[:, -1, :]  # Take the output of the last time step

        x = x.unsqueeze(1)  # Add a channel dimension: (batch_size, 1, 128)
        x = self.pool2(x)  # Apply second pooling: (batch_size, 1, reduced_length) 32,1,25
        # Here we need to ensure that the input to batch_norm2 has 128 features
        x = x.permute(0, 2, 1)  # Change shape for LSTM: (batch_size, seq_len, features)
        x = x.squeeze(1)  # Remove the channel dimension: (batch_size, reduced_length) 32,25

        # Since the output of the pooling layer should be in shape (batch_size, 128, new_length)
        x = self.batch_norm2(x)  # Update this based on your model's architecture 32,25
        x = x.permute(0, 2, 1)  # Change shape for LSTM
        x, _ = self.lstm2(x)  # Output shape: (batch_size, seq_len, 256)
        x = x[:, -1, :]  # Take the output of the last time step
        
        x = self.dropout(x)
        x = self.fc(x)
        # x = self.softmax(x)
        
        return x

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

    def configure_optimizers(self):
        return torch.optim.Adam(self.parameters(), lr=0.001)


if __name__=="__main__":
    df = pd.read_csv('dataset/CSV Files/Training and Testing Sets/UNSW_NB15_testing-set.csv')
    qp = pd.read_csv('dataset/CSV Files/Training and Testing Sets/UNSW_NB15_training-set.csv')

    df = df.drop('id', axis=1) # we don't need it in this project
    df = df.drop('label', axis=1) # we don't need it in this project
    qp = qp.drop('id', axis=1)
    qp = qp.drop('label', axis=1)

    cols = ['proto','state','service']
    combined_data = pd.concat([df,qp])
    tmp = combined_data.pop('attack_cat')

    #Applying one hot encoding to combined data
    
    combined_data = one_hot(combined_data,cols)
    combined_data.replace({True: 1, False: 0},inplace=True)
    #Normalizing training set
    new_train_df = normalize(combined_data,combined_data.columns)
    #Appending class column to training set
    new_train_df["Class"] = tmp

    y_train=new_train_df["Class"]
    combined_data_X = new_train_df.drop('Class', axis=1)
    oos_pred = []

    oversample = RandomOverSampler(sampling_strategy='minority')
    model = MyModel()
    trainer = pl.Trainer(max_epochs=150)

    #################### 6折交叉验证 #########################
    # kfold = StratifiedKFold(n_splits=6,shuffle=True,random_state=42)
    # kfold.get_n_splits(combined_data_X,y_train)
    # for train_index, test_index in kfold.split(combined_data_X,y_train):
    #     train_X, test_X = combined_data_X.iloc[train_index], combined_data_X.iloc[test_index]
    #     train_y, test_y = y_train.iloc[train_index], y_train.iloc[test_index]
        
    #     # print("train index:",train_index)
    #     # print("test index:",test_index)
    #     # print(train_y.value_counts())
        
    #     train_X_over,train_y_over= oversample.fit_resample(train_X, train_y)
    #     # print(train_y_over.value_counts())
        
    #     x_columns_train = new_train_df.columns.drop('Class')
    #     x_train_array = train_X_over[x_columns_train].values
    #     x_train_1=np.reshape(x_train_array, (x_train_array.shape[0],1, x_train_array.shape[1]))
        
    #     dummies = pd.get_dummies(train_y_over) # Classification
    #     outcomes = dummies.columns
    #     num_classes = len(outcomes)
        
    #     y_train_1 = dummies.values
    #     y_train_1 = np.argmax(y_train_1.astype(int),axis=1) # crossEntropy 标签不需要独热编码
        
    #     x_columns_test = new_train_df.columns.drop('Class')
    #     x_test_array = test_X[x_columns_test].values
    #     x_test_2=np.reshape(x_test_array, (x_test_array.shape[0],1, x_test_array.shape[1]))
        
    #     dummies_test = pd.get_dummies(test_y) # Classification
    #     outcomes_test = dummies_test.columns
    #     num_classes = len(outcomes_test)
        
    #     y_test_2 = dummies_test.values
    #     y_test_2 = np.argmax(y_test_2.astype(int),axis=1) # crossEntropy 标签不需要独热编码
    #     # After defining the dataset class, we can create the DataLoader instances
    #     train_dataset = CustomDataset(x_train_1, y_train_1)
    #     val_dataset = CustomDataset(x_test_2, y_test_2)
    #     # Create DataLoader for training and validation
    #     train_dataloader = DataLoader(train_dataset, batch_size=512, shuffle=True,num_workers=6)
    #     test_dataloader = DataLoader(val_dataset, batch_size=512, shuffle=False,num_workers=6)

    #     trainer.fit(model, train_dataloader)
    #     trainer.test(model, dataloaders=test_dataloader)
    ########################################################################################################################
 
    train_X, test_X = combined_data_X, combined_data_X
    train_y, test_y = y_train, y_train
    train_X_over,train_y_over= oversample.fit_resample(train_X, train_y)
    
    x_columns_train = new_train_df.columns.drop('Class')
    x_train_array = train_X_over[x_columns_train].values
    x_train_1=np.reshape(x_train_array, (x_train_array.shape[0],1, x_train_array.shape[1]))
    
    dummies = pd.get_dummies(train_y_over) # Classification
    outcomes = dummies.columns
    num_classes = len(outcomes)
    
    y_train_1 = dummies.values
    y_train_1 = np.argmax(y_train_1.astype(int),axis=1) # crossEntropy 标签不需要独热编码
    
    x_columns_test = new_train_df.columns.drop('Class')
    x_test_array = test_X[x_columns_test].values
    x_test_2=np.reshape(x_test_array, (x_test_array.shape[0],1, x_test_array.shape[1]))
    
    dummies_test = pd.get_dummies(test_y) # Classification
    outcomes_test = dummies_test.columns
    num_classes = len(outcomes_test)
    
    y_test_2 = dummies_test.values
    y_test_2 = np.argmax(y_test_2.astype(int),axis=1) # crossEntropy 标签不需要独热编码
    # After defining the dataset class, we can create the DataLoader instances
    train_dataset = CustomDataset(x_train_1, y_train_1)
    val_dataset = CustomDataset(x_test_2, y_test_2)
    # Create DataLoader for training and validation
    train_dataloader = DataLoader(train_dataset, batch_size=2048, shuffle=True,num_workers=6)
    test_dataloader = DataLoader(val_dataset, batch_size=2048, shuffle=False,num_workers=6)

    trainer.fit(model, train_dataloader)
    trainer.test(model, dataloaders=test_dataloader)
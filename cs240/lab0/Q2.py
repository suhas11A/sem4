import numpy as np
import pandas as pd

class KNN:
    def __init__(self, k=5):
        self.X_train = None
        self.y_train = None

    def fit(self, X, y):
        self.X_train = X
        self.y_train = y

    def predict_L2(self, X_test, k):
        train_x = self.X_train[np.newaxis, :, :]
        test_x = X_test[:, np.newaxis, :]
        diff = test_x-train_x
        diff = diff**2
        diff_square_sum = np.sum(diff, axis=2)
        idx = np.argsort(diff_square_sum, axis=1)
        return np.where(np.sum(self.y_train[idx][:, :k], axis=1) >= 0, 1, -1)


    def predict_L1(self, X_test, k):
        train_x = self.X_train[np.newaxis, :, :]
        test_x = X_test[:, np.newaxis, :]
        diff = test_x-train_x
        diff = np.abs(diff)
        diff_square_sum = np.sum(diff, axis=2)
        idx = np.argsort(diff_square_sum, axis=1)
        return np.where(np.sum(self.y_train[idx][:, :k], axis=1) >= 0, 1, -1)

def compute_accuracy(y_true, y_pred):
    x = np.zeros_like(y_true)
    x[y_true==y_pred]=1
    return x.mean()

def standardize(X_train, X_test):
    mu = np.mean(X_train, axis=0, keepdims=True)
    sigma = np.std(X_train, axis=0, keepdims=True)
    train_x_norm = (X_train - mu) / sigma
    test_x_norm = (X_test - mu) / sigma
    return train_x_norm, test_x_norm

def get_pearson_indices(X, y, m):
    X = X - np.mean(X, axis = 0, keepdims=True)
    y = (y - np.mean(y)).T
    X_norm = np.sum(X**2, axis=0)
    y_norm = np.sum(y**2)
    return np.argsort(np.abs((y@X)/(np.sqrt(X_norm*y_norm))))[-m:]


if __name__ == "__main__":
    # you are allowed to use loops here

    # TODO: Load data using pandas
    train_data = pd.read_csv("q2_train.csv")
    test_data = pd.read_csv("q2_test.csv")
    train_y = train_data["label"].to_numpy()
    test_y = test_data["label"].to_numpy()
    train_x = train_data.iloc[:,:-1].to_numpy()
    test_x = test_data.iloc[:,:-1].to_numpy()

    # TODO: Execute Task A (Vary k, use L2)
    knn = KNN()
    knn.fit(train_x, train_y)
    for k in [1,2,5,10,20,100]:
        y_pred = knn.predict_L2(test_x, k)
        print("k =", k, ":", compute_accuracy(test_y, y_pred)*100)
    print()

    # TODO: Execute Task B (Standardize, then vary m for Pearson selection, use k=20, L2)
    train_x_norm, test_x_norm = standardize(train_x, test_x)
    for m in [1,2,5,10,100]:
        m_best = get_pearson_indices(train_x_norm, train_y, m)
        knn = KNN()
        knn.fit(train_x_norm[:,m_best], train_y)
        y_pred = knn.predict_L2(test_x_norm[:, m_best], 20)
        print("m =", m, ":", compute_accuracy(test_y, y_pred)*100)
    print()

    # TODO: Execute Task C (Standardize, use all features, use k=20, L1)
    train_x_norm, test_x_norm = standardize(train_x, test_x)
    knn = KNN()
    knn.fit(train_x_norm, train_y)
    for k in [1,2,5,10,20,100]:
        y_pred = knn.predict_L1(test_x_norm, k)
        print("k =", k, ":", compute_accuracy(test_y, y_pred)*100)
    print(end="")
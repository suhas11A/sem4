# do not modify the imports below
import numpy as np
import matplotlib.pyplot as plt

# ============================================================
# Polynomial regression implementations
# ============================================================

def poly_features(x, degree):
    """
    x : (N,)
    degree: int

    Returns Phi : (N, degree+1)
        Phi[i] = [1, x_i, x_i^2, ..., x_i^degree]
    """
    return np.float_power(x, np.linspace(0, degree, num=degree+1))

def fit_ols(Phi, y):
    """
    Phi : (N, p+1)
    y   : (N,)

    Returns w : (p+1,)
    """
    # TODO
    return (np.linalg.inv((Phi.T)@Phi))@(Phi.T)@y

def predict(x, degree, w):
    """
    x : (N, )
    degree: int
    w : (degree+1,)

    Returns y_hat : (N,)
    """
    # TODO
    X = poly_features(x, degree)
    return (X@w)

# ============================================================
# k-fold cross-validation
# ============================================================

def mse(y, y_hat):
    # TODO
    return np.sum((y-y_hat)**2)/y.shape[0]


def k_fold_cv(x, y, degree, k=5):
    """
    x: (N,)
    y: (N,)
    degree: int
    k: int

    Returns avg_val_mse : float
    """
    # TODO:
    # 1. shuffle data
    # 2. split into k folds
    # 3. train on k-1, validate on 1
    # 4. return average validation MSE
    list_x = np.array_split(x, k)
    list_y = np.array_split(y, k)
    msee = 0
    for i in range(k):
        training_x = np.concatenate(list_x[:i]+list_x[i+1:], axis=0)
        training_y = np.concatenate(list_y[:i]+list_y[i+1:], axis=0)
        y_hat = predict(list_x[i], degree, fit_ols(poly_features(training_x, degree), training_y))
        msee+=mse(y_hat, list_y[i])
    return msee/k

def evaluate_degrees(x, y, D_max, k=5):
    """
    x : (N,) array
    y : (N,) array
    D_max : int
    k : int

    Returns
        train_mse : list of length D_max
        cv_mse    : list of length D_max
    """
    # TODO:
    # For each d in 1..D_max:
    #   - construct Phi
    #   - fit OLS
    #   - compute training MSE
    #   - compute k-fold CV MSE
    # Store results in lists and return them
    a = []
    b = []
    for d in range(1, D_max+1):
        phi = poly_features(x, d)
        a.append(mse(y, predict(x, d, fit_ols(phi, y))))
        b.append(k_fold_cv(x, y, d, k))
    return a, b


def select_degree(cv_mse):
    """
    cv_mse : list
    Returns best_degree : int
    """
    # TODO
    return np.argmin(np.array(cv_mse))+1


def fit_final_model(x, y, degree):
    """
    x : (N,) array
    y : (N,) array
    degree : int

    Returns w : (degree+1,) array
    """
    # TODO
    phi = poly_features(x, degree)
    return fit_ols(phi, y)

def plot_errors(train_mse, cv_mse):
    D = len(train_mse)
    plt.figure()
    plt.plot(range(1, D + 1), train_mse, label="Training MSE")
    plt.plot(range(1, D + 1), cv_mse, label="CV MSE")
    plt.xlabel("Polynomial Degree")
    plt.ylabel("MSE")
    # plt.ylim(0, 15)
    plt.legend()
    plt.tight_layout()
    plt.savefig("errors.png", dpi=200)
    print("Saved plot to errors.png")

# ============================================================
# Data loading
# ============================================================

def load_data():
    """
    Load the train dataset

    Returns
    -------
    X_train, y_train (q2_train.csv)
    """
    # TODO
    train = np.loadtxt("q2_train.csv", delimiter=",",skiprows=1)
    return train[:,:-1], train[:,-1:]

# ============================================================
# Main experiment (DO NOT MODIFY, AUTOGRADER TESTS WILL RUN SOME OTHER MAIN)
# ============================================================
if __name__ == "__main__":
    np.random.seed(1234)

    x_train, y_train = load_data()
    D_max = 10
    k = 5

    train_mse, cv_mse = evaluate_degrees(x_train, y_train, D_max, k)

    best_d = select_degree(cv_mse)
    w = fit_final_model(x_train, y_train, best_d)

    print("Optimal degree:", best_d)
    print("Weights:", w)

    plot_errors(train_mse, cv_mse)
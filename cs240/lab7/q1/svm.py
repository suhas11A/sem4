"""
svm.py  —  your implementation
"""

import numpy as np


# ============================================================
# PART A — SVM INTERNALS
# ============================================================

def violates_kkt(y_i, alpha_i, Ei, C, tol):
    """
    Checks if a given training sample violates the Karush-Kuhn-Tucker (KKT) conditions.

    Args:
        y_i (float or int): True label of the i-th sample (usually -1 or +1).
        alpha_i (float): The current Lagrange multiplier for the i-th sample.
        Ei (float): The error for the i-th sample, calculated as f(x_i) - y_i.
        C (float): The regularization parameter (box constraint on alphas).
        tol (float): Numerical tolerance for checking the violation.

    Returns:
        bool: True if the KKT conditions are violated, False otherwise.
    """
    return ((y_i*Ei<-tol and alpha_i<C) or (y_i*Ei>tol and alpha_i>0))


def decision_function(sv_y, sv_alpha, b, K):
    """
    Computes the SVM decision function (raw scores) for a set of test points.

    Args:
        sv_y (np.ndarray): Array of shape (n_sv,) containing the labels of the support vectors.
        sv_alpha (np.ndarray): Array of shape (n_sv,) containing the Lagrange multipliers 
                               of the support vectors.
        b (float): The bias term.
        K (np.ndarray): Kernel matrix between support vectors and test points. 
                        Shape is (n_sv, M), where n_sv is the number of support vectors 
                        and M is the number of test points.

    Returns:
        np.ndarray: Array of shape (M,) containing the continuous score for each test point.
    """
    return ((sv_alpha.reshape(-1,1)*sv_y.reshape(-1,1)).T@K).reshape(-1,)+b


def compute_bias(sv_y, sv_alpha, K_sv, C):
    """
    Computes the bias term (b) using the support vectors.

    Args:
        sv_y (np.ndarray): Array of shape (n_sv,) containing the labels of the support vectors.
        sv_alpha (np.ndarray): Array of shape (n_sv,) containing the Lagrange multipliers 
                               of the support vectors.
        K_sv (np.ndarray): Kernel matrix among the support vectors themselves. 
                           Shape is (n_sv, n_sv).
        C (float): The regularization parameter.

    Returns:
        float: The computed bias term b. Returns 0.0 if there are no free support vectors.
    """
    mask1 = (sv_alpha<C-1e-5)
    mask2 = (sv_alpha>0+1e-5)
    mask = mask1*mask2
    if np.sum(mask)==0:
        return 0.0
    ola = ((sv_alpha.reshape(-1,1)*sv_y.reshape(-1,1)).T@K_sv).reshape(-1,)
    return np.mean(sv_y[mask] - ola[mask])


# ============================================================
# PART B — KERNEL FUNCTIONS
# ============================================================

def linear_kernel(X_train, X_test):
    """
    Computes the linear kernel matrices.

    Args:
        X_train (np.ndarray): Training data array of shape (N, P), where N is the number 
                              of training samples and P is the number of features.
        X_test (np.ndarray): Test data array of shape (M, P), where M is the number 
                             of test samples.

    Returns:
        tuple: (K_train, K_test)
            - K_train (np.ndarray): Kernel matrix for training data, shape (N, N).
            - K_test (np.ndarray): Kernel matrix for test data vs training data, shape (M, N).
    """
    return (X_train@(X_train.T), X_test@(X_train.T))


def polynomial_kernel(X_train, X_test, degree=2, coef0=1.0):
    """
    Computes the polynomial kernel matrices.

    Args:
        X_train (np.ndarray): Training data array of shape (N, P).
        X_test (np.ndarray): Test data array of shape (M, P).
        degree (int): The degree of the polynomial.
        coef0 (float): The independent term in the polynomial kernel.

    Returns:
        tuple: (K_train, K_test)
            - K_train (np.ndarray): Kernel matrix for training data, shape (N, N).
            - K_test (np.ndarray): Kernel matrix for test data vs training data, shape (M, N).
    """
    return (X_train@(X_train.T) + coef0)**degree, (X_test@(X_train.T) + coef0)**degree


def rbf_kernel(X_train, X_test, gamma=0.5):
    """
    Computes the Radial Basis Function (RBF) / Gaussian kernel matrices.

    Args:
        X_train (np.ndarray): Training data array of shape (N, P).
        X_test (np.ndarray): Test data array of shape (M, P).
        gamma (float): Kernel coefficient.

    Returns:
        tuple: (K_train, K_test)
            - K_train (np.ndarray): Kernel matrix for training data, shape (N, N).
            - K_test (np.ndarray): Kernel matrix for test data vs training data, shape (M, N).
    """
    dst1 = np.exp(-gamma*((np.linalg.norm(X_train[:,:,None] - np.transpose(X_train[:,:,None], (2,1,0)), axis=1))**2))
    dst2 = np.exp(-gamma*((np.linalg.norm(X_test[:,:,None] - np.transpose(X_train[:,:,None], (2,1,0)), axis=1))**2))
    return (dst1, dst2)   



def normalized_rbf_kernel(X_train, X_test, gamma=0.5):
    """
    Computes the RBF kernel matrices on standardized data (zero mean, unit variance).

    Args:
        X_train (np.ndarray): Training data array of shape (N, P).
        X_test (np.ndarray): Test data array of shape (M, P).
        gamma (float): Kernel coefficient.

    Returns:
        tuple: (K_train, K_test)
            - K_train (np.ndarray): Kernel matrix for scaled training data, shape (N, N).
            - K_test (np.ndarray): Kernel matrix for scaled test data vs scaled training data, shape (M, N).
    """
    mean = np.mean(X_train, axis=0)
    std = np.std(X_train, axis=0)
    X_train = (X_train-mean)/std
    X_test = (X_test-mean)/std
    return rbf_kernel(X_train, X_test, gamma)



# ============================================================
# PART C — LEARNABLE KERNEL FUNCTIONS (ONLY DO THIS IF YOU FINISH PARTS A AND B, AS THIS MIGHT TAKE QUITE SOME TIME)
# ============================================================

def poly_features(X, degree=2):
    n, p = X.shape
    feats = [X]
    for i in range(p):
        for j in range(i, p):
            prod = (X[:, i] * X[:, j]).reshape(n, 1)
            feats.append(prod)
    return np.hstack(feats)


def contrastive_grad(w, Phi, y, margin, reg, max_pairs=3000):
    n = len(y)

    Phi_w = Phi * w

    ii, jj = np.triu_indices(n, k=1)

    if len(ii) > max_pairs:
        idx = np.random.choice(len(ii), max_pairs, replace=False)
        ii = ii[idx]
        jj = jj[idx]

    P = len(ii)

    delta = Phi_w[ii] - Phi_w[jj]
    d_ij = np.sum(delta**2, axis=1)

    dphi = Phi[ii] - Phi[jj]

    same = (y[ii] == y[jj]).astype(float)
    hinge = (d_ij < margin).astype(float)

    coeff = (same - (1 - same) * hinge) * (2.0 / P)

    grad = (coeff[:, None] * delta * dphi).sum(axis=0)
    grad += 2.0 * reg * w

    return grad


def learnable_kernel(X_train, X_test, y_train):
    """
    Learns a kernel of your choice by optimizing a loss function  and returns the corresponding kernel matrices.
    You can also implement a closed form solution instead of learning the kernel by gradient descent, again you just have to return the kernel matrices.
    you are free to create and use any number of helper functions here, only the accuracies will be graded,
    so feel free to experiment with different approaches !

    Args:
        X_train (np.ndarray): Training data array of shape (N, P).
        X_test (np.ndarray): Test data array of shape (M, P).
        y_train (np.ndarray): Training labels of shape (N,).

    Returns:
        tuple: (K_train, K_test, C)
            - K_train (np.ndarray): Learned kernel matrix for training data, shape (N, N).
            - K_test (np.ndarray): Learned kernel matrix for test vs training data, shape (M, N).
            - C (float): The regularization parameter to use for the SVM model (defaults to 1.0).
    """

    degree = 2
    lr = 0.25
    reg = 0.005
    iterations = 500
    margin = 5

    mean = np.mean(X_train, axis=0)
    std = np.std(X_train, axis=0) + 1e-8

    X_train_scaled = (X_train - mean) / std
    X_test_scaled = (X_test - mean) / std

    Phi_train = poly_features(X_train_scaled, degree)
    Phi_test = poly_features(X_test_scaled, degree)

    w = np.ones(Phi_train.shape[1])

    for _ in range(iterations):
        grad = contrastive_grad(w, Phi_train, y_train, margin, reg)
        w = w - lr * grad
        w = np.clip(w, 1e-6, None)

    Phi_train_w = Phi_train * w
    Phi_test_w = Phi_test * w

    K_train = Phi_train_w @ Phi_train_w.T
    K_test = Phi_test_w @ Phi_train_w.T

    C = 1.0

    return K_train, K_test, C
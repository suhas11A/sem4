"""
Task 3 — Open-Ended Ensemble Fusion
=====================================
You have two baseline predictors from Tasks 1 and 2.
Combine them (and anything else you like) to get the lowest MAE on test data.

Rules
-----
* Edit THIS file only. Do not rename task3_predict or FUSION_LEARNERS.
* No pre-built boosting libraries (XGBoost, LightGBM, GradientBoostingRegressor, …).
* Allowed base learners: same weak-learner constraint as Task 2.
* Do NOT use test labels at any point.
"""

import numpy as np
from typing import List
from sklearn.base import BaseEstimator, clone
from sklearn.tree import DecisionTreeRegressor
from sklearn.linear_model import Ridge, LinearRegression, Lasso
from sklearn.neighbors import KNeighborsRegressor
from sklearn.svm import SVR
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import KFold


ALLOWED_MODEL_SPECS = {
    DecisionTreeRegressor: {
        "max_depth": {1, 2, 3}
    },
    LinearRegression: {},
    Ridge: {
        "alpha": (1e-4, 1e3)
    },
    Lasso: {
        "alpha": (1e-4, 1e1)
    },
    KNeighborsRegressor: {
        "n_neighbors": {5, 10}
    },
    SVR: {
        "kernel": {"rbf"},
        "C": (0.1, 10.0),
        "epsilon": (0.01, 1.0),
    },
}

# Fast + reasonably diverse pool
FUSION_LEARNERS: List[BaseEstimator] = [
    DecisionTreeRegressor(max_depth=1, random_state=11),
    DecisionTreeRegressor(max_depth=2, random_state=12),
    DecisionTreeRegressor(max_depth=3, random_state=13),
    LinearRegression(),
    Ridge(alpha=0.1),
    Ridge(alpha=10.0),
    KNeighborsRegressor(n_neighbors=5),
    KNeighborsRegressor(n_neighbors=10),
]


def _fit_oof_and_test_preds(
    model: BaseEstimator,
    X_train: np.ndarray,
    y_train: np.ndarray,
    X_test: np.ndarray,
    n_splits: int,
    random_state: int,
):
    n = X_train.shape[0]
    oof = np.zeros(n, dtype=float)

    kf = KFold(n_splits=n_splits, shuffle=True, random_state=random_state)

    for tr_idx, va_idx in kf.split(X_train):
        m = clone(model)
        m.fit(X_train[tr_idx], y_train[tr_idx])
        oof[va_idx] = m.predict(X_train[va_idx])

    full_model = clone(model)
    full_model.fit(X_train, y_train)
    test_pred = full_model.predict(X_test)

    return oof, test_pred


def _pairwise_sq_dists(A: np.ndarray, B: np.ndarray) -> np.ndarray:
    # ||a-b||^2 = ||a||^2 + ||b||^2 - 2 a.b
    A2 = np.sum(A * A, axis=1, keepdims=True)
    B2 = np.sum(B * B, axis=1, keepdims=True).T
    D = A2 + B2 - 2.0 * (A @ B.T)
    return np.maximum(D, 0.0)


def task3_predict(
    X_train: np.ndarray,
    y_train: np.ndarray,
    X_test:  np.ndarray,
) -> np.ndarray:
    """
    Train your fusion strategy and return predictions for X_test.
    """
    X_train = np.asarray(X_train, dtype=float)
    y_train = np.asarray(y_train, dtype=float)
    X_test = np.asarray(X_test, dtype=float)

    # Global feature scaling
    scaler = StandardScaler()
    X_train_s = scaler.fit_transform(X_train)
    X_test_s = scaler.transform(X_test)

    n_train = X_train_s.shape[0]
    n_test = X_test_s.shape[0]
    n_models = len(FUSION_LEARNERS)

    # 3-fold instead of 5-fold for speed
    train_oof = np.zeros((n_train, n_models), dtype=float)
    test_preds = np.zeros((n_test, n_models), dtype=float)
    global_mae = np.zeros(n_models, dtype=float)

    for j, learner in enumerate(FUSION_LEARNERS):
        oof, pred_test = _fit_oof_and_test_preds(
            learner,
            X_train_s,
            y_train,
            X_test_s,
            n_splits=3,
            random_state=100 + j,
        )
        train_oof[:, j] = oof
        test_preds[:, j] = pred_test
        global_mae[j] = np.mean(np.abs(oof - y_train))

    # -----------------------------
    # 1) Global inverse-error blend
    # -----------------------------
    g_w = 1.0 / (global_mae + 1e-6)
    g_w /= np.sum(g_w)
    pred_global = test_preds @ g_w

    # -----------------------------
    # 2) Local dynamic blend
    # -----------------------------
    # Compute neighbors in scaled feature space
    # Use a moderate K for stability
    K = min(25, n_train)
    D = _pairwise_sq_dists(X_test_s, X_train_s)   # (n_test, n_train)
    nn_idx = np.argpartition(D, K - 1, axis=1)[:, :K]

    pred_local = np.zeros(n_test, dtype=float)

    for i in range(n_test):
        idx = nn_idx[i]

        # local MAE of each model from OOF predictions
        local_err = np.mean(np.abs(train_oof[idx] - y_train[idx, None]), axis=0)

        # keep only the best few models locally
        topk = min(4, n_models)
        best = np.argsort(local_err)[:topk]

        w = 1.0 / (local_err[best] + 1e-6)
        w = w / np.sum(w)

        pred_local[i] = float(np.dot(test_preds[i, best], w))

    # -----------------------------
    # 3) Simple robust aggregates
    # -----------------------------
    pred_mean = np.mean(test_preds, axis=1)
    pred_median = np.median(test_preds, axis=1)

    # -----------------------------
    # 4) Lightweight stacking
    # -----------------------------
    Z_train = np.column_stack([
        train_oof,
        np.mean(train_oof, axis=1),
        np.median(train_oof, axis=1),
        np.std(train_oof, axis=1),
        np.min(train_oof, axis=1),
        np.max(train_oof, axis=1),
    ])

    Z_test = np.column_stack([
        test_preds,
        np.mean(test_preds, axis=1),
        np.median(test_preds, axis=1),
        np.std(test_preds, axis=1),
        np.min(test_preds, axis=1),
        np.max(test_preds, axis=1),
    ])

    z_scaler = StandardScaler()
    Z_train_s = z_scaler.fit_transform(Z_train)
    Z_test_s = z_scaler.transform(Z_test)

    meta = Ridge(alpha=3.0)
    meta.fit(Z_train_s, y_train)
    pred_stack = meta.predict(Z_test_s)

    # -----------------------------
    # 5) Final blend
    # -----------------------------
    # Emphasize local competence, keep stack/global as stabilizers
    y_pred = (
        0.55 * pred_local +
        0.25 * pred_stack +
        0.12 * pred_global +
        0.05 * pred_median +
        0.03 * pred_mean
    )

    return np.asarray(y_pred, dtype=float)
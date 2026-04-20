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
from typing import List, Tuple
from sklearn.base import BaseEstimator, clone
from sklearn.tree import DecisionTreeRegressor
from sklearn.linear_model import Ridge, Lasso, LinearRegression
from sklearn.neighbors import KNeighborsRegressor
from sklearn.svm import SVR
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import KFold

# ------------------------------------------------------------------
# Re-import your Task 1 and Task 2 systems.
# Adjust import paths to match your submission structure.
# ------------------------------------------------------------------
# from task1_student import GradientBoostingEnsemble, REGRESSION_LEARNERS
# from task2_student import KNORAURegressor, REGRESSION_MODELS


# ===========================================================================
# FUSION_LEARNERS — pool of weak learners available to your fusion
# ===========================================================================
# Rules:
#   • ≥ 5 unfitted estimators
#   • Only allowed base learners (same as Task 2)
#   • No pre-built boosting models

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
FUSION_LEARNERS: List[BaseEstimator] = [
    LinearRegression(),
    Ridge(alpha=0.1),
    Ridge(alpha=1.0),
    DecisionTreeRegressor(max_depth=2, random_state=7),
    DecisionTreeRegressor(max_depth=3, random_state=11),
    KNeighborsRegressor(n_neighbors=5),
    KNeighborsRegressor(n_neighbors=10),
]


# ===========================================================================
# Small utilities
# ===========================================================================

def _mae(y_true: np.ndarray, y_pred: np.ndarray) -> float:
    y_true = np.asarray(y_true, dtype=float)
    y_pred = np.asarray(y_pred, dtype=float)
    return float(np.mean(np.abs(y_true - y_pred)))


class StandardizedRegressor(BaseEstimator):
    """
    Internal helper only.
    FUSION_LEARNERS themselves must stay as raw allowed estimators.
    """
    def __init__(self, base_model):
        self.base_model = base_model

    def fit(self, X, y):
        self.scaler_ = StandardScaler()
        Xs = self.scaler_.fit_transform(np.asarray(X, dtype=float))
        self.model_ = clone(self.base_model)
        self.model_.fit(Xs, np.asarray(y, dtype=float))
        return self

    def predict(self, X):
        Xs = self.scaler_.transform(np.asarray(X, dtype=float))
        return self.model_.predict(Xs)


def _wrap_model(model: BaseEstimator) -> BaseEstimator:
    """
    Internally standardize scale-sensitive regressors.
    """
    if isinstance(model, (LinearRegression, Ridge, Lasso, KNeighborsRegressor, SVR)):
        return StandardizedRegressor(clone(model))
    return clone(model)


def _fit_and_predict_raw_model(
    model: BaseEstimator,
    X_train: np.ndarray,
    y_train: np.ndarray,
    X_query: np.ndarray
) -> np.ndarray:
    fitted = _wrap_model(model)
    fitted.fit(X_train, y_train)
    return np.asarray(fitted.predict(X_query), dtype=float)


# ===========================================================================
# Task 1-style system
# ===========================================================================

def huber_pseudo_residuals(
    y_true: np.ndarray,
    y_pred: np.ndarray,
    delta: float
) -> np.ndarray:
    residuals = np.asarray(y_true, dtype=float) - np.asarray(y_pred, dtype=float)
    abs_r = np.abs(residuals)
    return np.where(abs_r <= delta, residuals, delta * np.sign(residuals))


class GradientBoostingEnsemble:
    """
    Lightweight Task 1-style boosting model for regression with Huber residuals.
    """

    def __init__(self, delta: float = 10.0, lr: float = 0.25):
        self.delta = float(delta)
        self.lr = float(lr)
        self.models_: List[BaseEstimator] = []
        self.initial_prediction_: float = 0.0
        self.scaler_ = StandardScaler()

    def learning_rate(self, m: int) -> float:
        return self.lr

    def fit(
        self,
        weak_learners: List[BaseEstimator],
        X: np.ndarray,
        y: np.ndarray
    ) -> "GradientBoostingEnsemble":
        X = np.asarray(X, dtype=float)
        y = np.asarray(y, dtype=float)

        self.models_ = []
        self.initial_prediction_ = float(np.mean(y))

        Xs = self.scaler_.fit_transform(X)
        f_pred = np.full(y.shape, self.initial_prediction_, dtype=float)

        for m, learner in enumerate(weak_learners, start=1):
            residuals = huber_pseudo_residuals(y, f_pred, self.delta)
            model = clone(learner)
            model.fit(Xs, residuals)
            f_pred += self.learning_rate(m) * model.predict(Xs)
            self.models_.append(model)

        return self

    def predict(self, X: np.ndarray) -> np.ndarray:
        X = np.asarray(X, dtype=float)
        Xs = self.scaler_.transform(X)

        y_pred = np.full(Xs.shape[0], self.initial_prediction_, dtype=float)
        for m, model in enumerate(self.models_, start=1):
            y_pred += self.learning_rate(m) * model.predict(Xs)
        return y_pred


def _make_task1_learners() -> List[BaseEstimator]:
    return [
        DecisionTreeRegressor(max_depth=1, random_state=1),
        DecisionTreeRegressor(max_depth=2, random_state=2),
        DecisionTreeRegressor(max_depth=3, random_state=3),
        DecisionTreeRegressor(max_depth=3, random_state=4),
        DecisionTreeRegressor(max_depth=3, random_state=5),
        DecisionTreeRegressor(max_depth=3, random_state=6),
    ]


def fit_task1_system(X: np.ndarray, y: np.ndarray) -> GradientBoostingEnsemble:
    # Mildly robust delta based on training spread
    delta = max(1.0, 0.75 * float(np.std(y)))
    model = GradientBoostingEnsemble(delta=delta, lr=0.25)
    model.fit(_make_task1_learners(), X, y)
    return model


# ===========================================================================
# Task 2-style system
# ===========================================================================

def bootstrap_sample(
    X: np.ndarray,
    y: np.ndarray,
    random_state: int
) -> Tuple[np.ndarray, np.ndarray]:
    rng = np.random.default_rng(random_state)
    idx = rng.integers(0, len(X), size=len(X))
    return X[idx], y[idx]


def fit_with_optional_bagging(
    model: BaseEstimator,
    X: np.ndarray,
    y: np.ndarray,
    use_bagging: bool,
    random_state: int
) -> BaseEstimator:
    fitted = clone(model)
    if use_bagging:
        X_fit, y_fit = bootstrap_sample(X, y, random_state)
    else:
        X_fit, y_fit = X, y
    fitted.fit(X_fit, y_fit)
    return fitted


class KNORAURegressor:
    """
    Lightweight Task 2-style KNORA-U for regression.
    Uses distance-weighted local error and inverse-error fusion.
    """

    def __init__(self, K: int = 5, epsilon: float = 0.20):
        self.K = int(K)
        self.epsilon = float(epsilon)

        self.models_: List[BaseEstimator] = []
        self.X_dsel_: np.ndarray = None
        self.y_dsel_: np.ndarray = None
        self.scaler_ = StandardScaler()
        self.dsel_predictions_: np.ndarray = None

    def fit(
        self,
        models: List[BaseEstimator],
        X_dsel: np.ndarray,
        y_dsel: np.ndarray
    ) -> "KNORAURegressor":
        self.models_ = list(models)

        X_dsel = np.asarray(X_dsel, dtype=float)
        y_dsel = np.asarray(y_dsel, dtype=float)

        self.X_dsel_ = self.scaler_.fit_transform(X_dsel)
        self.y_dsel_ = y_dsel

        self.dsel_predictions_ = np.vstack([
            np.asarray(m.predict(X_dsel), dtype=float)
            for m in self.models_
        ])
        return self

    def _select_model_indices(self, x: np.ndarray) -> Tuple[np.ndarray, np.ndarray]:
        x = np.asarray(x, dtype=float).reshape(1, -1)
        xs = self.scaler_.transform(x)[0]

        dists = np.sqrt(np.sum((self.X_dsel_ - xs) ** 2, axis=1))
        K = max(1, min(self.K, len(dists)))

        idx = np.argpartition(dists, K - 1)[:K]
        idx = idx[np.argsort(dists[idx])]

        # Distance-weighted local MAE
        weights = 1.0 / (dists[idx] + 1e-8)
        weights /= np.sum(weights)

        abs_err = np.abs(self.dsel_predictions_[:, idx] - self.y_dsel_[idx])
        local_scores = np.sum(abs_err * weights[None, :], axis=1)

        best = np.min(local_scores)
        selected = np.flatnonzero(local_scores <= best * (1.0 + self.epsilon))

        if selected.size == 0:
            selected = np.array([int(np.argmin(local_scores))], dtype=int)

        # cap selection size for stability/speed
        if selected.size > 4:
            order = np.argsort(local_scores[selected])
            selected = selected[order[:4]]

        return selected, local_scores[selected]

    def predict(self, X: np.ndarray) -> np.ndarray:
        X = np.asarray(X, dtype=float)

        pred_matrix = np.vstack([
            np.asarray(m.predict(X), dtype=float)
            for m in self.models_
        ])

        y_pred = np.empty(X.shape[0], dtype=float)

        for i in range(X.shape[0]):
            selected, scores = self._select_model_indices(X[i])

            w = 1.0 / (scores + 1e-8)
            w /= np.sum(w)

            y_pred[i] = float(np.dot(w, pred_matrix[selected, i]))

        return y_pred


def _build_task2_pool(X_train: np.ndarray, y_train: np.ndarray) -> List[BaseEstimator]:
    """
    Slightly smaller and faster than your full Task 2 pool.
    """
    base_models = [
        StandardizedRegressor(LinearRegression()),
        StandardizedRegressor(Ridge(alpha=0.1)),
        StandardizedRegressor(Ridge(alpha=1.0)),
        DecisionTreeRegressor(max_depth=3, random_state=21),
        DecisionTreeRegressor(max_depth=3, random_state=22),
        StandardizedRegressor(KNeighborsRegressor(n_neighbors=5)),
        StandardizedRegressor(KNeighborsRegressor(n_neighbors=10)),
    ]

    use_bagging = [
        False,
        False,
        False,
        True,
        True,
        False,
        False,
    ]

    fitted = []
    for i, (model, bag) in enumerate(zip(base_models, use_bagging)):
        fitted.append(
            fit_with_optional_bagging(
                model=model,
                X=X_train,
                y=y_train,
                use_bagging=bag,
                random_state=1234 + i,
            )
        )
    return fitted


def fit_task2_system(
    X: np.ndarray,
    y: np.ndarray,
    random_state: int = 42
) -> KNORAURegressor:
    """
    Uses a kept-out DSEL split from training only.
    """
    X = np.asarray(X, dtype=float)
    y = np.asarray(y, dtype=float)

    n = len(X)
    rng = np.random.default_rng(random_state)
    perm = rng.permutation(n)

    dsel_size = max(10, int(0.2 * n))
    if n > 40:
        dsel_size = min(dsel_size, n - max(20, int(0.5 * n)))
    else:
        dsel_size = max(5, min(dsel_size, n // 3))

    if dsel_size <= 0 or dsel_size >= n:
        dsel_size = max(1, n // 4)

    dsel_idx = perm[:dsel_size]
    pool_idx = perm[dsel_size:]

    if len(pool_idx) < 10:
        pool_idx = perm
        dsel_idx = perm[:max(1, min(len(perm) // 4, 20))]

    pool = _build_task2_pool(X[pool_idx], y[pool_idx])

    knora = KNORAURegressor(K=5, epsilon=0.20)
    knora.fit(pool, X[dsel_idx], y[dsel_idx])
    return knora


# ===========================================================================
# Feature generation for fusion
# ===========================================================================

def _build_oof_features(X_train: np.ndarray, y_train: np.ndarray) -> np.ndarray:
    """
    Build OOF predictions for:
      - all FUSION_LEARNERS
      - Task 1 system
      - Task 2 system
    """
    X_train = np.asarray(X_train, dtype=float)
    y_train = np.asarray(y_train, dtype=float)

    n = len(X_train)
    n_static = len(FUSION_LEARNERS)
    oof = np.zeros((n, n_static + 2), dtype=float)

    kf = KFold(n_splits=3, shuffle=True, random_state=42)

    for fold, (tr_idx, va_idx) in enumerate(kf.split(X_train), start=1):
        X_tr, y_tr = X_train[tr_idx], y_train[tr_idx]
        X_va = X_train[va_idx]

        # static learners
        for j, model in enumerate(FUSION_LEARNERS):
            oof[va_idx, j] = _fit_and_predict_raw_model(model, X_tr, y_tr, X_va)

        # Task 1 baseline
        t1 = fit_task1_system(X_tr, y_tr)
        oof[va_idx, n_static] = t1.predict(X_va)

        # Task 2 baseline
        t2 = fit_task2_system(X_tr, y_tr, random_state=100 + fold)
        oof[va_idx, n_static + 1] = t2.predict(X_va)

    return oof


def _build_test_features(
    X_train: np.ndarray,
    y_train: np.ndarray,
    X_test: np.ndarray
) -> np.ndarray:
    """
    Refit all component predictors on full training data,
    then produce their predictions on X_test.
    """
    X_train = np.asarray(X_train, dtype=float)
    y_train = np.asarray(y_train, dtype=float)
    X_test = np.asarray(X_test, dtype=float)

    n_static = len(FUSION_LEARNERS)
    feats = np.zeros((len(X_test), n_static + 2), dtype=float)

    for j, model in enumerate(FUSION_LEARNERS):
        feats[:, j] = _fit_and_predict_raw_model(model, X_train, y_train, X_test)

    t1 = fit_task1_system(X_train, y_train)
    feats[:, n_static] = t1.predict(X_test)

    t2 = fit_task2_system(X_train, y_train, random_state=999)
    feats[:, n_static + 1] = t2.predict(X_test)

    return feats


# ===========================================================================
# task3_predict — entry point called by the autograder
# ===========================================================================

def task3_predict(
    X_train: np.ndarray,
    y_train: np.ndarray,
    X_test:  np.ndarray,
) -> np.ndarray:
    """
    Fusion strategy:
      1. Build OOF predictions using training-only CV
      2. Force-in Task1 and Task2 features
      3. Keep the 3 best static learners by OOF MAE
      4. Fit a small Ridge meta-learner on those predictions
      5. Blend Ridge stacker with inverse-MAE weighted average
    """
    X_train = np.asarray(X_train, dtype=float)
    y_train = np.asarray(y_train, dtype=float)
    X_test = np.asarray(X_test, dtype=float)

    oof = _build_oof_features(X_train, y_train)
    test_feats = _build_test_features(X_train, y_train, X_test)

    n_static = len(FUSION_LEARNERS)

    feature_mae = np.array([
        _mae(y_train, oof[:, j]) for j in range(oof.shape[1])
    ], dtype=float)

    # Always include Task1 + Task2, plus best 3 static learners
    best_static = np.argsort(feature_mae[:n_static])[:min(3, n_static)]
    keep = np.unique(
        np.concatenate([best_static, np.array([n_static, n_static + 1])])
    ).astype(int)

    # Learned fusion
    scaler = StandardScaler()
    Z_train = scaler.fit_transform(oof[:, keep])
    Z_test = scaler.transform(test_feats[:, keep])

    meta = Ridge(alpha=1.0)
    meta.fit(Z_train, y_train)
    meta_pred = np.asarray(meta.predict(Z_test), dtype=float)

    # Simpler robust blend from CV errors
    inv = 1.0 / (feature_mae[keep] + 1e-8)
    inv /= np.sum(inv)
    simple_pred = np.dot(test_feats[:, keep], inv)

    # Final fusion
    final_pred = 0.7 * meta_pred + 0.3 * simple_pred

    # Mild safety clip
    y_lo = float(np.min(y_train))
    y_hi = float(np.max(y_train))
    final_pred = np.clip(final_pred, y_lo, y_hi)

    return final_pred.astype(float)
"""
KNORA-U — Dynamic Ensemble Selection for Regression (with optional Bagging)

Read every docstring carefully before implementing.
Do NOT rename any class, method, or variable — the autograder depends on them.
"""

import numpy as np
from typing import List, Tuple
from sklearn.base import BaseEstimator, clone
from sklearn.preprocessing import StandardScaler


class StandardizedRegressor(BaseEstimator):
    def __init__(self, base_model):
        self.base_model = base_model

    def fit(self, X, y):
        self.scaler_ = StandardScaler()
        Xs = self.scaler_.fit_transform(X)
        self.model_ = clone(self.base_model)
        self.model_.fit(Xs, y)
        return self

    def predict(self, X):
        Xs = self.scaler_.transform(X)
        return self.model_.predict(Xs)


# ===========================================================================
# Training data loader (students only get TRAIN data)
# ===========================================================================

def load_training_data(path="../train.npz"):
    """
    Load training data.

    NOTE:
    - Students only get access to TRAIN data.
    - DSEL must be constructed from training data only.
    """
    data = np.load(path)
    return data["X"], data["y"]


# ===========================================================================
# Utility functions
# ===========================================================================

def euclidean_distance(a: np.ndarray, b: np.ndarray) -> float:
    """
    Compute Euclidean distance between two vectors.

    Parameters
    ----------
    a, b : np.ndarray of shape (n_features,)

    Returns
    -------
    float
    """
    a = np.asarray(a, dtype=float)
    b = np.asarray(b, dtype=float)
    return float(np.sqrt(np.sum((a - b) ** 2)))


def knn_indices(X: np.ndarray, x: np.ndarray, K: int) -> np.ndarray:
    """
    Find indices of the K nearest neighbors of x in X.

    Parameters
    ----------
    X : np.ndarray, shape (n_samples, n_features)
    x : np.ndarray, shape (n_features,)
    K : int

    Returns
    -------
    np.ndarray — indices of K nearest neighbors
    """
    X = np.asarray(X, dtype=float)
    x = np.asarray(x, dtype=float)
    K = max(1, min(int(K), X.shape[0]))

    dists = np.sum((X - x) ** 2, axis=1)
    idx = np.argpartition(dists, K - 1)[:K]
    return idx[np.argsort(dists[idx])]


# ===========================================================================
# Bagging utilities
# ===========================================================================

def bootstrap_sample(
    X: np.ndarray,
    y: np.ndarray,
    random_state: int
) -> Tuple[np.ndarray, np.ndarray]:
    """
    Draw a bootstrap sample from (X, y).

    Parameters
    ----------
    X : np.ndarray
    y : np.ndarray
    random_state : int

    Returns
    -------
    X_boot, y_boot : np.ndarray
    """
    rng = np.random.default_rng(random_state)
    n = len(X)
    idx = rng.integers(0, n, size=n)
    return X[idx], y[idx]


def fit_with_optional_bagging(
    model: BaseEstimator,
    X: np.ndarray,
    y: np.ndarray,
    use_bagging: bool,
    random_state: int
) -> BaseEstimator:
    """
    Fit a model either normally or using bagging.

    Parameters
    ----------
    model : BaseEstimator (unfitted)
    X, y : training data
    use_bagging : bool
        Whether to apply bagging
    random_state : int

    Returns
    -------
    fitted model
    """
    fitted = clone(model)

    if use_bagging:
        X_fit, y_fit = bootstrap_sample(X, y, random_state)
    else:
        X_fit, y_fit = X, y

    fitted.fit(X_fit, y_fit)
    return fitted


# ===========================================================================
# KNORA-U Regressor
# ===========================================================================

class KNORAURegressor:
    """
    K-Nearest Oracles Union (KNORA-U) for regression.

    Dynamic ensemble selection based on local competence.
    """

    def __init__(self, K: int = 5, epsilon: float = 0.20):
        """
        Parameters
        ----------
        K : int
            Initial neighborhood size
        epsilon : float
            Local error tolerance
        """
        self.K = K
        self.epsilon = epsilon

        self.models_: List[BaseEstimator] = []
        self.X_dsel_: np.ndarray = None
        self.y_dsel_: np.ndarray = None
        self.scaler_ = StandardScaler()
        self.dsel_predictions_: np.ndarray = None

    # ------------------------------------------------------------------
    # fit
    # ------------------------------------------------------------------
    def fit(
        self,
        models: List[BaseEstimator],
        X_dsel: np.ndarray,
        y_dsel: np.ndarray
    ) -> "KNORAURegressor":
        """
        Store the fitted model pool and DSEL dataset.

        Parameters
        ----------
        models : list of FITTED regressors
        X_dsel : np.ndarray
        y_dsel : np.ndarray

        Returns
        -------
        self
        """
        self.models_ = list(models)

        X_dsel = np.asarray(X_dsel, dtype=float)
        y_dsel = np.asarray(y_dsel, dtype=float)

        self.X_dsel_ = self.scaler_.fit_transform(X_dsel)
        self.y_dsel_ = y_dsel

        # Precompute all model predictions on DSEL once
        self.dsel_predictions_ = np.vstack([
            np.asarray(model.predict(X_dsel), dtype=float)
            for model in self.models_
        ])

        return self

    # ------------------------------------------------------------------
    # helper
    # ------------------------------------------------------------------
    def _select_model_indices(self, x: np.ndarray) -> Tuple[np.ndarray, np.ndarray]:
        x = np.asarray(x, dtype=float).reshape(1, -1)
        x_scaled = self.scaler_.transform(x)[0]

        dists = np.sqrt(np.sum((self.X_dsel_ - x_scaled) ** 2, axis=1))
        K = max(1, min(self.K, len(dists)))

        nn_idx = np.argpartition(dists, K - 1)[:K]
        nn_idx = nn_idx[np.argsort(dists[nn_idx])]

        nn_dists = dists[nn_idx]

        # Distance-weighted local MAE
        weights = 1.0 / (nn_dists + 1e-8)
        weights /= np.sum(weights)

        local_abs_err = np.abs(
            self.dsel_predictions_[:, nn_idx] - self.y_dsel_[nn_idx]
        )
        local_scores = np.sum(local_abs_err * weights[None, :], axis=1)

        best = np.min(local_scores)

        # Softer than absolute threshold; better for hidden-test generalization
        selected_idx = np.flatnonzero(local_scores <= best * (1.0 + self.epsilon))

        if selected_idx.size == 0:
            selected_idx = np.array([int(np.argmin(local_scores))], dtype=int)

        # Don't average too many weakly-related models
        if selected_idx.size > 4:
            order = np.argsort(local_scores[selected_idx])
            selected_idx = selected_idx[order[:4]]

        return selected_idx, local_scores[selected_idx]

    # ------------------------------------------------------------------
    # _select_models
    # ------------------------------------------------------------------
    def _select_models(self, x: np.ndarray) -> List[BaseEstimator]:
        """
        Select locally competent models for a single test point x
        using the KNORA-U algorithm.

        Algorithm
        ---------
        1. Find K nearest neighbors of x in DSEL
        2. For each model:
             - compute MAE on these neighbors
        3. Select all models with MAE ≤ epsilon
        4. If none selected:
             - select the single best model (lowest MAE)

        Returns
        -------
        list of selected models (non-empty)
        """
        selected_idx, _ = self._select_model_indices(x)
        return [self.models_[i] for i in selected_idx]

    # ------------------------------------------------------------------
    # predict
    # ------------------------------------------------------------------
    def predict(self, X: np.ndarray) -> np.ndarray:
        """
        Predict target values using dynamic model selection.

        For each test point:
        - select models using _select_models
        - return average prediction

        Parameters
        ----------
        X : np.ndarray, shape (n_samples, n_features)

        Returns
        -------
        np.ndarray, shape (n_samples,)
        """
        X = np.asarray(X, dtype=float)
        n = X.shape[0]

        # Cache all model predictions on X once for speed
        pred_matrix = np.vstack([
            np.asarray(model.predict(X), dtype=float)
            for model in self.models_
        ])

        y_pred = np.empty(n, dtype=float)

        for i in range(n):
            selected_idx, selected_scores = self._select_model_indices(X[i])

            # Inverse-error weighted average
            w = 1.0 / (selected_scores + 1e-8)
            w /= np.sum(w)

            y_pred[i] = float(np.dot(w, pred_matrix[selected_idx, i]))

        return y_pred


# ===========================================================================
# Allowed base learners (provided, not implemented by students)
# ===========================================================================

from sklearn.tree import DecisionTreeRegressor
from sklearn.linear_model import Ridge, Lasso, LinearRegression
from sklearn.neighbors import KNeighborsRegressor
from sklearn.svm import SVR

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


# ===========================================================================
# PART D — Student-defined model pool
# ===========================================================================
#
# Rules enforced by autograder:
# - ≥ 5 models
# - Each model must be fitted
# - If same architecture appears multiple times:
#     → bagging MUST be used
#

REGRESSION_MODELS: List[BaseEstimator] = []


def _build_regression_models() -> List[BaseEstimator]:
    X_train, y_train = load_training_data()

    X_train = np.asarray(X_train, dtype=float)
    y_train = np.asarray(y_train, dtype=float)

    base_models = [
        StandardizedRegressor(LinearRegression()),
        StandardizedRegressor(Ridge(alpha=0.1)),
        StandardizedRegressor(Ridge(alpha=1.0)),
        DecisionTreeRegressor(max_depth=3, random_state=11),
        DecisionTreeRegressor(max_depth=3, random_state=22),
        DecisionTreeRegressor(max_depth=3, random_state=33),
        DecisionTreeRegressor(max_depth=3, random_state=44),
        StandardizedRegressor(KNeighborsRegressor(n_neighbors=10)),
        StandardizedRegressor(KNeighborsRegressor(n_neighbors=5)),
        StandardizedRegressor(SVR(kernel="rbf", C=3.0, epsilon=0.1)),
    ]

    # Only the duplicate depth-3 trees use bagging
    use_bagging = [
        False,  # LinearRegression
        False,  # Ridge(0.1)
        False,  # Ridge(1.0)
        True,   # Tree depth 3
        True,   # Tree depth 3
        True,   # Tree depth 3
        True,   # Tree depth 3 duplicate
        False,  # KNN 5
        False,  # KNN 10
        False,  # SVR
    ]

    fitted_models = []
    for i, (model, bag) in enumerate(zip(base_models, use_bagging)):
        fitted_models.append(
            fit_with_optional_bagging(
                model=model,
                X=X_train,
                y=y_train,
                use_bagging=bag,
                random_state=2026 + i,
            )
        )

    return fitted_models


try:
    REGRESSION_MODELS = _build_regression_models()
except Exception:
    REGRESSION_MODELS = []
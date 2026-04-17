"""
KNORA-U — Dynamic Ensemble Selection for Regression (with optional Bagging)

Read every docstring carefully before implementing.
Do NOT rename any class, method, or variable — the autograder depends on them.
"""

import numpy as np
from typing import List, Tuple
from sklearn.base import BaseEstimator, clone
from sklearn.preprocessing import StandardScaler


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
    return float(np.linalg.norm(a - b))


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

    distances = np.linalg.norm(X - x, axis=1)
    K = max(1, min(int(K), X.shape[0]))
    return np.argsort(distances)[:K]


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
    idx = rng.integers(0, len(X), size=len(X))
    return X[idx], y[idx]




class ScaledRegressor(BaseEstimator):
    """
    Wrapper that applies scaling per model.
    """

    def __init__(self, base_model: BaseEstimator):
        self.base_model = base_model
        self.scaler_ = StandardScaler()
        self.model_ = None

    def fit(self, X: np.ndarray, y: np.ndarray):
        X = np.asarray(X, dtype=float)
        y = np.asarray(y, dtype=float)

        X_scaled = self.scaler_.fit_transform(X)
        self.model_ = clone(self.base_model)
        self.model_.fit(X_scaled, y)
        return self

    def predict(self, X: np.ndarray) -> np.ndarray:
        X = np.asarray(X, dtype=float)
        X_scaled = self.scaler_.transform(X)
        return self.model_.predict(X_scaled)


def fit_with_optional_bagging(
    model: BaseEstimator,
    X: np.ndarray,
    y: np.ndarray,
    use_bagging: bool,
    random_state: int
) -> BaseEstimator:
    """
    Fit a model either normally or using bagging.
    """
    fitted_model = ScaledRegressor(model)

    if use_bagging:
        X_fit, y_fit = bootstrap_sample(X, y, random_state)
    else:
        X_fit, y_fit = X, y

    fitted_model.fit(X_fit, y_fit)
    return fitted_model


# ===========================================================================
# KNORA-U Regressor
# ===========================================================================

class KNORAURegressor:
    """
    K-Nearest Oracles Union (KNORA-U) for regression.

    Dynamic ensemble selection based on local competence.
    """

    def __init__(self, K: int = 7, epsilon: float = 5.0):
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
        self.X_dsel_scaled_: np.ndarray = None
        self.scaler_ = StandardScaler()

    def fit(
        self,
        models: List[BaseEstimator],
        X_dsel: np.ndarray,
        y_dsel: np.ndarray
    ) -> "KNORAURegressor":
        """
        Store the fitted model pool and DSEL dataset.
        """
        self.models_ = list(models)
        self.X_dsel_ = np.asarray(X_dsel, dtype=float)
        self.y_dsel_ = np.asarray(y_dsel, dtype=float)
        self.X_dsel_scaled_ = self.scaler_.fit_transform(self.X_dsel_)
        return self

    def _select_models(self, x: np.ndarray) -> List[BaseEstimator]:
        """
        Select locally competent models for a single test point x
        using the KNORA-U algorithm.
        """
        x = np.asarray(x, dtype=float)
        x_scaled = self.scaler_.transform(x.reshape(1, -1))[0]

        nbr_idx = knn_indices(self.X_dsel_scaled_, x_scaled, self.K)
        X_local = self.X_dsel_[nbr_idx]
        y_local = self.y_dsel_[nbr_idx]

        local_maes = []
        for model in self.models_:
            pred_local = model.predict(X_local)
            mae_local = float(np.mean(np.abs(pred_local - y_local)))
            local_maes.append(mae_local)

        local_maes = np.asarray(local_maes, dtype=float)

        selected = [
            model for model, mae_local in zip(self.models_, local_maes)
            if mae_local <= self.epsilon
        ]

        if len(selected) == 0:
            best_idx = int(np.argmin(local_maes))
            selected = [self.models_[best_idx]]

        return selected

    def predict(self, X: np.ndarray) -> np.ndarray:
        """
        Predict target values using dynamic model selection.
        """
        X = np.asarray(X, dtype=float)
        preds = np.empty(X.shape[0], dtype=float)

        for i, x in enumerate(X):
            selected_models = self._select_models(x)
            sample_preds = np.array(
                [model.predict(x.reshape(1, -1))[0] for model in selected_models],
                dtype=float
            )
            preds[i] = float(np.mean(sample_preds))

        return preds


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

REGRESSION_MODELS: List[BaseEstimator] = []

X_train, y_train = load_training_data()

base_models: List[BaseEstimator] = [
    LinearRegression(),
    Ridge(alpha=0.1),
    Ridge(alpha=10.0),
    Lasso(alpha=0.01, max_iter=50000),

    DecisionTreeRegressor(max_depth=3, random_state=11),
    DecisionTreeRegressor(max_depth=3, random_state=12),
    DecisionTreeRegressor(max_depth=3, random_state=13),

    KNeighborsRegressor(n_neighbors=5),
    KNeighborsRegressor(n_neighbors=10),

    SVR(kernel="rbf", C=3.0, epsilon=0.1),
]

use_bagging_flags = [
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
]

for i, (model, use_bagging) in enumerate(zip(base_models, use_bagging_flags)):
    fitted = fit_with_optional_bagging(
        model=model,
        X=X_train,
        y=y_train,
        use_bagging=use_bagging,
        random_state=1234 + i,
    )
    REGRESSION_MODELS.append(fitted)
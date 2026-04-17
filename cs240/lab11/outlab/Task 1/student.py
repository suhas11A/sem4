"""
Read every docstring carefully before implementing.
Do NOT rename any class, method, or variable — the autograder depends on them.
"""

import numpy as np
from typing import List
from sklearn.base import BaseEstimator, clone
from sklearn.preprocessing import StandardScaler

# ===========================================================================
# Training data loader (students only get TRAIN data)
# ===========================================================================

def load_training_data(path="train.npz"):
    """
    Load training data from disk.
    """
    data = np.load(path)
    X_train = data["X"]
    y_train = data["y"]
    return X_train, y_train


# ===========================================================================
# PART A  —  Loss functions
# ===========================================================================

def huber_loss(residuals: np.ndarray, delta: float) -> float:
    """
    Compute the MEAN Huber loss over an array of residuals.
    
    Returns
    -------
    float — mean Huber loss across all residuals
    """
    residuals = np.asarray(residuals, dtype=float)
    abs_r = np.abs(residuals)
    quadratic = 0.5*(residuals**2)
    linear = delta*abs_r - 0.5*(delta**2)
    loss = np.where(abs_r<=delta, quadratic, linear)
    return float(np.mean(loss))


def huber_pseudo_residuals(y_true: np.ndarray,
                           y_pred: np.ndarray,
                           delta: float) -> np.ndarray:
    """
    Compute the negative gradient of the Huber loss w.r.t. y_pred.

    Returns
    -------
    np.ndarray — pseudo-residuals, same shape as y_true
    """
    y_true = np.asarray(y_true, dtype=float)
    y_pred = np.asarray(y_pred, dtype=float)
    residuals = y_true - y_pred
    abs_r = np.abs(residuals)
    return np.where(abs_r<=delta, residuals, delta * np.sign(residuals))


# ===========================================================================
# PART B  —  GradientBoostingEnsemble class
# ===========================================================================

class GradientBoostingEnsemble:
    """
    A from-scratch gradient boosting ensemble supporting regression
    using the Huber loss.

    The model has the form:
        f(x) = sum_{m=1}^{M} learning_rate(m) * F_m(x)

    where:
        - M is the number of boosting stages
        - F_m is the m-th weak learner fitted on pseudo-residuals
    """

    def __init__(self, delta: float = 15.0):
        self.delta = delta
        self.models_: List[BaseEstimator] = []
        self.initial_prediction_: float = 0.0
        self.scaler_ = StandardScaler()

    def learning_rate(self, m: int) -> float:
        """
        Return the coefficient (learning rate) for the m-th boosting stage.

        Returns
        -------
        float — positive learning rate for stage m
        """
        return 1.0

    def _compute_pseudo_residuals(self,
                                  y_true: np.ndarray,
                                  f_pred: np.ndarray) -> np.ndarray:
        """
        Compute the pseudo-residuals (negative gradients) for the current stage.

        Returns
        -------
        np.ndarray — pseudo-residuals
        """
        return huber_pseudo_residuals(y_true, f_pred, self.delta)

    def fit(self,
            weak_learners: List[BaseEstimator],
            X: np.ndarray,
            y: np.ndarray) -> "GradientBoostingEnsemble":
        """
        Fit the boosting ensemble using the provided list of weak learners.

        Algorithm
        ---------
        1. Initialise f(x) = mean(y)
        2. Scale X using StandardScaler
        3. For each weak learner:
             a. Compute pseudo-residuals
             b. Fit learner on (X, residuals)
             c. Update ensemble prediction
        """
        X = np.asarray(X, dtype=float)
        y = np.asarray(y, dtype=float)

        self.models_ = []
        self.initial_prediction_ = float(np.mean(y))
        X_scaled = self.scaler_.fit_transform(X)
        f_pred = np.full(y.shape, self.initial_prediction_, dtype=float)

        for m, learner in enumerate(weak_learners, start=1):
            g = self._compute_pseudo_residuals(y, f_pred)
            model = clone(learner)
            model.fit(X_scaled, g)
            f_pred += self.learning_rate(m) * model.predict(X_scaled)
            self.models_.append(model)

        return self

    def predict(self, X: np.ndarray) -> np.ndarray:
        """
        Generate final predictions for new data.

        Returns
        -------
        np.ndarray — predictions, shape (n_samples,)
        """
        X = np.asarray(X, dtype=float)
        X_scaled = self.scaler_.transform(X)
        y_pred = np.full(X_scaled.shape[0], self.initial_prediction_, dtype=float)

        for m, model in enumerate(self.models_, start=1):
            y_pred += self.learning_rate(m) * model.predict(X_scaled)

        return y_pred

    def staged_loss(self, X: np.ndarray, y: np.ndarray) -> np.ndarray:
        """
        Compute the loss after each boosting stage on dataset (X, y).

        Returns
        -------
        np.ndarray — loss after each stage
        """
        X = np.asarray(X, dtype=float)
        y = np.asarray(y, dtype=float)
        X_scaled = self.scaler_.transform(X)
        f_pred = np.full(y.shape, self.initial_prediction_, dtype=float)
        losses = []
        for m, model in enumerate(self.models_, start=1):
            f_pred += self.learning_rate(m) * model.predict(X_scaled)
            losses.append(huber_loss(y - f_pred, self.delta))

        return np.asarray(losses, dtype=float)


# ===========================================================================
# PART C  —  Weak learner design
# ===========================================================================
#
# You may choose and reorder weak learners freely,
# subject to the constraints below.
#
# - At least 5 learners
# - Must be sklearn regressors
# - Must obey ALLOWED_MODEL_SPECS
# - No pre-built boosting models allowed
#

from sklearn.tree import DecisionTreeRegressor
from sklearn.linear_model import Ridge, Lasso, LinearRegression
from sklearn.neighbors import KNeighborsRegressor
from sklearn.svm import SVR

# ===========================================================================
# Allowed weak learner specifications (DO NOT MODIFY)
# ===========================================================================

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
# Define your weak learners here
# ===========================================================================

REGRESSION_LEARNERS: List[BaseEstimator] = [
    DecisionTreeRegressor(max_depth=1, random_state=1),
    
    DecisionTreeRegressor(max_depth=2, random_state=5),

    DecisionTreeRegressor(max_depth=3, random_state=12),
    DecisionTreeRegressor(max_depth=3, random_state=13),

    DecisionTreeRegressor(max_depth=3, random_state=20),
    DecisionTreeRegressor(max_depth=3, random_state=21),
    DecisionTreeRegressor(max_depth=3, random_state=22),
    DecisionTreeRegressor(max_depth=3, random_state=23),
    DecisionTreeRegressor(max_depth=3, random_state=24),

    Lasso(alpha=0.005, max_iter=100000),
]
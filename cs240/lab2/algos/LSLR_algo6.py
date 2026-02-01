import numpy as np
from typing import Callable, Optional, Tuple, List
from functions.func import func
from .optim import LSLROptimiser


class LSLRAlgo6(LSLROptimiser):
    def __init__(self, X: np.ndarray, y: np.ndarray) -> None:
        super().__init__(X, y)
        self.col_norm2 = np.sum(self.X ** 2, axis=0)
        self.col_norm2 = np.maximum(self.col_norm2, 1e-12)
        self.fro2 = float(np.sum(self.col_norm2))
        self.p = self.col_norm2 / self.fro2
        self.L_coords = self.col_norm2 / self.n_samples

    def step(self, params: np.ndarray) -> np.ndarray:
        w = params.copy()
        gamma = np.random.choice(self.n_features, p=self.p)
        residuals = self.X @ w - self.y
        grad_gamma = (self.X[:, gamma].T @ residuals) / self.n_samples
        step_size = 1.0 / self.L_coords[gamma]
        w[gamma] -= step_size * grad_gamma
        return w


    def grad_coord(self, w: np.ndarray, gamma: int) -> float:
        residuals = self.X @ w - self.y
        return float((self.X[:, gamma].T @ residuals) / self.n_samples)

    def eval_lslr(self, w: np.ndarray) -> float:
        residuals = self.X @ w - self.y
        return 0.5 * np.mean(residuals ** 2)

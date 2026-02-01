import numpy as np
from typing import Callable, Optional, Tuple, List
from functions.func import func
from .optim import LSLROptimiser


class LSLRAlgo0(LSLROptimiser):
    def __init__(self, X: np.ndarray, y: np.ndarray) -> None:
        super().__init__(X, y)
        
        self.eta = 1.0
        n, d = X.shape
        XTX = X.T @ X / n
        eigenvalues = np.linalg.eigvalsh(XTX)
        if len(eigenvalues) > 0:
            L = float(np.max(eigenvalues))
            if L > 1e-10:
                self.eta = 1.0 / L

    def lr(self) -> float:
        return self.eta

    def step(self, params: np.ndarray) -> np.ndarray:
        grad = self.full_grad(params)
        return params - self.lr() * grad

    def eval_lslr(self, w: np.ndarray) -> float:
        residuals = self.X @ w - self.y
        return 0.5 * np.mean(residuals ** 2)

    def full_grad(self, w: np.ndarray) -> np.ndarray:
        residuals = self.X @ w - self.y
        return (self.X.T @ residuals) / self.n_samples

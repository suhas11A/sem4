import numpy as np
from typing import Callable, Optional, Tuple, List
from functions.func import func
from .optim import LSLROptimiser


class LSLRAlgo7(LSLROptimiser):
    """
    Randomized Kaczmarz (Non-Uniform Sampling) coordinate update.

    p_gamma = ||X_{:,gamma}||^2 / ||X||_F^2
    Unbiased estimator:
        G_RK(w,gamma) = (||X||_F^2 / ||X_{:,gamma}||^2) * e_gamma * (∇f(w))_gamma

    Note: η_t = 1 typically works well due to non-uniform sampling.
    """

    def __init__(self, X: np.ndarray, y: np.ndarray) -> None:
        super().__init__(X, y)

        self.col_norm2 = np.sum(self.X ** 2, axis=0)
        self.col_norm2 = np.maximum(self.col_norm2, 1e-12)

        # p_gamma = ||X_{:,gamma}||^2 / ||X||_F^2
        self.fro2 = float(np.sum(self.col_norm2))
        self.p = self.col_norm2 / self.fro2

        # L_gamma = (1/n) ||X_{:,gamma}||^2
        self.L_coords = self.col_norm2 / self.n_samples

    def step(self, params: np.ndarray) -> np.ndarray:
        w = params.copy()
        gamma = np.random.choice(self.n_features, p=self.p)

        residuals = self.X @ w - self.y
        grad_gamma = (self.X[:, gamma].T @ residuals) / self.n_samples

        step_size = 1.0 / self.L_coords[gamma]   # = n / ||X_{:,gamma}||^2
        w[gamma] -= step_size * grad_gamma
        return w


    def grad_coord(self, w: np.ndarray, gamma: int) -> float:
        """
        (∇f(w))_gamma = (1/n) * X_{:,gamma}^T (Xw - y)
        """
        residuals = self.X @ w - self.y
        return float((self.X[:, gamma].T @ residuals) / self.n_samples)

    def stoch_grad(self, w: np.ndarray, gamma: int) -> np.ndarray:
        """
        Returns the RK unbiased stochastic gradient vector:
            G_RK(w,gamma) = (||X||_F^2 / ||X_{:,gamma}||^2) * e_gamma * (∇f(w))_gamma
        """
        g = np.zeros_like(w)
        grad_gamma = self.grad_coord(w, gamma)
        g[gamma] = (self.fro2 / self.col_norm2[gamma]) * grad_gamma
        return g

    def eval_lslr(self, w: np.ndarray) -> float:
        residuals = self.X @ w - self.y
        return 0.5 * np.mean(residuals ** 2)

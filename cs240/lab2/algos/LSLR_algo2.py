import numpy as np
from typing import Optional
from .optim import LSLROptimiser


class LSLRAlgo2(LSLROptimiser):
    """
    Mini-batch Gradient Descent for LSLR.

    Objective: f(w) = (1/n) ||Xw - y||^2
    Full grad: (2/n) X^T (Xw - y)
    Mini-batch grad: (2/b) X_B^T (X_B w - y_B)

    Step size: eta = 1/L where L = (2/n) * ||X||_2^2
    """

    def __init__(self, X: np.ndarray, y: np.ndarray) -> None:
        super().__init__(X, y)
        self.n = X.shape[0]
        self.batch_size = int(self.n)
        self.rng = np.random.default_rng(0)

        self.eta = 1e-3  # default so lr() always works

        XTX = (X.T @ X) / self.n
        eigs = np.linalg.eigvalsh(XTX)
        if eigs.size:
            L0 = float(np.max(eigs))          # = maxeig((1/n) X^T X)
            if L0 > 1e-10:
                self.eta = 1.0 / (2.0 * L0)   # correct for this objective


    def lr(self) -> float:
        return self.eta

    def step(self, params: np.ndarray) -> np.ndarray:
        w = params
        g = self.stoch_grad(w, self.batch_size)
        return w - self.lr() * g

    def eval_lslr(self, w: np.ndarray) -> float:
        r = self.X @ w - self.y
        return float((r @ r) / self.n)

    def stoch_grad(self, w: np.ndarray, gamma: int) -> np.ndarray:
        b = int(gamma)
        b = max(1, min(b, self.n))
        idx = self.rng.choice(self.n, size=b, replace=False)
        Xb = self.X[idx, :]
        yb = self.y[idx]
        rb = Xb @ w - yb
        return (2.0 / b) * (Xb.T @ rb)

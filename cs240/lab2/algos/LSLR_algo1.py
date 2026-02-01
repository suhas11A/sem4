import numpy as np
from .optim import LSLROptimiser

class LSLRAlgo1(LSLROptimiser):
    def __init__(self, X: np.ndarray, y: np.ndarray) -> None:
        super().__init__(X, y)
        self.n = self.X.shape[0]
        self.rng = np.random.default_rng(0)
        XTX = (self.X.T @ self.X) / self.n
        L = float(np.max(np.linalg.eigvalsh(XTX)))
        if not np.isfinite(L) or L <= 1e-12:
            L = 1.0
        self.eta0 = 0.1 / L
        self.t = 0
        self.clip = 1e3

    def lr(self) -> float:
        return float(self.eta0 / np.sqrt(self.t + 1.0))

    def step(self, params: np.ndarray) -> np.ndarray:
        i = int(self.rng.integers(0, self.n))
        g = self.stoch_grad(params, i)
        gn = np.linalg.norm(g)
        if gn > self.clip:
            g = g * (self.clip / (gn + 1e-12))

        eta = self.lr()
        self.t += 1
        return params - eta * g

    def eval_lslr(self, w: np.ndarray) -> float:
        residuals = self.X @ w - self.y
        return 0.5 * np.mean(residuals ** 2)

    def stoch_grad(self, w: np.ndarray, gamma: int) -> np.ndarray:
        xi = self.X[gamma]
        ri = float(xi @ w - self.y[gamma])
        return xi * ri
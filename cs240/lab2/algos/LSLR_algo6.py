import numpy as np
from .optim import LSLROptimiser


class LSLRAlgo6(LSLROptimiser):
    """
    SVRG for Least Squares Linear Regression

    Objective:
        f(w) = (1/2n) ||Xw - y||^2

    Full gradient:
        ∇f(w) = (1/n) X^T (Xw - y)

    Sample gradient:
        ∇f_i(w) = x_i (x_i^T w - y_i)
    """

    def __init__(self, X: np.ndarray, y: np.ndarray, inner_iterations: int = None) -> None:
        super().__init__(X, y)

        self.n_samples, self.n_features = X.shape

        # ---------- Lipschitz constant ----------
        XTX = (X.T @ X) / self.n_samples
        eigenvalues = np.linalg.eigvalsh(XTX)
        L = float(np.max(eigenvalues)) if eigenvalues.size > 0 else 1.0
        if L <= 0:
            L = 1.0

        # ---------- Learning rate ----------
        self.eta = 1.0 / (20.0 * L)

        # ---------- Inner loop length ----------
        if inner_iterations is None:
            self.N = self.n_samples
        else:
            self.N = inner_iterations

        self.rng = np.random.default_rng(0)

    # -------------------------------------------------

    def lr(self) -> float:
        return self.eta

    # -------------------------------------------------

    def step(self, params: np.ndarray) -> np.ndarray:
        # Snapshot
        w_snapshot = params.copy()

        # Full gradient at snapshot
        full_grad_snapshot = self.full_grad(w_snapshot)

        # Inner iterate
        w_inner = w_snapshot.copy()

        for _ in range(self.N):
            i = self.rng.integers(0, self.n_samples)
            grad = self.svrg_gradient(
                w_inner,
                w_snapshot,
                full_grad_snapshot,
                i
            )
            w_inner -= self.lr() * grad

        self.epochs_done += 1
        return w_inner

    # -------------------------------------------------

    def svrg_gradient(
        self,
        w: np.ndarray,
        w_snapshot: np.ndarray,
        full_grad_snapshot: np.ndarray,
        i: int
    ) -> np.ndarray:
        grad_i_w = self.sample_grad(w, i)
        grad_i_snapshot = self.sample_grad(w_snapshot, i)
        return grad_i_w - grad_i_snapshot + full_grad_snapshot

    # -------------------------------------------------

    def sample_grad(self, w: np.ndarray, i: int) -> np.ndarray:
        x_i = self.X[i]
        y_i = self.y[i]
        residual = np.dot(x_i, w) - y_i
        return x_i * residual

    # -------------------------------------------------

    def eval_lslr(self, w: np.ndarray) -> float:
        residuals = self.X @ w - self.y
        return 0.5 * np.mean(residuals ** 2)
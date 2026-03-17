"""
q4.py
=====
Task: Implement multi-class generative classifiers trained using

(1) Exact Normalization (Softmax)
(2) Importance Sampling (IS)
(3) Noise Contrastive Estimation (NCE)

Training is performed using mini-batch gradient descent
with on-the-fly sampling where required.

You are expected to fill in the TODOs only.
Do NOT change function signatures.
"""

import numpy as np


# ======================================================
# METRICS
# ======================================================

def accuracy(y_true, y_pred):
    """
    Compute overall classification accuracy.

    Args:
        y_true (np.ndarray): True labels, shape (N,)
        y_pred (np.ndarray): Predicted labels, shape (N,)

    Returns:
        float
    """
    # TODO
    y_true = np.asarray(y_true)
    y_pred = np.asarray(y_pred)
    if y_true.size == 0:
        return 0.0
    return float(np.mean(y_true == y_pred))


def precision(y_true, y_pred, cls):
    """
    Precision for class cls (one-vs-rest).

    Args:
        y_true (np.ndarray): shape (N,)
        y_pred (np.ndarray): shape (N,)
        cls (int)

    Returns:
        float
    """
    # TODO
    y_true = np.asarray(y_true)
    y_pred = np.asarray(y_pred)
    pred_pos = (y_pred == cls)
    true_pos = (y_true == cls)

    tp = np.sum(pred_pos & true_pos)
    fp = np.sum(pred_pos & (~true_pos))
    denom = tp + fp
    return float(tp / denom) if denom > 0 else 0.0


def recall(y_true, y_pred, cls):
    """
    Recall for class cls (one-vs-rest).

    Args:
        y_true (np.ndarray): shape (N,)
        y_pred (np.ndarray): shape (N,)
        cls (int)

    Returns:
        float
    """
    # TODO
    y_true = np.asarray(y_true)
    y_pred = np.asarray(y_pred)
    pred_pos = (y_pred == cls)
    true_pos = (y_true == cls)

    tp = np.sum(pred_pos & true_pos)
    fn = np.sum((~pred_pos) & true_pos)
    denom = tp + fn
    return float(tp / denom) if denom > 0 else 0.0


def f1_score(y_true, y_pred, cls):
    """
    F1 score for class cls.

    Args:
        y_true (np.ndarray): shape (N,)
        y_pred (np.ndarray): shape (N,)
        cls (int)

    Returns:
        float
    """
    # TODO
    p = precision(y_true, y_pred, cls)
    r = recall(y_true, y_pred, cls)
    denom = p + r
    return float(2 * p * r / denom) if denom > 0 else 0.0


# ======================================================
# COMMON UTILITIES
# ======================================================

def sigmoid(z):
    """
    Sigmoid nonlinearity (used in NCE).

    Args:
        z (np.ndarray)

    Returns:
        np.ndarray: same shape as z, values in (0,1)
    """
    # TODO: use np.clip for numerical stability
    z = np.clip(z, -50.0, 50.0)
    return 1.0 / (1.0 + np.exp(-z))


def softmax(scores):
    """
    Numerically stable softmax (row-wise).

    Args:
        scores (np.ndarray): shape (B, K)

    Returns:
        np.ndarray: probabilities, shape (B, K)
    """
    # TODO
    scores = np.asarray(scores)
    m = np.max(scores, axis=1, keepdims=True)
    exp_scores = np.exp(scores - m)
    denom = np.sum(exp_scores, axis=1, keepdims=True)
    denom = np.clip(denom, 1e-12, None)
    return exp_scores / denom


# ======================================================
# GENERIC SAMPLER INTERFACE
# ======================================================

class Sampler:
    """
    Generic sampler interface.

    Students are encouraged to subclass this class to implement
    any proposal or noise distribution they want.
    """

    def sample(self, num_samples):
        """
        Draw samples from q.

        Args:
            num_samples (int)

        Returns:
            np.ndarray
        """
        raise NotImplementedError

    def prob(self, samples):
        """
        Evaluate q(samples).

        Args:
            samples (np.ndarray)

        Returns:
            np.ndarray: densities, shape (num_samples,)
        """
        raise NotImplementedError


class GaussianSampler(Sampler):
    """
    Example sampler: multivariate Gaussian q(x).
    """

    def __init__(self, mean, cov):
        """
        Args:
            mean (np.ndarray): shape (D,)
            cov (np.ndarray): shape (D, D)
        """
        self.mean = mean
        self.cov = cov

    def sample(self, num_samples):
        """
        Returns:
            np.ndarray: samples, shape (num_samples, D)
        """
        # TODO
        return np.random.multivariate_normal(self.mean, self.cov, size=num_samples)

    def prob(self, samples):
        """
        Args:
            samples (np.ndarray): shape (num_samples, D)

        Returns:
            densities (np.ndarray): shape (num_samples,)
        """
        # TODO
        samples = np.asarray(samples)
        d = samples.shape[1]
        diff = samples - self.mean

        # Use slogdet for numerical stability
        sign, logdet = np.linalg.slogdet(self.cov)
        if sign <= 0:
            # Fall back to pseudo-det if covariance is not strictly PD
            logdet = np.log(np.clip(np.linalg.det(self.cov), 1e-300, None))

        inv_cov = np.linalg.pinv(self.cov)
        quad = np.einsum('nd,dd,nd->n', diff, inv_cov, diff)

        log_norm = -0.5 * (d * np.log(2.0 * np.pi) + logdet)
        log_p = log_norm - 0.5 * quad
        return np.exp(log_p)


class CategoricalSampler(Sampler):
    """
    Example sampler: categorical distribution q(y).
    """

    def __init__(self, probs):
        """
        Args:
            probs (np.ndarray): shape (K,)
        """
        self.probs = probs

    def sample(self, num_samples):
        """
        Returns:
            np.ndarray: sampled labels, shape (num_samples,)
        """
        # TODO
        k = self.probs.shape[0]
        return np.random.choice(k, size=num_samples, p=self.probs)

    def prob(self, samples):
        """
        Args:
            samples (np.ndarray): shape (num_samples,)

        Returns:
            densities (np.ndarray) : shape (num_samples,)
        """
        # TODO
        samples = np.asarray(samples, dtype=int)
        return self.probs[samples]


# ======================================================
# SOFTMAX GENERATIVE CLASSIFIER (EXACT NORMALIZATION)
# ======================================================

class SoftmaxGenerativeClassifier:
    """
    Multi-class generative classifier trained using
    exact normalization (softmax).
    """

    def __init__(self, num_classes, lr=1e-2,
                 batch_size=64, max_epochs=50):
        """
        Args:
            num_classes (int): K
            lr (float)
            batch_size (int)
            max_epochs (int)
        """
        self.K = num_classes
        self.lr = lr
        self.batch_size = batch_size # also referred to as B in a lot of places
        self.max_epochs = max_epochs

        # Discriminative parameters
        self.W = None  # shape (K, D)
        self.b = None  # shape (K,)

        # Recovered generative parameters
        self.mu = None     # shape (K, D)
        self.Sigma = None # shape (D, D)
        self.pi = None    # shape (K,)

    def score(self, X):
        """
        Compute unnormalized scores p(x,y).

        Args:
            X (np.ndarray): shape (B, D)

        Returns:
            np.ndarray: shape (B, K)
        """
        # TODO
        return X @ self.W.T + self.b[None, :]

    def gradients(self, X, y):
        """
        Gradients of conditional log-likelihood.

        Args:
            X (np.ndarray): shape (B, D)
            y (np.ndarray): shape (B,)

        Returns:
            tuple W,b
                'W': np.ndarray, shape (K, D)
                'b': np.ndarray, shape (K,)
        """
        # TODO
        B = X.shape[0]
        scores = self.score(X)
        probs = softmax(scores)

        # Gradient of negative log-likelihood
        probs[np.arange(B), y] -= 1.0
        grad_W = (probs.T @ X) / B
        grad_b = np.mean(probs, axis=0)
        return grad_W, grad_b

    def fit(self, X, y):
        """
        Train using mini-batch gradient descent.

        Args:
            X (np.ndarray): shape (N, D)
            y (np.ndarray): shape (N,)
        """
        # TODO
        X = np.asarray(X)
        y = np.asarray(y, dtype=int)
        N, D = X.shape

        rng = np.random.default_rng()

        if self.W is None:
            self.W = 0.01 * rng.standard_normal((self.K, D))
        if self.b is None:
            self.b = np.zeros(self.K, dtype=float)

        B = self.batch_size

        for _ in range(self.max_epochs):
            perm = rng.permutation(N)
            X_shuf = X[perm]
            y_shuf = y[perm]

            for start in range(0, N, B):
                end = min(start + B, N)
                Xb = X_shuf[start:end]
                yb = y_shuf[start:end]

                grad_W, grad_b = self.gradients(Xb, yb)
                self.W -= self.lr * grad_W
                self.b -= self.lr * grad_b

    def predict_proba(self, X):
        """
        Compute p(y|x) using exact softmax.

        Args:
            X (np.ndarray): shape (N, D)

        Returns:
            np.ndarray: shape (N, K)
        """
        # TODO
        return softmax(self.score(X))

    def predict(self, X):
        """
        Returns the actual prediction on the basis of predicted probabilities

        Args:
            X (np.ndarray): shape (N, D)

        Returns:
            np.ndarray: shape (N,)
        """
        # TODO 
        return np.argmax(self.predict_proba(X), axis=1)

    def recover_parameters(self):
        """
        Recover Gaussian parameters from trained W and b.


        Stores the parameters pi_k and Sigma into the class variables, note that self.mu
        will be populated by the main code by this point, so assume that self.mu contains the correct value
        """
        # TODO
        if self.W is None or self.b is None:
            raise ValueError("Model must be trained (W and b must be set) before recovering parameters.")
        if self.mu is None:
            raise ValueError("self.mu must be populated (class means) before recovering parameters.")

        # From the problem statement: w_k = Sigma^{-1} mu_k  =>  mu_k = Sigma w_k.
        # Stack across k: Mu^T (D,K) = Sigma (D,D) @ W^T (D,K).
        MuT = self.mu.T  # (D, K)
        WT = self.W.T    # (D, K)
        Sigma = MuT @ np.linalg.pinv(WT)  # (D, D)
        Sigma = 0.5 * (Sigma + Sigma.T)   # enforce symmetry

        # Small ridge for numerical stability
        Sigma = Sigma + 1e-6 * np.eye(Sigma.shape[0])
        self.Sigma = Sigma

        invSigma = np.linalg.pinv(Sigma)
        quad = np.einsum('kd,dd,kd->k', self.mu, invSigma, self.mu)

        # b_k = -0.5 * mu_k^T Sigma^{-1} mu_k + log pi_k
        log_pi_unnorm = self.b + 0.5 * quad
        m = np.max(log_pi_unnorm)
        pi_unnorm = np.exp(log_pi_unnorm - m)
        self.pi = pi_unnorm / np.sum(pi_unnorm)


# ======================================================
# IMPORTANCE SAMPLING CLASSIFIER
# ======================================================

class ImportanceSamplingClassifier:
    """
    Multi-class generative classifier trained using
    importance sampling to approximate normalization.
    """

    def __init__(self, num_classes, lr=1e-2,
                 batch_size=64, num_samples=10, max_epochs=50,
                 class_sampler=None):
        """
        Args:
            num_classes (int)
            lr (float)
            batch_size (int)
            num_samples (int): M
            max_epochs (int)
            class_sampler (Sampler): q(y)
        """
        self.K = num_classes
        self.lr = lr
        self.batch_size = batch_size
        self.M = num_samples
        self.max_epochs = max_epochs
        self.class_sampler = class_sampler

        self.W = None  # shape (K, D)
        self.b = None  # shape (K,)

    def score(self, X):
        """
        Args:
            X (np.ndarray): shape (B, D)

        Returns:
            np.ndarray: shape (B, K)
        """
        # TODO
        return X @ self.W.T + self.b[None, :]

    def estimate_normalizer(self, X):
        """
        Importance-sampled estimate of Z(x). Note that you should reuse the samples of y obtained for 1 batch
        Only draw new samples when you move to the next batch in training

        Args:
            X (np.ndarray): shape (B, D)

        Returns:
            np.ndarray: shape (B,)
        """
        # TODO
        eps = 1e-12

        if self.class_sampler is None:
            self.class_sampler = CategoricalSampler(np.ones(self.K) / self.K)

        # Reuse cached samples within a batch if present

        y_cache = getattr(self, "_cached_y_samples", None)
        q_cache = getattr(self, "_cached_q_probs", None)
        if y_cache is None or q_cache is None:
            y_cache = self.class_sampler.sample(self.M)
            q_cache = self.class_sampler.prob(y_cache)
            self._cached_y_samples = y_cache
            self._cached_q_probs = q_cache

        y_samp = np.asarray(y_cache, dtype=int)
        q_probs = np.clip(np.asarray(q_cache, dtype=float), eps, None)

        # Compute scores only for sampled classes
        scores_samp = X @ self.W[y_samp].T + self.b[y_samp]  # (B, M)

        # log Z_hat(x) = logsumexp(scores - log q) - log M
        t = scores_samp - np.log(q_probs)[None, :]
        m = np.max(t, axis=1, keepdims=True)
        sumexp = np.sum(np.exp(t - m), axis=1)
        logsumexp = m.squeeze(1) + np.log(np.clip(sumexp, eps, None))
        log_Z_hat = logsumexp - np.log(self.M)
        return np.exp(log_Z_hat)

    def gradients(self, X, y):
        """
        Gradients of IS objective.

        Args:
            X (np.ndarray): shape (B, D)
            y (np.ndarray): shape (B,)

        Returns:
            grad_W,grad_b
                'grad_W': np.ndarray, shape (K, D)
                'grad_b': np.ndarray, shape (K,)
        """
        # TODO
        eps = 1e-12
        X = np.asarray(X)
        y = np.asarray(y, dtype=int)
        B, D = X.shape

        if self.class_sampler is None:
            self.class_sampler = CategoricalSampler(np.ones(self.K) / self.K)

        y_cache = getattr(self, "_cached_y_samples", None)
        q_cache = getattr(self, "_cached_q_probs", None)
        if y_cache is None or q_cache is None:
            y_cache = self.class_sampler.sample(self.M)
            q_cache = self.class_sampler.prob(y_cache)
            self._cached_y_samples = y_cache
            self._cached_q_probs = q_cache

        y_samp = np.asarray(y_cache, dtype=int)
        q_probs = np.clip(np.asarray(q_cache, dtype=float), eps, None)

        # t_{i,m} = score(x_i, y_m) - log q(y_m)
        scores_samp = X @ self.W[y_samp].T + self.b[y_samp]  # (B, M)
        t = scores_samp - np.log(q_probs)[None, :]

        # alpha_{i,m} = softmax over m of t_{i,m}
        t_max = np.max(t, axis=1, keepdims=True)
        exp_t = np.exp(t - t_max)
        denom = np.sum(exp_t, axis=1, keepdims=True)
        denom = np.clip(denom, eps, None)
        alpha = exp_t / denom  # (B, M)

        grad_W = np.zeros((self.K, D), dtype=float)
        grad_b = np.zeros((self.K,), dtype=float)

        # Contribution from log Z_hat term: add alpha-weighted x to sampled labels
        contrib_W_m = (alpha.T @ X) / B  # (M, D)
        np.add.at(grad_W, y_samp, contrib_W_m)

        contrib_b_m = np.sum(alpha, axis=0) / B  # (M,)
        np.add.at(grad_b, y_samp, contrib_b_m)

        # Contribution from -score(x_i, y_i): subtract x from true labels
        np.add.at(grad_W, y, -X / B)
        np.add.at(grad_b, y, -1.0 / B)

        return grad_W, grad_b

    def fit(self, X, y):
        """
        Train using mini-batch gradient descent.

        Args:
            X (np.ndarray): shape (N, D)
            y (np.ndarray): shape (N,)
        """
        # TODO
        # Note that you can use a custom sampler by simply defining it here instead of using the class sampler
        # Please note that 1 epoch means 1 complete pass over the whole data, hence the number of steps in 1 epoch is roughly 
        # data size divided by the batch size
        # The best way to run mini batch is to shuffle the data and then makes passes of the batch size along it
        X = np.asarray(X)
        y = np.asarray(y, dtype=int)
        N, D = X.shape

        rng = np.random.default_rng()

        if self.W is None:
            self.W = 0.01 * rng.standard_normal((self.K, D))
        if self.b is None:
            self.b = np.zeros(self.K, dtype=float)

        if self.class_sampler is None:
            self.class_sampler = CategoricalSampler(np.ones(self.K) / self.K)

        B = self.batch_size

        for _ in range(self.max_epochs):
            perm = rng.permutation(N)
            X_shuf = X[perm]
            y_shuf = y[perm]

            for start in range(0, N, B):
                end = min(start + B, N)
                Xb = X_shuf[start:end]
                yb = y_shuf[start:end]

                # Cache a fresh set of class samples for this batch
                self._cached_y_samples = self.class_sampler.sample(self.M)
                self._cached_q_probs = self.class_sampler.prob(self._cached_y_samples)

                grad_W, grad_b = self.gradients(Xb, yb)
                self.W -= self.lr * grad_W
                self.b -= self.lr * grad_b

        # Clear cache after training
        self._cached_y_samples = None
        self._cached_q_probs = None

    def predict_proba(self, X):
        """
        Args:
            X (np.ndarray): shape (N, D)

        Returns:
            np.ndarray: shape (N, K)
        """
        # TODO
        X = np.asarray(X)

        # Use fresh samples to estimate Z(x) at inference
        self._cached_y_samples = None
        self._cached_q_probs = None

        Z_hat = self.estimate_normalizer(X)  # (N,)
        Z_hat = np.clip(Z_hat, 1e-12, None)

        scores = self.score(X)  # (N, K)
        m = np.max(scores, axis=1, keepdims=True)
        num = np.exp(scores - m)
        denom = (Z_hat * np.exp(-m.squeeze(1)))
        denom = np.clip(denom, 1e-12, None)
        return num / denom[:, None]

    def predict(self, X):
        """
        Returns the actual prediction on the basis of predicted probabilities

        Args:
            X (np.ndarray): shape (N, D)

        Returns:
            np.ndarray: shape (N,)
        """
        # TODO 
        return np.argmax(self.score(X), axis=1)


# ======================================================
# NOISE CONTRASTIVE ESTIMATION CLASSIFIER
# ======================================================

class NCEClassifier:
    """
    Multi-class generative classifier trained using
    Noise Contrastive Estimation.
    """

    def __init__(self, num_classes, lr=1e-2,
                 batch_size=64, noise_ratio=5, max_epochs=500,
                 x_sampler=None, y_sampler=None):
        """
        Args:
            num_classes (int)
            lr (float)
            batch_size (int)
            noise_ratio (int): k
            max_epochs (int)
            x_sampler (Sampler): q(x)
            y_sampler (Sampler): q(y)
        """
        self.K = num_classes
        self.lr = lr
        self.batch_size = batch_size
        self.k = noise_ratio
        self.max_epochs = max_epochs
        self.x_sampler = x_sampler
        self.y_sampler = y_sampler

        self.W = None  # shape (K, D)
        self.b = None  # shape (K,)
        self.c = None  # scalar

    def score(self, X, y):
        """
        Compute p(x,y).

        Args:
            X (np.ndarray): shape (B, D)
            y (np.ndarray): shape (B,)

        Returns:
            np.ndarray: shape (B,)
        """
        # TODO
        X = np.asarray(X)
        y = np.asarray(y, dtype=int)
        f = np.einsum('bd,bd->b', X, self.W[y]) + self.b[y]
        return np.exp(f - self.c)

    def sample_noise(self, num_samples):
        """
        Sample noise pairs from q(x,y).

        Args:
            num_samples (int)

        Returns:
            tuple:
                X_noise (np.ndarray): shape (num_samples, D)
                y_noise (np.ndarray): shape (num_samples,)
        """
        # TODO
        if self.x_sampler is None or self.y_sampler is None:
            raise ValueError("x_sampler and y_sampler must be set before sampling noise.")

        X_noise = self.x_sampler.sample(num_samples)
        y_noise = self.y_sampler.sample(num_samples)
        return X_noise, y_noise

    def gradients(self, X, y):
        """
        Gradients of NCE objective.

        Args:
            X (np.ndarray): shape (B, D)
            y (np.ndarray): shape (B,)

        Returns:
            grad_W, grad_b, grad_c
                'grad_W': np.ndarray, shape (K, D)
                'grad_b': np.ndarray, shape (K,)
                'grad_c': float
        """
        # TODO
        eps = 1e-12
        X = np.asarray(X)
        y = np.asarray(y, dtype=int)
        B, D = X.shape

        grad_W = np.zeros((self.K, D), dtype=float)
        grad_b = np.zeros((self.K,), dtype=float)
        grad_c = 0.0

        # ---- Positive (data) samples ----
        f_pos = np.einsum('bd,bd->b', X, self.W[y]) + self.b[y]
        q_pos = self.x_sampler.prob(X) * self.y_sampler.prob(y)
        q_pos = np.clip(q_pos, eps, None)
        g_pos = f_pos - self.c - (np.log(self.k) + np.log(q_pos))
        s_pos = sigmoid(g_pos)

        # d/d f of -log sigma(g) is sigma(g) - 1
        coef_pos = s_pos - 1.0
        np.add.at(grad_W, y, coef_pos[:, None] * X)
        np.add.at(grad_b, y, coef_pos)

        # d/dc contribution: (1 - sigma(g))
        grad_c += float(np.sum(1.0 - s_pos))

        # ---- Negative (noise) samples ----
        num_noise = B * self.k
        Xn, yn = self.sample_noise(num_noise)
        yn = np.asarray(yn, dtype=int)

        f_neg = np.einsum('nd,nd->n', Xn, self.W[yn]) + self.b[yn]
        q_neg = self.x_sampler.prob(Xn) * self.y_sampler.prob(yn)
        q_neg = np.clip(q_neg, eps, None)
        g_neg = f_neg - self.c - (np.log(self.k) + np.log(q_neg))
        s_neg = sigmoid(g_neg)

        # For noise: d/d f of -log(1-sigma(g)) is sigma(g)
        coef_neg = s_neg
        np.add.at(grad_W, yn, coef_neg[:, None] * Xn)
        np.add.at(grad_b, yn, coef_neg)

        # d/dc contribution: -sigma(g)
        grad_c += float(np.sum(-s_neg))

        # Scale by batch size (per-data-point objective with k noises)
        grad_W /= B
        grad_b /= B
        grad_c /= B

        return grad_W, grad_b, grad_c

    def fit(self, X, y):
        """
        Train using mini-batch gradient descent.

        Args:
            X (np.ndarray): shape (N, D)
            y (np.ndarray): shape (N,)
        """
        # TODO
        # Note that you can use a custom sampler by simply defining it here instead of using the class sampler
        # Please note that 1 epoch means 1 complete pass over the whole data, hence the number of steps in 1 epoch is roughly 
        # The best way to run mini batch is to shuffle the data and then makes passes of the batch size along it
        X = np.asarray(X)
        y = np.asarray(y, dtype=int)
        N, D = X.shape

        rng = np.random.default_rng()

        if self.W is None:
            self.W = 0.01 * rng.standard_normal((self.K, D))
        if self.b is None:
            self.b = np.zeros(self.K, dtype=float)
        if self.c is None:
            self.c = 0.0

        # Default noise distributions from the problem statement:
        # q(x) is Gaussian estimated from training data, q(y) uniform over classes.
        if self.x_sampler is None:
            mu_q = np.mean(X, axis=0)
            cov_q = np.cov(X, rowvar=False)
            cov_q = cov_q + 1e-3 * np.eye(D)
            self.x_sampler = GaussianSampler(mu_q, cov_q)

        if self.y_sampler is None:
            self.y_sampler = CategoricalSampler(np.ones(self.K) / self.K)

        B = self.batch_size

        for _ in range(self.max_epochs):
            perm = rng.permutation(N)
            X_shuf = X[perm]
            y_shuf = y[perm]

            for start in range(0, N, B):
                end = min(start + B, N)
                Xb = X_shuf[start:end]
                yb = y_shuf[start:end]

                grad_W, grad_b, grad_c = self.gradients(Xb, yb)
                self.W -= self.lr * grad_W
                self.b -= self.lr * grad_b
                self.c -= self.lr * grad_c

    def predict_proba(self, X):
        """
        Args:
            X (np.ndarray): shape (N, D)

        Returns:
            np.ndarray: shape (N, K)
        """
        # TODO
        X = np.asarray(X)
        scores = X @ self.W.T + self.b[None, :]
        return softmax(scores)

    def predict(self, X):
        """
        Returns the actual prediction on the basis of predicted probabilities

        Args:
            X (np.ndarray): shape (N, D)

        Returns:
            np.ndarray: shape (N,)
        """
        # TODO 
        return np.argmax(self.predict_proba(X), axis=1)
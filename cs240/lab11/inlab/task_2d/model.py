import torch
import torch.nn as nn
import math


def scaled_dot_product_attention(Q, K, V, mask=None):
    """
    1. Compute attention scores
    2. Scale by sqrt(d_k)
    3. Apply mask (if provided)
    4. Apply softmax
    5. Multiply with V
    """
    d_k = Q.size(-1)
    scores = torch.matmul(Q, K.transpose(-2,-1)) / math.sqrt(d_k)
    scores = scores+scores.transpose(-1,-2)
    attn = torch.softmax(scores, dim=-1)
    output = torch.matmul(attn, V)
    return output, attn


# NOTE: You can assume the input is already updated with positional embeddings.
class SymmetricMultiHeadAttention(nn.Module):
    def __init__(self, d_model, num_heads):
        """
        DO NOT MODIFY THE INIT FUNCTION
        """
        super().__init__()
        assert d_model % num_heads == 0
        self.num_heads = num_heads
        self.d_k = d_model // num_heads

        self.q_linear = nn.Linear(d_model, d_model)
        self.k_linear = nn.Linear(d_model, d_model)
        self.v_linear = nn.Linear(d_model, d_model)
        self.out_proj = nn.Linear(d_model, d_model)

    def forward(self, x):
        """
        Args:
        x (torch.Tensor): The input sequence embeddings. 
            Shape: (Batch Size, Seq_Len, d_model) -> (B, T, D)

        Returns:
            tuple:
                - output (torch.Tensor): The contextualized output embeddings after 
                linear projection.
                Shape: (Batch Size, Seq_Len, d_model) -> (B, T, D)
                - attn_weights (torch.Tensor): The normalized attention scores 
                representing token-to-token relationships across all heads.
                Shape: (Batch Size, num_heads, Seq_Len, Seq_Len) -> (B, H, T, T)
        """
        B, T, D = x.shape
        Q = self.q_linear(x).view(B, T, self.num_heads, self.d_k).transpose(1, 2)
        K = self.k_linear(x).view(B, T, self.num_heads, self.d_k).transpose(1, 2)
        V = self.v_linear(x).view(B, T, self.num_heads, self.d_k).transpose(1, 2)

        out, attn = scaled_dot_product_attention(Q, K, V)

        out = out.transpose(1, 2).contiguous().view(B, T, D)
        return self.out_proj(out), attn
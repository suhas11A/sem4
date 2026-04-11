import torch
import torch.nn as nn
import torch.nn.functional as F
import math

class RNNCell(nn.Module):
    def __init__(self, dim):
        """
        DO NOT MODIFY THE INIT FUNCTION
        """
        super().__init__()
        
        # h_t = tanh(W_hh * h_{t-1} + W_ih * x_t + bias)
        self.W = nn.Linear(dim, dim, bias=False)
        self.U_b = nn.Linear(dim, dim, bias=True)
        self.activation = nn.Tanh()
        self.V_c = nn.Linear(dim, dim, bias=True)

    def forward(self, x, hidden_prev):
        """
        Processes a single time step.
        x: (B, input_dim)
        hidden_prev: (B, hidden_dim)
        out: (B, hidden_dim)
        """
        ola = self.activation(self.W(hidden_prev)+self.U_b(x))
        return (ola, self.V_c(ola))
    
def scaled_dot_product_attention(Q, K, V, mask=None):
    # TODO: Use the code from Task 1 (DO NOT WRITE AGAIN)
    d_k = Q.size(-1)
    scores = torch.matmul(Q, K.transpose(-2,-1)) / math.sqrt(d_k)

    if mask is not None:
        scores = scores.masked_fill(mask == 0, -1e9)

    attn = torch.softmax(scores, dim=-1)
    output = torch.matmul(attn, V)
    return output, attn

class SinusoidalPE(nn.Module):
    def __init__(self, d_model, max_len=5000):
        super().__init__()
        pe = torch.zeros(max_len, d_model)
        position = torch.arange(0, max_len).unsqueeze(1)
        div_term = torch.exp(torch.arange(0, d_model, 2) * (-math.log(10000.0) / d_model))

        pe[:, 0::2] = torch.sin(position * div_term)
        pe[:, 1::2] = torch.cos(position * div_term)

        self.pe = pe.unsqueeze(0)

    def forward(self, x):
        return self.pe[:, :x.size(1)].to(x.device)


class MultiHeadAttention(nn.Module):
    def __init__(self, d_model, num_heads):
        super().__init__()
        assert d_model % num_heads == 0

        self.num_heads = num_heads
        self.d_k = d_model//num_heads

        self.q_linear = nn.Linear(d_model, d_model)
        self.k_linear = nn.Linear(d_model, d_model)
        self.v_linear = nn.Linear(d_model, d_model)

        self.out = nn.Linear(d_model, d_model)

    def forward(self, x):
        """
        1. Project x → Q, K, V
        2. Split into heads
        3. Apply attention
        4. Concatenate heads
        5. Final linear layer
        """
        B, T, D = x.shape
        # print(x.shape)
        # print(self.q_linear(x).shape)
        # print(B, T, self.num_heads, self.d_k)
        Q = self.q_linear(x).view(B, T, self.num_heads, self.d_k).transpose(1, 2)
        K = self.k_linear(x).view(B, T, self.num_heads, self.d_k).transpose(1, 2)
        V = self.v_linear(x).view(B, T, self.num_heads, self.d_k).transpose(1, 2)

        mask = torch.tril(torch.ones(T, T)).to(x.device)
        mask = mask.unsqueeze(0).unsqueeze(0)  # (1,1,T,T)

        out, attn = scaled_dot_product_attention(Q, K, V, mask)

        out = out.transpose(1, 2).contiguous().view(B, T, D)
        return self.out(out), attn

class TransformerEncoderBlock(nn.Module):
    def __init__(self, d_model, num_heads, d_ff):
        super().__init__()

        self.attn = MultiHeadAttention(d_model, num_heads)

        self.norm_att = nn.LayerNorm(d_model)
        self.norm_ff = nn.LayerNorm(d_model)

        self.ff = nn.Sequential(
            nn.Linear(d_model, d_ff),
            nn.Tanh(),
            nn.Linear(d_ff, d_model)
        )

    def forward(self, x):
        """
        1. Attention + residual + norm
        2. FFN + residual + norm
        """
        attn_out, attn = self.attn(x)
        x = self.norm_att(x + attn_out)
        x = self.norm_ff(x + self.ff(x))
        return x, attn


class BlockRecurrentTransformerModel(nn.Module):
    def __init__(self, d_model = 64, num_heads = 2, max_len=256, K = 3):
        """
        DO NOT MODIFY THE INIT FUNCTION
        """
        super().__init__()
        self.d_model = d_model
        self.K = K  # Block size

        self.embedding = nn.Embedding(10, d_model)

        self.pe = SinusoidalPE(d_model, max_len)

        self.rnn_cell = RNNCell(d_model)
        
        self.transformer = TransformerEncoderBlock(d_model, num_heads, d_model)

        self.fc = nn.Linear(d_model, 217) 

    def forward(self, x):
        """
        Args:
        x (torch.Tensor): The input sequence. 
            Shape: (Batch Size, Seq_Len) -> (B, T)

        Returns:
            - output (torch.Tensor): The contextualized output embeddings after 
            linear projection.
            Shape: (Batch Size, Seq_Len, d_model) -> (B, T, D)
        """
        x = self.embedding(x)

        # attn_maps = []
        # for layer in self.layers:
        #     x, attn = layer(x)
        #     attn_maps.append(attn)
        # return self.fc(x), attn_maps
        

        N = int(x.shape[-2])
        K = int(self.K)
        M = int(N/K)

        outs_big = []
        main_h = []
        omi = 0
        for i in range(M):
            h_prev = torch.zeros((self.d_model))
            for j in range(K):
                x_temp = x[:,omi]
                omi+=1
                h_prev, ola2 = self.rnn_cell(x_temp, h_prev)
                outs_big.append(ola2[:,:,None])

            main_h.append(h_prev[:,:,None])

        main_h = torch.cat(main_h, dim=2).transpose(-1,-2)
        outs_big = torch.cat(outs_big, dim=2).transpose(-1,-2)
        pee=self.pe(main_h)[:M]
        main_h = main_h + pee
        main_h, attn = self.transformer(main_h)
        main_h = main_h[:,:,None,:]
        shapo = main_h.shape
        print(shapo)
        zeros = torch.zeros((shapo[0], M, K, shapo[3]))
        print(zeros.shape)
        main_h = main_h+zeros
        main_h.squeeze((1,2))
        outs_big = outs_big+main_h
        return outs_big

        

        





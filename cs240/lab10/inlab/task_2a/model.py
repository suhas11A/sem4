import torch
import torch.nn as nn
import math

# NOTE: Feel free to create more classes and functions if you like. 

class RNNCell(nn.Module):
    def __init__(self, dim):
        super().__init__()
        self.W = nn.Linear(1, 1, bias=True, dtype=float)
        self.V_c = nn.Linear(1, 1, bias=True, dtype=float)

    def forward(self, x):
        """
        Processes a single time step.
        x: (B, input_dim)
        hidden_prev: (B, hidden_dim)
        out: (B, hidden_dim)
        """
        hidden = self.W(x)
        out = self.V_c(hidden)
        return hidden, out

class RNNModel(nn.Module):
    def __init__(self, K, d_model=64, num_layers=2):
        super().__init__()
        self.d_model = d_model
        self.output_vocab = 30
        self.layer = RNNCell(d_model)
        self.fc = nn.Linear(1, self.output_vocab, dtype=float)

    def forward(self, x):
        """
        x: (B, T) -> Integer tokens
        returns: 
        logits of shape (B, output_vocab) [note: do not apply softmax, since that is handled by the loss function internally]
        """        
        B, T = x.shape
        x = torch.as_tensor(x, dtype=float)
        out = []
        for t in range(T):
            x_t = x[:, t:t+1]
            h_t, o_t = self.layer(x_t)
            out.append(o_t)

        out = torch.stack(out, dim=1)
        out = self.fc(out)
        
        return out
        

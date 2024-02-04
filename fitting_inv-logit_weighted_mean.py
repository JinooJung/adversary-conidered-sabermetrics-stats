import numpy as np
import pandas as pd
import torch
import torch.nn as nn
from tqdm import tqdm

###### User Interface ######
versus_data_path = "versus_data_23ML.csv"
batter_data_path = "batter_data_23ML.csv"
pitcher_data_path = "pitcher_data_23ML.csv"
ckpt_path = "ckpt/inv-logit_weighted_mean_23ML"
ckpt_name = "inv-logit_weighted_mean_23ML"


# Load data
versus_data = pd.read_csv(versus_data_path)
batter_data = pd.read_csv(batter_data_path)
pitcher_data = pd.read_csv(pitcher_data_path)


class VSModel(nn.Module):
    def __init__(self, batter, pitcher, versus):
        super(VSModel, self).__init__()
        self.versus = versus
        self.batter_name = [b for b in batter["batter"]]
        self.pitcher_name = [p for p in pitcher["pitcher"]]
               
        self.v1 = nn.Parameter(torch.Tensor(list(batter["average"]))-torch.ones(len(batter["average"])))
        self.v2 = nn.Parameter(torch.Tensor(list(pitcher["average"]))-torch.ones(len(pitcher["average"])))
        self.weight = nn.Parameter(torch.Tensor([0.5]))
        
        
    def forward(self):
        loglikelihood = 0
        for i in range(len(self.versus)):
            batter_index = self.batter_name.index(self.versus["batter"][i])
            pitcher_index = self.pitcher_name.index(self.versus["pitcher"][i])
            temp =  torch.exp(self.weight*self.v1[batter_index]+(1-self.weight)*self.v2[pitcher_index])
            prob = temp/(1+temp)
            prob = torch.clamp(prob, 0.000001, 0.999999)
            loglikelihood += self.versus["event1"][i]*torch.log(prob) + self.versus["event2"][i]*torch.log(1-prob)
        
        return loglikelihood
    
model = VSModel(batter_data, pitcher_data, versus_data)

optimizer = torch.optim.Adam(model.parameters(), lr=0.001)
for epoch in tqdm(range(3000)):
    optimizer.zero_grad()
    loss = -model.forward()
    loss.backward()
    optimizer.step()
    if(epoch%100==99):
        print("Epoch: ", epoch+1, "Loss: ", loss.item(), "Weight: ", model.weight.item())
        torch.save(model.state_dict(), f"{ckpt_path}/{ckpt_name}_{epoch+1}.pt")
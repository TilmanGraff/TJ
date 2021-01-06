# prereqs

import pandas as pd
import numpy as np
import os

os.chdir("/Users/tilmangraff/Documents/GitHub/TJ")

Vraw = np.array(pd.read_csv("./input/temp/testenvironment/V.csv"))
adj = np.array(pd.read_csv("./input/temp/testenvironment/adj.csv"))

n = len(Vraw)-1

# create dictionaries
V = {}
nb = {}

for i in range(n):
    my_dict = dict(zip(range(n), Vraw[i,:]))
    V[i] = my_dict
    nb[i] = list(np.array(np.where(adj[i,:]==1)).flat)

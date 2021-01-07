# prereqs

import pandas as pd
import numpy as np
import os

os.chdir("/Users/tilmangraff/Documents/GitHub/TJ")

Vraw = np.array(pd.read_csv("./input/temp/testenvironment/V.csv"))
adj = np.array(pd.read_csv("./input/temp/testenvironment/adj.csv"))
dist = np.array(pd.read_csv("./input/temp/testenvironment/dist.csv"))

n = len(Vraw)

# create dictionaries
V = {}
nb = {}
cdrive = {}
bdrive = {}
cdrivemat = dist

for i in range(n):
    my_dict = dict(zip(range(n), Vraw[i,:]))
    V[i] = my_dict
    nb[i] = list(np.array(np.where(adj[i,:]==1)).flat)

    my_dict = dict(zip(range(n), dist[i,:]))
    cdrive[i] = my_dict

    my_dict = dict(zip(range(n), dist[i,:]*0.5)) # lets just say for now you can go double as fast by bus...
    bdrive[i] = my_dict

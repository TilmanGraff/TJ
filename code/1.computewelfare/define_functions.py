# init

import pandas as pd
import numpy as np
import os

os.chdir("/Users/tilmangraff/Documents/GitHub/TJ")


# read in environment
exec(open("./code/0.environment/read_env.py").read())

# initialise some line
bl = [0, 2, 7, 8, 15, 25, 37, 51, 52, 66, 53]

# construct direct connections matrix D
D = np.zeros((n,n), dtype=int)
D[bl,:] = 1 # fill entire lines of connected nodes
D = D * D.T # multiply by transpose to identify connected cells

# construct travel times between connected cells
print(D)

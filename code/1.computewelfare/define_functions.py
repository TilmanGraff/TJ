# init

import pandas as pd
import numpy as np
import os

os.chdir("/Users/tilmangraff/Documents/GitHub/TJ")


# read in environment
exec(open("./code/0.environment/read_env.py").read())

# initialise some line
bl = [[0, 2, 7, 8, 15, 25, 37, 51, 52, 66, 53], 50] # lines are always a tupel of an array (number of stops) and an integer (number of busses)

# construct linkdists
def compute_linkdists(bl):
    return [bdrive[bl[0][i]][bl[0][i+1]] for i in range((len(bl[0])-1))]

# construct travel times between connected cells (add linkdists later)
def compute_busline(bl, linkdists = compute_linkdists(bl)):
    dto1 = [sum(linkdists[0:i]) for i in range(len(bl[0]))]
    stops = np.asarray([np.abs(np.subtract(dto1, dto1[i])) for i in range(len(bl[0]))])
    return stops


# construct direct connections matrices
def compute_direct_connections_route(bl):
    # construct direct connections matrix D
    D = np.zeros((n,n), dtype=int)
    D[bl[0],:] = 1 # fill entire lines of connected nodes
    D = D * D.T # multiply by transpose to identify connected cells

    C = np.full((n,n), float("inf"))
    C[np.array(bl[0])[:,np.newaxis], bl[0]] = compute_busline(bl)

    return C,D

def construct_travel_matrix(bls,cdrivemat):
    num_lines = len(bls)
    all_buslines = [compute_direct_connections_route(bls[i])[0] for i in range(num_lines)]
    all_routes = np.dstack((np.moveaxis(all_buslines, 0, 2), cdrivemat))

    return np.array(all_routes)

def simple_welfare(bls,cdrivemat,Vraw):
    min3d = np.amin(construct_travel_matrix(bls, cdrivemat), 2) # fastest travel time / bus or car
    welf = np.sum(min3d * Vraw)

    return welf

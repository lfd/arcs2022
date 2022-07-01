# coding: utf-8


import numpy as np
import io
import itertools
import networkx as nx
from qiskit.exceptions import MissingOptionalLibraryError



"""
#####################################################################################################
# Generate Graph and QUBO for MaxCut problem
#####################################################################################################
"""


def generate_graph_from_density(num_nodes, density):

    """
    Input: 
    num_nodes: number of nodes  
    density: coupling density = number of edges / maximum number of edges

    Output:
    Graph G
    """


    G = nx.Graph()
    nodes=np.linspace(0, num_nodes-1, num_nodes).astype(int)
    G.add_nodes_from(nodes)

    #Randomly set edges with the given density
    max_edge_list = list(itertools.combinations(nodes, 2)) # all egdes that would be possible
    max_edges = len(max_edge_list)
    num_edges = np.round(max_edges*density).astype(int)

    edges=[]
    for j in range(num_edges):
        edge=max_edge_list[np.random.choice(np.arange(len(max_edge_list)), size=1, replace=False)[0]]
        edges.append(edge)
        max_edge_list.remove(edge)

    G.add_edges_from(edges)

    return G




def get_qubo_maxcut(G):
    """
    Parameters:
    G: Graph with nodes and edges

    Output: QUBO-matrix
    """

    n_qubits=len(list(G.nodes))

    H=np.zeros((n_qubits, n_qubits))
    for pair in list(G.edges()):
        H[pair[0],pair[0]]+=1
        H[pair[1],pair[1]]+=1
        H[pair[0],pair[1]]+=-2
    return H




"""
#####################################################################################################
# Functions to analyze and plot graphs
#####################################################################################################
"""



# get connectivity map (tuples of connected qubits) from QUBO-matrix
def get_problem_connectivity_from_QUBO(H):
    conn=[]
    for j in range(len(H)):
        for i in range(len(H)):
            if i != j and np.abs(H[i,j])>0:
                conn.append([i,j]) 
                conn.append([j,i]) # since H is triagonal, we already add the double index for the qiskit connectivity graph here.
    return conn



def get_adjacency_matrix_from_QUBO(H): #if two qubits need to be connected, there is a 1, the diagonal is 0. Since we are dealing with undirected graphs, the matrix is symmetric.
    ad=H.copy()
    for j in range(len(H)):
        for i in range(len(H)):
            if i != j and np.abs(H[i,j])>0:
                ad[i,j]=1 
                ad[j,i]=1 # since H is triagonal, we already add the symmetric entry here
    np.fill_diagonal(ad, 0)
    return ad

# drawing functionality to maker nicer graphs --> choose option fdp
def draw_graph(G, prog):
    """
    prog options: neato, dot, twopi, fdp, circo
    """
    try:
        import pydot
    except ImportError as ex:
        raise MissingOptionalLibraryError(
            libname="pydot",
            name="coupling map drawer",
            pip_install="pip install pydot",
        ) from ex

    try:
        from PIL import Image
    except ImportError as ex:
        raise MissingOptionalLibraryError(
            libname="pillow",
            name="coupling map drawer",
            pip_install="pip install pillow",
        ) from ex


    dot_str = G.graph.to_dot()
    dot = pydot.graph_from_dot_data(dot_str[:-3]+'}')[0]
    png = dot.create_png(prog=prog)
    return Image.open(io.BytesIO(png))
module SimpleTensorNetworks

import Graphs: Graphs, add_edge!, has_edge, AbstractGraph, is_connected, neighbors
import NamedGraphs: NamedGraphs, NamedEdge, NamedGraph, vertextype, vertices
import NamedGraphs.GraphsExtensions:
    GraphsExtensions,
    edge_path,
    leaf_vertices,
    post_order_dfs_edges,
    post_order_dfs_vertices,
    is_leaf_vertex,
    all_incident_edges
import DataGraphs:
    DataGraphs,
    DataGraph,
    AbstractDataGraph,
    underlying_graph,
    underlying_graph_type,
    vertex_data,
    edge_data

import ITensors: ITensors, ITensor, Index, dim, uniqueinds
import ITensorMPS
import ITensors: Algorithm, @Algorithm_str
import LinearAlgebra

#include("index.jl")
#include("indexedarray.jl")
#include("contraction.jl")
#include("simpletensornetwork.jl")

include("defaults.jl")
include("tensortrain.jl")

include("contraction.jl")

end

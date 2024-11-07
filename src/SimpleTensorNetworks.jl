module SimpleTensorNetworks

import Graphs: Graphs, add_edge!, has_edge, AbstractGraph
import NamedGraphs: NamedGraphs, NamedEdge, NamedGraph, vertextype, vertices
import NamedGraphs.GraphsExtensions:
    GraphsExtensions,
    edge_path,
    leaf_vertices,
    post_order_dfs_edges,
    post_order_dfs_vertices
import DataGraphs:
    DataGraphs, DataGraph, AbstractDataGraph, underlying_graph, underlying_graph_type

include("index.jl")
include("indexedarray.jl")
include("contraction.jl")
include("simpletensornetwork.jl")

end

using DataGraphs: DataGraphs, DataGraph
using NamedGraphs: NamedGraphs, NamedEdge, NamedGraph, vertextype

"""
Generic tensor network data structure
"""
mutable struct TensorNetwork
    data_graph::DataGraph{Int,IndexedArray,IndexedArray,NamedGraph{Int},NamedEdge{Int}}
end

"""
Return if a tensor network `tn` is loop-free, i.e., `tn` is a tree tensor network
"""
function isloopfree(tn::TensorNetwork)
    return isloopfree(tn.data_graph)
end
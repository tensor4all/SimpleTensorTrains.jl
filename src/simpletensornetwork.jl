"""
Generic tensor network data structure
"""
mutable struct SimpleTensorNetwork
    # data_graph: (undirected) graph of the tensor network
    #   An integer is assigned to each vertex (starting from 1 and increasing one by one).
    #   We can place an IndexedArray at each vertex of the graph, and an edge between two vertices.
    #   But, the latter is not supported by the current implementation of SimpleTensorNetworks.jl.
    #   This may be useful for supporting the Vidal notation.
    data_graph::DataGraph{Int,IndexedArray,IndexedArray,NamedGraph{Int},NamedEdge{Int}}
end

function SimpleTensorNetwork(ts::AbstractVector{<:AbstractIndexedArray})
    g = NamedGraph(collect(eachindex(ts)))
    tn = SimpleTensorNetwork(DataGraph{Int,IndexedArray,IndexedArray,NamedGraph{Int},NamedEdge{Int}}(g))
    for v in vertices(g)
      tn[v] = ts[v]
    end
    return tn
end

function Base.setindex!(tn::SimpleTensorNetwork, t::AbstractIndexedArray, v::Int)
    tn.data_graph[v] = t
end

"""
Return if a tensor network `tn` is loop-free, i.e., `tn` is a tree tensor network
"""
function isloopfree(tn::SimpleTensorNetwork)
    # FIXME: Implement this function
end
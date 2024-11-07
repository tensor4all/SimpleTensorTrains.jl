"""
Generic tensor network data structure
"""
mutable struct SimpleTensorNetwork <: AbstractDataGraph{Int,IndexedArray,IndexedArray}
    # data_graph: (undirected) graph of the tensor network
    #   An integer is assigned to each vertex (starting from 1 and increasing one by one).
    #   We can place an IndexedArray at each vertex of the graph, and an edge between two vertices.
    #   But, the latter is not supported by the current implementation of SimpleTensorNetworks.jl.
    #   This may be useful for supporting the Vidal notation.
    data_graph::DataGraph{Int,IndexedArray,IndexedArray,NamedGraph{Int},NamedEdge{Int}}
end

function SimpleTensorNetwork(ts::AbstractVector{<:AbstractIndexedArray})
    g = NamedGraph(collect(eachindex(ts)))
    dg = DataGraph{Int,IndexedArray,IndexedArray,NamedGraph{Int},NamedEdge{Int}}(g)

    for (t, v) in zip(ts, vertices(dg))
        dg[v] = t
    end
    for v in vertices(dg), v2 in vertices(dg)
        if DataGraphs.is_edge_arranged(dg, NamedEdge(v => v2))
            if hascommondindices(dg[v], dg[v2])
                add_edge!(dg, v => v2)
            end
        end
    end
    tn = SimpleTensorNetwork(dg)
    return tn
end

data_graph(tn::SimpleTensorNetwork) = getfield(tn, :data_graph)
data_graph_type(TN::Type{<:SimpleTensorNetwork}) = fieldtype(TN, :data_graph)
DataGraphs.underlying_graph(tn::SimpleTensorNetwork) = underlying_graph(data_graph(tn))
DataGraphs.underlying_graph_type(TN::Type{<:SimpleTensorNetwork}) =
    fieldtype(data_graph_type(TN), :underlying_graph)

function Base.setindex!(tn::SimpleTensorNetwork, t::AbstractIndexedArray, v::Int)
    tn.data_graph[v] = t
end

function Base.getindex(tn::SimpleTensorNetwork, v::Int)
    return tn.data_graph[v]
end

"""
Return if a tensor network `tn` has a cycle. If it has not a cycle, `tn` is a tree tensor network.
"""
Graphs.is_cyclic(tn::SimpleTensorNetwork) =
    Graphs.is_cyclic(tn.data_graph.underlying_graph.position_graph)


Graphs.has_edge(tn::SimpleTensorNetwork, e::NamedEdge) = Graphs.has_edge(tn.data_graph, e)

"""
Contract all the tensors in a tensor network `tn` and return the result.

This function works only for tree tensor networks, i.e., `is_cyclic(tn) == false`.

root_vertex: The vertex to start the contraction. The default is 1.
"""
function complete_contraction(tn::SimpleTensorNetwork; root_vertex::Int = 1)
    !Graphs.is_cyclic(tn) ||
        error("complete_contraction is not supported only for a tree tensor network.")

end

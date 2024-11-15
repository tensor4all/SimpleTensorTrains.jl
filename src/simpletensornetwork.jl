"""
Generic tensor network data structure
"""
mutable struct TensorNetwork <: AbstractDataGraph{Int,IndexedArray,IndexedArray}
    # data_graph: (undirected) graph of the tensor network
    #   An integer is assigned to each vertex (starting from 1 and increasing one by one).
    #   We can place an IndexedArray at each vertex of the graph, and an edge between two vertices.
    #   But, the latter is not supported by the current implementation of SimpleTensorNetworks.jl.
    #   This may be useful for supporting the Vidal notation.
    data_graph::DataGraph{Int,IndexedArray,IndexedArray,NamedGraph{Int},NamedEdge{Int}}

    function TensorNetwork(
        dg::DataGraph{Int,IndexedArray,IndexedArray,NamedGraph{Int},NamedEdge{Int}},
    )
        is_connected(dg) || error("TensorNetwork is only supported for a connected graph.")
        new(dg)
    end
end

function TensorNetwork(ts::AbstractVector{<:AbstractIndexedArray})
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
    tn = TensorNetwork(dg)
    return tn
end

data_graph(tn::TensorNetwork) = getfield(tn, :data_graph)
data_graph_type(TN::Type{<:TensorNetwork}) = fieldtype(TN, :data_graph)
DataGraphs.underlying_graph(tn::TensorNetwork) = underlying_graph(data_graph(tn))
DataGraphs.underlying_graph_type(TN::Type{<:TensorNetwork}) =
    fieldtype(data_graph_type(TN), :underlying_graph)
DataGraphs.vertex_data(graph::TensorNetwork, args...) =
    vertex_data(data_graph(graph), args...)
DataGraphs.edge_data(graph::TensorNetwork, args...) = edge_data(data_graph(graph), args...)

function Base.setindex!(tn::TensorNetwork, t::AbstractIndexedArray, v::Int)
    tn.data_graph[v] = t
end

Base.getindex(tn::TensorNetwork, v::Int) = tn.data_graph[v]

"""
Return if a tensor network `tn` has a cycle. If it has not a cycle, `tn` is a tree tensor network.
"""
Graphs.is_cyclic(tn::TensorNetwork) =
    Graphs.is_cyclic(tn.data_graph.underlying_graph.position_graph)


Graphs.has_edge(tn::TensorNetwork, e::NamedEdge) = Graphs.has_edge(tn.data_graph, e)

"""
Contract all the tensors in a tensor network `tn` and return the result.

This function works only for tree tensor networks, i.e., `is_cyclic(tn) == false`.

root_vertex: The vertex to start the contraction. The default is 1.
"""
function complete_contraction(tn::TensorNetwork; root_vertex::Int = 1)
    !Graphs.is_cyclic(tn) ||
        error("complete_contraction is not supported only for a tree tensor network.")
    res = tn[root_vertex]
    for nv in neighbors(tn.data_graph, root_vertex)
        res = res * _contract_subtree(tn, nv, root_vertex)
    end
    return res
end

"""
Contract all the tensors in a subtree of a tensor network `tn` and return the result.

The subtree is defined by a vertex `v` and its parent vertex `parent_v`.
Note that `parent_v` is not included in the subtree.
"""
function _contract_subtree(tn::TensorNetwork, v::Int, parent_v::Union{Int,Nothing})
    res = tn[v]
    for nv in neighbors(tn.data_graph, v)
        if nv != parent_v
            res = contract(res, _contract_subtree(tn, nv, v))
        end
    end
    return res
end

module SimpleTensorNetworks

import DataGraphs as DG
using DataGraphs: DataGraphs, DataGraph
using NamedGraphs: NamedGraphs, NamedEdge, NamedGraph, vertextype, vertices

include("index.jl")
include("indexedarray.jl")
include("contraction.jl")
include("simpletensornetwork.jl")

end

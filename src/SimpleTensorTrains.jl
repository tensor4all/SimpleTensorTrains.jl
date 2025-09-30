module SimpleTensorTrains

import ITensors: ITensors, ITensor, Index, dim, uniqueinds
import ITensorMPS
import ITensors: Algorithm, @Algorithm_str
import LinearAlgebra

include("defaults.jl")
include("tensortrain.jl")
include("contraction.jl")

end

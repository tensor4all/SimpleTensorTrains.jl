module SimpleTensorTrains

import ITensors: ITensors, ITensor, Index, dim, uniqueinds
import ITensorMPS
import ITensors: Algorithm, @Algorithm_str
import LinearAlgebra

# Export public API
export SimpleTensorTrain
export contract
export truncate, truncate!
export maxlinkdim, siteinds
export default_maxdim, default_cutoff, default_nsweeps


include("defaults.jl")
include("tensortrain.jl")
include("contraction.jl")

end

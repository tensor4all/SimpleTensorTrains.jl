module ContractionImpl
using ITensors
using ITensorMPS
import ITensors
import ITensorMPS

import ITensors: Algorithm, @Algorithm_str
import ITensorMPS: setleftlim!, setrightlim!
import LinearAlgebra
include("contraction/fitalgorithm.jl")
include("contraction/densitymatrix.jl")
end

function contract(M1::SimpleTensorTrain, M2::SimpleTensorTrain; alg=Algorithm"fit"(), cutoff::Real=default_cutoff(), maxdim::Int=default_maxdim(), nsweeps::Int=default_nsweeps(), kwargs...)::SimpleTensorTrain
    M1_ = ITensorMPS.MPO(M1)
    M2_ = ITensorMPS.MPO(M2)
    alg = Algorithm(alg)
    if alg == Algorithm"densitymatrix"()
        return SimpleTensorTrain(ContractionImpl.contract_densitymatrix(M1_, M2_; cutoff, maxdim, kwargs...))
    elseif alg == Algorithm"fit"()
        return SimpleTensorTrain(ContractionImpl.contract_fit(M1_, M2_; cutoff, maxdim, nsweeps, kwargs...))
    elseif alg == Algorithm"zipup"()
        return SimpleTensorTrain(ITensorMPS.contract(M1_, M2_; alg=Algorithm"zipup"(), cutoff, maxdim, kwargs...))
    elseif alg == Algorithm"naive"()
        return SimpleTensorTrain(ITensorMPS.contract(M1_, M2_; alg=Algorithm"naive"(), cutoff, maxdim, kwargs...))
    else
        error("Unknown algorithm: $alg")
    end
end
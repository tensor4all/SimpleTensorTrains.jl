"""
SimpleTensorTrain - A simple tensor train data structure

This struct represents a tensor train (matrix product state/operator) as a vector
of ITensors with left and right boundary indices.
This struct is designed to be compatible with ITensorMPS.MPS and ITensorMPS.MPO.

# Fields
- `data::Vector{ITensor}`: Vector of tensors in the tensor train
- `llim::Int`: Left boundary index
- `rlim::Int`: Right boundary index

# Conversion Functions
This struct supports conversion to/from ITensorMPS types:
- `MPS(stt::SimpleTensorTrain)` - Convert to Matrix Product State
- `MPO(stt::SimpleTensorTrain)` - Convert to Matrix Product Operator  
- `SimpleTensorTrain(mps::MPS)` - Convert from Matrix Product State
- `SimpleTensorTrain(mpo::MPO)` - Convert from Matrix Product Operator
"""
mutable struct SimpleTensorTrain
    data::Vector{ITensor}
    llim::Int
    rlim::Int
end

"""
    SimpleTensorTrain(data::Vector{ITensor})

Construct a SimpleTensorTrain from a vector of ITensors.

The left and right limits are automatically set to 0 and length(data) + 1 respectively.

# Arguments
- `data::Vector{ITensor}`: Vector of tensors forming the tensor train

# Returns
- `SimpleTensorTrain`: A new SimpleTensorTrain object with default limits
"""
function SimpleTensorTrain(data::Vector{ITensor})
    return SimpleTensorTrain(data, 0, length(data) + 1)
end

# Iterator implementation
Base.iterate(stt::SimpleTensorTrain) = iterate(stt.data)
Base.iterate(stt::SimpleTensorTrain, state) = iterate(stt.data, state)
Base.length(stt::SimpleTensorTrain) = length(stt.data)
Base.size(stt::SimpleTensorTrain) = size(stt.data)
Base.getindex(stt::SimpleTensorTrain, i) = stt.data[i]
Base.setindex!(stt::SimpleTensorTrain, value, i) = (stt.data[i] = value)
Base.firstindex(stt::SimpleTensorTrain) = 1
Base.lastindex(stt::SimpleTensorTrain) = length(stt.data)
Base.eachindex(stt::SimpleTensorTrain) = eachindex(stt.data)

"""
Convert SimpleTensorTrain to ITensorMPS.MPS

This function takes a SimpleTensorTrain and converts it to an ITensorMPS.MPS.
The conversion preserves the tensor structure and indices.
"""
function ITensorMPS.MPS(stt::SimpleTensorTrain)
    return ITensorMPS.MPS(stt.data)
end

"""
Convert ITensorMPS.MPS to SimpleTensorTrain

This function takes an ITensorMPS.MPS and converts it to a SimpleTensorTrain.
The conversion preserves the tensor structure and indices.
"""
function SimpleTensorTrain(mps::ITensorMPS.MPS)
    # Extract the tensor data from the MPS
    data = Vector{ITensor}(undef, length(mps))
    for i in 1:length(mps)
        data[i] = mps[i]
    end
    return SimpleTensorTrain(data, 0, length(data) + 1)
end

"""
Convert ITensorMPS.MPS to SimpleTensorTrain with explicit left and right limits

This function allows specifying the left and right limits explicitly.
"""
function SimpleTensorTrain(mps::ITensorMPS.MPS, llim::Int, rlim::Int)
    # Extract the tensor data from the MPS
    data = Vector{ITensor}(undef, length(mps))
    for i in 1:length(mps)
        data[i] = mps[i]
    end
    return SimpleTensorTrain(data, llim, rlim)
end

"""
Convert SimpleTensorTrain to ITensorMPS.MPO

This function takes a SimpleTensorTrain and converts it to an ITensorMPS.MPO.
The conversion preserves the tensor structure and indices.
"""
function ITensorMPS.MPO(stt::SimpleTensorTrain)
    return ITensorMPS.MPO(stt.data)
end

"""
Convert ITensorMPS.MPO to SimpleTensorTrain

This function takes an ITensorMPS.MPO and converts it to a SimpleTensorTrain.
The conversion preserves the tensor structure and indices.
"""
function SimpleTensorTrain(mpo::ITensorMPS.MPO)
    # Extract the tensor data from the MPO
    data = Vector{ITensor}(undef, length(mpo))
    for i in 1:length(mpo)
        data[i] = mpo[i]
    end
    return SimpleTensorTrain(data, 0, length(data) + 1)
end

"""
Convert ITensorMPS.MPO to SimpleTensorTrain with explicit left and right limits

This function allows specifying the left and right limits explicitly.
"""
function SimpleTensorTrain(mpo::ITensorMPS.MPO, llim::Int, rlim::Int)
    # Extract the tensor data from the MPO
    data = Vector{ITensor}(undef, length(mpo))
    for i in 1:length(mpo)
        data[i] = mpo[i]
    end
    return SimpleTensorTrain(data, llim, rlim)
end

"""
Add two SimpleTensorTrain objects using ITensors.Algorithm("directsum")

This function computes the sum of two tensor trains by:
1. Converting both SimpleTensorTrain objects to ITensorMPS.MPS
2. Computing the sum using ITensors.Algorithm("directsum") for high precision
3. Converting the result back to SimpleTensorTrain

The result preserves the tensor structure while combining the bond dimensions.
Uses Algorithm("directsum") instead of default + operator for better numerical precision.
"""
function Base.:+(stt1::SimpleTensorTrain, stt2::SimpleTensorTrain)
    # Check that both tensor trains have the same length
    if length(stt1.data) != length(stt2.data)
        throw(ArgumentError("Tensor trains must have the same length for addition. Got lengths $(length(stt1.data)) and $(length(stt2.data))"))
    end
    
    # Convert to MPS
    mps1 = ITensorMPS.MPS(stt1)
    mps2 = ITensorMPS.MPS(stt2)
    
    # Compute sum using ITensors.Algorithm("directsum") for better precision
    alg = Algorithm"directsum"()
    mps_sum = +(alg, mps1, mps2)
    
    # Convert back to SimpleTensorTrain
    # Use the left and right limits from the first tensor train
    return SimpleTensorTrain(mps_sum, stt1.llim, stt1.rlim)
end

"""
Add multiple SimpleTensorTrain objects using ITensors.Algorithm("directsum")

This function computes the sum of multiple tensor trains by:
1. Converting all SimpleTensorTrain objects to ITensorMPS.MPS
2. Computing the sum using ITensors.Algorithm("directsum") for high precision
3. Converting the result back to SimpleTensorTrain

The result preserves the tensor structure while combining all bond dimensions.
Uses Algorithm("directsum") instead of default + operator for better numerical precision.
"""
function Base.:+(stt1::SimpleTensorTrain, stt2::SimpleTensorTrain, stts...)
    # Check that all tensor trains have the same length
    lengths = [length(stt.data) for stt in [stt1, stt2, stts...]]
    if !all(l -> l == lengths[1], lengths)
        throw(ArgumentError("All tensor trains must have the same length for addition. Got lengths: $(lengths)"))
    end
    
    # Convert all to MPS
    mps_list = [ITensorMPS.MPS(stt) for stt in [stt1, stt2, stts...]]
    
    # Compute sum of all MPS using ITensors.Algorithm("directsum") for better precision
    alg = Algorithm"directsum"()
    mps_sum = +(alg, mps_list...)
    
    # Convert back to SimpleTensorTrain
    # Use the left and right limits from the first tensor train
    return SimpleTensorTrain(mps_sum, stt1.llim, stt1.rlim)
end

"""
Scalar multiplication for SimpleTensorTrain

This function multiplies a SimpleTensorTrain by a scalar value by delegating to ITensorMPS.
"""
function Base.:*(α::Number, stt::SimpleTensorTrain)
    # Convert to MPS and delegate to ITensorMPS
    mps = ITensorMPS.MPS(stt)
    scaled_mps = α * mps
    
    # Convert back to SimpleTensorTrain
    return SimpleTensorTrain(scaled_mps, stt.llim, stt.rlim)
end

"""
Scalar multiplication for SimpleTensorTrain (right multiplication)

This function multiplies a SimpleTensorTrain by a scalar value by delegating to ITensorMPS.
"""
function Base.:*(stt::SimpleTensorTrain, α::Number)
    return α * stt
end

"""
    dist(stt1::SimpleTensorTrain, stt2::SimpleTensorTrain)

Compute the Euclidean distance between two SimpleTensorTrain objects.

This function delegates to ITensorMPS.dist for efficient computation using:
`sqrt(abs(inner(A, A) + inner(B, B) - 2 * real(inner(A, B))))`.

Note that if the tensor trains are not normalized, the normalizations may diverge and
this may not be accurate. For those cases, it is best to use `norm(stt1 - stt2)` directly.
"""
function dist(stt1::SimpleTensorTrain, stt2::SimpleTensorTrain)
    # Check that both tensor trains have the same length
    if length(stt1.data) != length(stt2.data)
        throw(ArgumentError("Tensor trains must have the same length for distance computation. Got lengths $(length(stt1.data)) and $(length(stt2.data))"))
    end
    
    # Convert to MPS and delegate to ITensorMPS.dist
    mps1 = ITensorMPS.MPS(stt1)
    mps2 = ITensorMPS.MPS(stt2)
    
    return ITensorMPS.dist(mps1, mps2)
end

"""
    norm(stt::SimpleTensorTrain)

Compute the norm (2-norm) of a SimpleTensorTrain object.

This function delegates to ITensorMPS.norm for efficient computation.
The norm is computed as the square root of the inner product with itself.
"""
function LinearAlgebra.norm(stt::SimpleTensorTrain)
    # Convert to MPS and delegate to ITensorMPS.norm
    mps = ITensorMPS.MPS(stt)
    
    return ITensorMPS.norm(mps)
end

"""
    lognorm(stt::SimpleTensorTrain)

Compute the log norm of a SimpleTensorTrain object.

This function delegates to ITensorMPS.lognorm for efficient computation.
The log norm is useful when the norm may be very large to avoid overflow.
"""
function ITensorMPS.lognorm(stt::SimpleTensorTrain)
    # Convert to MPS and delegate to ITensorMPS.lognorm
    mps = ITensorMPS.MPS(stt)
    
    return ITensorMPS.lognorm(mps)
end

"""
Subtract two SimpleTensorTrain objects using ITensors.Algorithm("directsum")

This function computes the difference of two tensor trains by:
1. Converting both SimpleTensorTrain objects to ITensorMPS.MPS
2. Computing the difference using ITensors.Algorithm("directsum") for high precision
3. Converting the result back to SimpleTensorTrain

The result preserves the tensor structure while combining the bond dimensions.
Uses Algorithm("directsum") for optimal numerical precision.
"""
function Base.:-(stt1::SimpleTensorTrain, stt2::SimpleTensorTrain)
    # Check that both tensor trains have the same length
    if length(stt1.data) != length(stt2.data)
        throw(ArgumentError("Tensor trains must have the same length for subtraction. Got lengths $(length(stt1.data)) and $(length(stt2.data))"))
    end
    
    # Convert to MPS
    mps1 = ITensorMPS.MPS(stt1)
    mps2 = ITensorMPS.MPS(stt2)
    
    # Compute difference using ITensors.Algorithm("directsum") for better precision
    # Subtraction: stt1 - stt2 = stt1 + (-1) * stt2
    alg = Algorithm"directsum"()
    mps_diff = +(alg, mps1, -1 * mps2)
    
    # Convert back to SimpleTensorTrain
    # Use the left and right limits from the first tensor train
    return SimpleTensorTrain(mps_diff, stt1.llim, stt1.rlim)
end

"""
Subtract multiple SimpleTensorTrain objects using ITensors.Algorithm("directsum")

This function computes the difference of multiple tensor trains by:
1. Converting all SimpleTensorTrain objects to ITensorMPS.MPS
2. Computing the difference using ITensors.Algorithm("directsum") for high precision
3. Converting the result back to SimpleTensorTrain

The result preserves the tensor structure while combining all bond dimensions.
Uses Algorithm("directsum") for optimal numerical precision.
"""
function Base.:-(stt1::SimpleTensorTrain, stt2::SimpleTensorTrain, stts...)
    # Check that all tensor trains have the same length
    lengths = [length(stt.data) for stt in [stt1, stt2, stts...]]
    if !all(l -> l == lengths[1], lengths)
        throw(ArgumentError("All tensor trains must have the same length for subtraction. Got lengths: $(lengths)"))
    end
    
    # Convert all to MPS
    mps_list = [ITensorMPS.MPS(stt) for stt in [stt1, stt2, stts...]]
    
    # Compute difference using ITensors.Algorithm("directsum") for better precision
    # Subtraction: stt1 - stt2 - stt3 - ... = stt1 + (-1)*stt2 + (-1)*stt3 + ...
    scaled_mps_list = [mps_list[1]]  # First term is positive
    for i in 2:length(mps_list)
        push!(scaled_mps_list, -1 * mps_list[i])  # Remaining terms are negative
    end
    
    alg = Algorithm"directsum"()
    mps_diff = +(alg, scaled_mps_list...)
    
    # Convert back to SimpleTensorTrain
    # Use the left and right limits from the first tensor train
    return SimpleTensorTrain(mps_diff, stt1.llim, stt1.rlim)
end

"""
Add SimpleTensorTrain objects using ITensors.Algorithm("directsum")

This function computes the sum of tensor trains using ITensors.Algorithm("directsum") for high precision.
Note: Algorithm parameter is accepted for interface compatibility but Algorithm("directsum") is always used
for optimal numerical precision.
"""
function Base.:+(alg::Algorithm, stt1::SimpleTensorTrain, stts...)
    # Check that all tensor trains have the same length
    lengths = [length(stt.data) for stt in [stt1, stts...]]
    if !all(l -> l == lengths[1], lengths)
        throw(ArgumentError("All tensor trains must have the same length for addition. Got lengths: $(lengths)"))
    end
    
    # Convert all to MPS
    mps_list = [ITensorMPS.MPS(stt) for stt in [stt1, stts...]]
    
    # Compute sum using ITensors.Algorithm("directsum") for better precision
    # Note: Algorithm parameter is ignored, directsum algorithm is always used
    alg = Algorithm"directsum"()
    mps_sum = +(alg, mps_list...)
    
    # Convert back to SimpleTensorTrain
    # Use the left and right limits from the first tensor train
    return SimpleTensorTrain(mps_sum, stt1.llim, stt1.rlim)
end


"""
    truncate!(stt::SimpleTensorTrain; cutoff::Real=default_cutoff(), maxdim::Int=default_maxdim(), kwargs...)

Truncate a SimpleTensorTrain in-place by removing small singular values.

This function modifies the SimpleTensorTrain in-place by converting to MPS,
applying ITensorMPS.truncate!, and updating the tensor data.

# Arguments
- `stt::SimpleTensorTrain`: The tensor train to truncate (modified in-place)

# Keyword Arguments
- `cutoff::Real`: Cutoff threshold for singular values (default: `default_cutoff()`)
- `maxdim::Int`: Maximum bond dimension (default: `default_maxdim()`)
- `kwargs...`: Additional keyword arguments passed to ITensorMPS.truncate!

# Returns
- `SimpleTensorTrain`: The modified tensor train (same object as input)
"""
function truncate!(stt::SimpleTensorTrain; cutoff::Real=default_cutoff(), maxdim::Int=default_maxdim(), kwargs...)::SimpleTensorTrain
    mps = ITensorMPS.MPS(stt)
    ITensorMPS.truncate!(mps; cutoff=cutoff, maxdim=maxdim, kwargs...)
    # Update in place
    for i in 1:length(stt)
        stt[i] = mps[i]
    end
    return stt
end

"""
    truncate(stt::SimpleTensorTrain; cutoff::Real=default_cutoff(), maxdim::Int=default_maxdim(), kwargs...)

Truncate a SimpleTensorTrain by removing small singular values, returning a new object.

This function creates a new SimpleTensorTrain by converting to MPS,
applying ITensorMPS.truncate!, and creating a new SimpleTensorTrain from the result.

# Arguments
- `stt::SimpleTensorTrain`: The tensor train to truncate

# Keyword Arguments
- `cutoff::Real`: Cutoff threshold for singular values (default: `default_cutoff()`)
- `maxdim::Int`: Maximum bond dimension (default: `default_maxdim()`)
- `kwargs...`: Additional keyword arguments passed to ITensorMPS.truncate!

# Returns
- `SimpleTensorTrain`: A new truncated tensor train
"""
function truncate(stt::SimpleTensorTrain; cutoff::Real=default_cutoff(), maxdim::Int=default_maxdim(), kwargs...)::SimpleTensorTrain
    mps = ITensorMPS.MPS(stt)
    ITensorMPS.truncate!(mps; cutoff=cutoff, maxdim=maxdim, kwargs...)
    return SimpleTensorTrain(mps)
end

"""
    maxlinkdim(stt::SimpleTensorTrain)

Get the maximum link (bond) dimension in a SimpleTensorTrain.

This function computes the maximum dimension of the bond indices
connecting adjacent tensors in the tensor train.

# Arguments
- `stt::SimpleTensorTrain`: The tensor train to analyze

# Returns
- `Int`: Maximum bond dimension
"""
function maxlinkdim(stt::SimpleTensorTrain)
    return ITensorMPS.maxlinkdim(ITensorMPS.MPO(stt))
end

function _extractsite(x::SimpleTensorTrain, n::Int)::Vector{Index}
    if n == 1
        return copy(uniqueinds(x[n], x[n + 1]))
    elseif n == length(x)
        return copy(uniqueinds(x[n], x[n - 1]))
    else
        return copy(uniqueinds(x[n], x[n + 1], x[n - 1]))
    end
end

"""
    siteinds(x::SimpleTensorTrain)

Extract the site indices from each tensor in a SimpleTensorTrain.

This function returns a vector of index vectors, where each element contains
the site (physical) indices for the corresponding tensor in the train.

# Arguments
- `x::SimpleTensorTrain`: The tensor train to extract site indices from

# Returns
- `Vector{Vector{Index}}`: Vector of site index vectors, one per tensor
"""
siteinds(x::SimpleTensorTrain) = [_extractsite(x, n) for n in eachindex(x)]
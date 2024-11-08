abstract type AbstractIndexedArray{T} end

"""
Simple Array with indices
"""
mutable struct IndexedArray{T} <: AbstractIndexedArray{T}
    data::Array{T} # Type unstable
    indices::Vector{AbstractIndex}

    function IndexedArray(data::Array{T}, indices) where {T}
        if length(data) != prod(dim.(indices))
            throw(
                ArgumentError(
                    "Length of data does not match the product of dimensions of indices",
                ),
            )
        end
        if size(data) != tuple(map(dim, indices)...)
            throw(ArgumentError("Shape of data does not match the dimensions of indices"))
        end
        new{T}(data, indices)
    end
end

"""
Get the size of an IndexedArray
"""
Base.size(A::IndexedArray) = size(A.data)

"""
Get the length of an IndexedArray
"""
Base.length(A::IndexedArray) = length(A.data)

"""
Get the indices of an IndexedArray
"""
indices(A::IndexedArray) = A.indices

"""
Get the underlying data of an IndexedArray
"""
data(A::IndexedArray) = A.data

"""
Permute the indices of an IndexedArray

indices: The new indices (list, tuple, etc.)
"""
function permute(A::IndexedArray, inds)
    perm = [findfirst(==(i), indices(A)) for i in inds]
    IndexedArray(permutedims(data(A), perm), inds)
end


Base.isapprox(A::IndexedArray, B::IndexedArray; kwargs...) =
    isapprox(data(A), data(B); kwargs...)

Base.permutedims(A::IndexedArray, perm::AbstractVector{Int}) =
    IndexedArray(permutedims(data(A), perm), [indices(A)[i] for i in perm])

function Base.only(tn::IndexedArray{T})::T where {T}
    if length(tn.data) != 1
        error("IndexedArray has more than one element")
    end
    return tn.data[1]
end

"""
Return if two IndexedArrays have common indices
"""
hascommondindices(A::IndexedArray, B::IndexedArray) =
    !isempty(intersect(indices(A), indices(B)))

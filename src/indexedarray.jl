abstract type AbstractIndexedArray{T,IndT<:AbstractIndex} end

"""
Simple Array with indices
"""
mutable struct IndexedArray{T,IndT<:AbstractIndex} <: AbstractIndexedArray{T,IndT}
    data::Array{T} # Type unstable
    indices::Vector{IndT}

    function IndexedArray(
        data::Array{T},
        indices::Vector{IndT},
    ) where {T,IndT<:AbstractIndex}
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
        new{T,IndT}(data, indices)
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

Base.isapprox(A::IndexedArray, B::IndexedArray; kwargs...) =
    isapprox(data(A), data(B); kwargs...)

Base.permutedims(A::IndexedArray, perm::AbstractVector{Int}) =
    IndexedArray(permutedims(data(A), perm), [indices(A)[i] for i in perm])

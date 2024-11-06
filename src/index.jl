# Abstract type for index
abstract type AbstractIndex end

"""
Simple index type

Indices with the same name and the same dimension are considered to be the same index.
"""
struct Index <: AbstractIndex
    dim::Int
    name::String
end

dim(index::Index) = index.dim

"""
Returns if a given vector/set of indices contains only unique indices
"""
function isunique(
    indices::Union{AbstractVector{IndT},Set{IndT}},
) where {IndT<:AbstractIndex}
    return length(indices) == length(Set(indices))
end

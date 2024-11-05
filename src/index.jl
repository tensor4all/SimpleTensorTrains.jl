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

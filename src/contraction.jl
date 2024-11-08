"""
Contract two IndexedArrays over the shared indices.
"""
function contract(
    a::IndexedArray{T1},
    b::IndexedArray{T2},
)::IndexedArray{promote_type(T1, T2)} where {T1,T2}

    commonindices = intersect(indices(a), indices(b))
    idx_a = ntuple(
        i -> findfirst(x -> x == commonindices[i], indices(a)),
        length(commonindices),
    )
    idx_b = ntuple(
        i -> findfirst(x -> x == commonindices[i], indices(b)),
        length(commonindices),
    )

    data_ab = _contract(a.data, b.data, idx_a, idx_b)
    return IndexedArray(data_ab, setdiff(vcat(indices(a), indices(b)), commonindices))
end


_getindex(x, indices) = ntuple(i -> x[indices[i]], length(indices))

function Base.:*(
    a::IndexedArray{T1},
    b::IndexedArray{T2},
)::IndexedArray{promote_type(T1, T2)} where {T1,T2}
    return contract(a, b)
end


function _contract(
    a::AbstractArray{T1,N1},
    b::AbstractArray{T2,N2},
    idx_a::NTuple{n1,Int},
    idx_b::NTuple{n2,Int},
) where {T1,T2,N1,N2,n1,n2}
    length(idx_a) == length(idx_b) || error("length(idx_a) != length(idx_b)")
    # check if idx_a contains only unique elements
    length(unique(idx_a)) == length(idx_a) || error("idx_a contains duplicate elements")
    # check if idx_b contains only unique elements
    length(unique(idx_b)) == length(idx_b) || error("idx_b contains duplicate elements")
    # check if idx_a and idx_b are subsets of 1:N1 and 1:N2
    all(1 <= idx <= N1 for idx in idx_a) || error("idx_a contains elements out of range")
    all(1 <= idx <= N2 for idx in idx_b) || error("idx_b contains elements out of range")

    rest_idx_a = setdiff(1:N1, idx_a)
    rest_idx_b = setdiff(1:N2, idx_b)

    amat = reshape(
        permutedims(a, (rest_idx_a..., idx_a...)),
        prod(_getindex(size(a), rest_idx_a)),
        prod(_getindex(size(a), idx_a)),
    )
    bmat = reshape(
        permutedims(b, (idx_b..., rest_idx_b...)),
        prod(_getindex(size(b), idx_b)),
        prod(_getindex(size(b), rest_idx_b)),
    )

    return reshape(
        amat * bmat,
        _getindex(size(a), rest_idx_a)...,
        _getindex(size(b), rest_idx_b)...,
    )
end

"""
    default_maxdim()

Return the default maximum bond dimension for tensor train operations.

The default is `typemax(Int)`, which effectively means no limit on bond dimension.

# Returns
- `Int`: The default maximum bond dimension
"""
default_maxdim() = typemax(Int)

"""
    default_cutoff()

Return the default cutoff threshold for truncating small singular values.

The default is `1e-30`, which is a very small threshold suitable for high-precision calculations.

# Returns
- `Float64`: The default cutoff value
"""
default_cutoff() = 1e-30

"""
    default_nsweeps()

Return the default number of sweeps for variational fitting algorithms.

The default is `1`, which performs a single sweep.

# Returns
- `Int`: The default number of sweeps
"""
default_nsweeps() = 1
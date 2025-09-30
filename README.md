# SimpleTensorTrains.jl

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tensor4all.github.io/SimpleTensorTrains.jl/dev)
[![CI](https://github.com/tensor4all/SimpleTensorTrains.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/tensor4all/SimpleTensorTrains.jl/actions/workflows/CI.yml)

A Julia library providing a simple and safe tensor train (matrix product state/operator) data structure built on top of [ITensors.jl](https://github.com/ITensor/ITensors.jl).

## Features

- **Safe operations**: All operations use algorithms that prevent unexpected loss of precision
  - Addition uses the direct sum algorithm instead of the density matrix algorithm
  - Multiple contraction algorithms available (fit, density matrix, zipup, naive)
- **ITensors.jl compatibility**: Seamless conversion between `SimpleTensorTrain` and ITensors' MPS/MPO
- **Comprehensive API**: Support for truncation, contraction, arithmetic operations, and more

## Installation

```julia
using Pkg
Pkg.add("SimpleTensorTrains")
```

## Quick Start

```julia
using SimpleTensorTrains
using ITensors, ITensorMPS

# Create a SimpleTensorTrain from an MPS
mps = randomMPS(siteinds("S=1/2", 10))
stt = SimpleTensorTrain(mps)

# Perform operations
stt_sum = stt + stt  # Addition using direct sum
stt_scaled = 2.0 * stt  # Scalar multiplication

# Contract two tensor trains
result = contract(stt, stt; alg=Algorithm"fit"(), maxdim=100)

# Truncate
truncated = truncate(stt; cutoff=1e-10, maxdim=50)

# Get information
bond_dim = maxlinkdim(stt)
sites = siteinds(stt)
```

## Key Design Choices

This library makes specific algorithmic choices to ensure numerical accuracy, especially important for operations with quantics tensor trains:

- **Addition**: Uses `Algorithm"directsum"` for exact representation without approximation
- **Subtraction**: Uses `Algorithm"directsum"` for optimal numerical precision
- **Contraction**: Offers multiple algorithms (fit, densitymatrix, zipup, naive) with sensible defaults

## Documentation

For detailed API documentation, see the [documentation](https://tensor4all.github.io/SimpleTensorTrains.jl/dev).

## Acknowledgments

This library is built on top of [ITensors.jl](https://github.com/ITensor/ITensors.jl) and [ITensorMPS.jl](https://github.com/ITensor/ITensorMPS.jl).

**Please cite [the ITensor paper](https://itensor.org/citing/) when using this library.**

Some code in `src/contraction/` is derived from:
- **ITensors.jl** (Apache License 2.0) - density matrix contraction algorithm
- **ITensorTDVP.jl** (Apache License 2.0) - variational fitting algorithm

See the [LICENSE](LICENSE) and [NOTICE](NOTICE) files for full attribution and license information.

## License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

The use of the same Apache 2.0 license as the upstream ITensors.jl and ITensorTDVP.jl projects ensures full compatibility and simplifies attribution.
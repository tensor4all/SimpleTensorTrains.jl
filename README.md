# SimpleTensorNetworks

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tensor4all.github.io/SimpleTensorNetworks.jl/dev)
[![CI](https://github.com/tensor4all/SimpleTensorNetworks.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/tensor4all/SimpleTensorNetworks.jl/actions/workflows/CI.yml)

This library implements a minimal subset of tensor network functionality required for `TensorCrossInterpolation.jl`. The development draws significant inspiration from `ITensorNetworks.jl`.

Feature list:

- Similar functionality to `ITensors.Index` and `ITensors.ITensor` without type instability
- Contraction operations for two tensor objects
- Tree tensor network structure based on `DataGraphs.jl`

Remarks:

- Maintain type stability wherever possible to support future static compilation with `juliac`.
- Feedback to `ITensorNetworks.jl` is encouraged. For instance, `DataGraphs.jl` lacks sufficient documentation, and contributing to its documentation could be beneficial.
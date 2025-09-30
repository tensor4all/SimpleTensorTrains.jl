```@meta
CurrentModule = SimpleTensorTrains
```

# SimpleTensorTrains

This is the documentation for [SimpleTensorTrains](https://github.com/tensor4all/SimpleTensorTrains.jl).

A simple tensor train (matrix product state/operator) data structure and algorithms built on top of ITensors.jl.

# API Reference

## Tensor Train Type

```@docs
SimpleTensorTrain
SimpleTensorTrain(::Vector{ITensor})
SimpleTensorTrain(::ITensorMPS.MPS)
SimpleTensorTrain(::ITensorMPS.MPS, ::Int, ::Int)
SimpleTensorTrain(::ITensorMPS.MPO)
SimpleTensorTrain(::ITensorMPS.MPO, ::Int, ::Int)
```

## Tensor Train Operations

```@docs
contract
truncate
truncate!
maxlinkdim
siteinds
```

## Default Parameters

```@docs
default_maxdim
default_cutoff
default_nsweeps
```
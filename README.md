# SimpleTensorNetworks

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tensor4all.github.io/SimpleTensorNetworks.jl/dev)
[![CI](https://github.com/tensor4all/SimpleTensorNetworks.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/tensor4all/SimpleTensorNetworks.jl/actions/workflows/CI.yml)


This library provides *a wrapper for the ITensors libraries* to allow for safe operations on tensor trains.
Every operation is performed with a safe algorithm, preventing unexpected loss of precision.
For instance, we do not use the density matrix algorithm for addition of tensor trains, and use the direct sum algorithm instead.
Such safe choices are crucial for the accuracy of the results especially for operations with quatics tensor trains.

*Please cite [the ITensor paper](https://itensor.org/citing/) when using this library.*
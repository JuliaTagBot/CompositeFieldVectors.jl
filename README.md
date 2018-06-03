# CompositeFieldVectors

[![Build Status](https://travis-ci.org/rafaqz/CompositeFieldVectors.jl.svg?branch=master)](https://travis-ci.org/rafaqz/CompositeFieldVectors.jl)
[![Coverage Status](https://coveralls.io/repos/rafaqz/CompositeFieldVectors.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/rafaqz/CompositeFieldVectors.jl?branch=master)
[![codecov.io](http://codecov.io/github/rafaqz/CompositeFieldVectors.jl/coverage.svg?branch=master)](http://codecov.io/github/rafaqz/CompositeFieldVectors.jl?branch=master)

This package builds on the idea of field vectors from the StaticArrays package -
but doesn't actually depend on StaticArrays (or anything actually).

Composite field vectors are nested structs that also have an array
representation, where all values are listed linearly.

This can be useful for using composition patterns for modular parameter
structures, when you still need the results available in array representations,
such as parameter estimation and sensitivity analysis.

Its not totally type stable yet, and it's not clear that it can be.

To define a CompositeFieldVector, just define any regular struct or mutable
struct and inherit from CompositeFieldVector.

```juliareple
mutable struct SubParams{T}
    p2::T
    p3::T
end

mutable struct Params{L,N,T,S} <: CompositeFieldVector{L,N,T}
    p1::T
    sub::S
end

julia> subparams = SubParams(2.0, 3.0)
SubParams{Float64}(2.0, 3.0)

julia> params = Params(1.0, subparams)
3-element Params{((1,), (2, 1), (2, 2)),3,Float64,SubParams{Float64}}:
 1.0
 2.0
 3.0

julia> params[2]
2.0
```

As you can see in the output of Params(), the field lookup is stored in the type
system. This means that no extra fields are required on a struct to make it a
CompositeFieldVectors.

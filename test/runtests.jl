using Revise
using ParameterComposition

@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

mutable struct SubParams
    p3::Float64 # 2
    p4::Float64 # 3
end

mutable struct Params{N,T,L} <: CompositeFieldVector{N,T,L}
    p1::T          # 1
    sub::SubParams # 2, 3
    p2::T          # 4
end

subparams = SubParams(2.0, 3.0)
params = Params{4,Float64,((1,),(2,1),(2,2),(3,))}(1.0, subparams, 4.0)

@test params[1] == 1.0
@test params[2] == 2.0
@test params[3] == 3.0
@test params[4] == 4.0

@test length(params) == 4
@test size(params) == (4,)
params[1] = 11.0
@test params[1] == 11.0
setindex!(params, 33.0, 3)
@code_warntype setindex!(params, 33.0, 3)
@code_warntype getindex(params, 3)
@test params[3] == 33.0

using CompositeFieldVectors
using CompositeFieldVectors: buildlookup

@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

mutable struct SubSubParams{T}
    p4::T # 4
    p5::T # 5
end

mutable struct SubParams{T,S}
    p2::T # 2
    p3::T # 3
    subsub::S
end

mutable struct Params{L,N,T,S} <: CompositeFieldVector{L,N,T}
    p1::T  # 1
    sub::S # 2, 3, 4, 5
    p2::T  # 6
end

subsubparams = SubSubParams(4.0, 5.0)
subparams = SubParams(2.0, 3.0, subsubparams)
params = Params(1.0, subparams, 6.0)

@testset "setup" begin
    @test buildlookup(tuple(), 1, 1) == (tuple())
    @test buildlookup((1.0,), 1) == ((1,),)
    @test buildlookup((1.0, 2.0), 1) == ((1,), (2,))
    @test buildlookup((subsubparams,), 1) == ((1,1), (1,2))
    @test buildlookup((subsubparams, 1.5), 1, 3) == ((3,1,1), (3,1,2), (3,2))
    @test buildlookup((subparams, 2.0), 1) == ((1,1), (1,2), (1,3,1), (1,3,2), (2,))
end

@testset "array methods" begin
    @test params[1] === 1.0
    @test params[2] === 2.0
    @test params[3] === 3.0
    @test params[4] === 4.0
    @test params[[1,2,4]] == [1.0,2.0,4.0]
    @test params[:] == [1.0,2.0,3.0,4.0,5.0,6.0]
    @test vec(params) == [1.0,2.0,3.0,4.0,5.0,6.0]
    @test length(params) === 6
    @test size(params) === (6,)
    params[1] = 11.0
    @test params[1] === 11.0
    setindex!(params, 33.0, 3)
    @test params[3] === 33.0
end

# @code_warntype setindex!(params, 33.0, 3)
# @code_warntype getindex(params, 4)
# @code_warntype params[[1,2,4]] == [1.0,2.0,4.0]
# @code_warntype params[:] == [1.0,2.0,3.0,4.0]

# @code_lowered setindex!(params, 33.0, 3)
# @code_lowered getindex(params, 4)
# @code_lowered params[[1,2,4]] == [1.0,2.0,4.0]
# @code_lowered params[:] == [1.0,2.0,3.0,4.0]

# @code_llvm setindex!(params, 33.0, 3)
# @code_llvm getindex(params, 4)
# @code_llvm params[[1,2,4]] == [1.0,2.0,4.0]
# @code_llvm params[:] == [1.0,2.0,3.0,4.0]

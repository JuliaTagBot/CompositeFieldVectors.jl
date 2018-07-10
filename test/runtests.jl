using Revise
using Unitful
using CompositeFieldVectors
# using CompositeFieldVectors: buildlookuplist

import CompositeFieldVectors.flattenable
import CompositeFieldVectors.@reflattenable

@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

mutable struct SubSubParams{T1,T2}
    p4::T1
    p5::T2
end

mutable struct SubParams{T1,T2,S}
    p2::T1
    p3::T2
    subsub::S
end

@flattenable mutable struct Params{T1,S,T2,T3}
    p1::T1 | true  
    sub::S | true
    p6::T2 | true
    p7::T3 | false
end

subsubparams = SubSubParams(4.0, 5.0)
subparams = SubParams(2.0, 3.0, subsubparams)

# @testset "setup" begin
#     @test buildlookuplist(Float64, [], 1) == (tuple())
#     @test buildlookuplist(Float64, [1.0,], 1) == ((1,),)
#     @test buildlookuplist(Float64, [1.0, 2.0], 1) == ((1,), (2,))
#     @test buildlookuplist(Float64, [(1.0, 2.0)], 1) == ((1,1), (1,2),)
#     @test buildlookuplist(Float64, [subsubparams,], 1) == ((1,1), (1,2))
#     @test buildlookuplist(Float64, [subsubparams, 1.5], 1, 3) == ((3,1,1), (3,1,2), (3,2))
#     @test buildlookuplist(Float64, [subparams, 2.0], 1) == ((1,1), (1,2), (1,3,1), (1,3,2), (2,))
# end

# @testset "field names" begin
    # @test compositefieldname(params, 2) === :p2
    # @test compositefieldnames(params) == [:p1,:p2,:p3,:p4,:p5,:p6]
    # @test compositefieldparent(params, 2) === subparams
    # @test compositefieldparents(params) == [params, subparams, subparams, subsubparams, subsubparams, params]
# end params = Params(1.0, subparams, 6.0, :x); 
# @testset "array methods" begin
#     @inferred params[3]
#     @test params[1] === 1.0
#     @test params[2] === 2.0
#     @test params[3] === 3.0
#     @test params[4] === 4.0
#     @test params[end] === 6.0
#     @test params[[1,2,4]] == [1.0,2.0,4.0]
#     @test params[:] == [1.0,2.0,3.0,4.0,5.0,6.0]
#     @test vec(params) == [1.0,2.0,3.0,4.0,5.0,6.0]
#     @test length(params) === 6
#     @test size(params) === (6,)
#     @test sum(params) === 21.0
#     @test prod(params) === 720.0
#     @test reduce(*, 1, params) === 720.0
#     @test map(x->x+1, params) == [2.0,3.0,4.0,5.0,6.0,7.0]
#     @test broadcast(x->x+1, params) == [2.0,3.0,4.0,5.0,6.0,7.0]
#     @test mapreduce(x->x^2, +, params) === 91.0
#     @test maximum(params) === 6.0
#     @test minimum(params) === 1.0
#     @test extrema(params) === (1.0, 6.0)
#     @test mean(params) === 3.5
#     @test deepcopy(params) == params
#     @test deepcopy(params).sub != params.sub
#     @test copy(params) == params
#     @test copy(params).p1 === params.p1
#     @test copy(params).sub === params.sub
#     @test copy(params).p6 === params.p6
#     # @test similar(params) == params
#     params[1] = 11.0
#     @test params[1] === 11.0
#     setindex!(params, 33.0, 3)
#     @test params[3] === 33.0
# end

# mutable struct SubWithInt{T}
#     p2::Int
#     p3::T
# end

# @testset "Mixed types" begin
#     subwithint = SubWithInt(2, 3.0)
#     @test buildlookuplist(Float64, [subwithint], 1) == ((1, 2,),)
#     params = Params(Float64, 1.0, subwithint, 4);
#     @test params[:] == [1.0, 3.0]
# end

# @flattenable mutable struct OptOut{T,L,N,F,S,SS,X} <: CompositeFieldVector{T,L,N}
#     f::F        | false
#     sub::S      | false
#     subsub::SS  | true
#     x::X        | true
# end

# @testset "opt out" begin
#     subsubparams = SubSubParams(4.0, 5.0)
#     subparams = SubParams(2.0, 3.0, subsubparams)
#     oo = OptOut(Float64, 1.7, subparams, subsubparams, 99.0)
#     @test length(oo) == 3
#     @test oo[:] == [4.0, 5.0, 99.0]
#     oo[1] = 666.0
#     @test oo[1] == 666.0
# end

# @testset "Unitful" begin
#     subsubparams = SubSubParams(4.0u"K", 5.0u"g")
#     subparams = SubParams(2.0, 3.0, subsubparams)
#     params = Params(Float64, 1.0u"g", subparams, 6.0u"s");

#     fieldtype(typeof(subparams), 3)
#     @inferred params[4]
#     @test params[1] === 1.0
#     @test params[2] === 2.0
#     @test params[3] === 3.0
#     @test params[4] === 4.0
#     @test params[5] === 5.0
#     @test params[end] === 6.0
#     params[1] = 99.0
#     @test params[1] === 99.0
# end

# @testset "Complex" begin
#     subsubparams = SubSubParams(Complex(4.0, 0.0), Complex(5.0, 0.0))
#     subparams = SubParams(Complex(2.0, 0.0), Complex(3.0, 0.0), subsubparams)
#     params = Params(Complex{Float64}, Complex(1.0, 0.0), subparams, Complex(6.0, 0.0));

#     fieldtype(typeof(subparams), 3)
#     @inferred params[4]
#     @test params[1]   === Complex(1.0, 0.0)
#     @test params[2]   === Complex(2.0, 0.0)
#     @test params[3]   === Complex(3.0, 0.0)
#     @test params[4]   === Complex(4.0, 0.0)
#     @test params[5]   === Complex(5.0, 0.0)
#     @test params[end] === Complex(6.0, 0.0)
#     params[1] = Complex(99.0, 0.0)
#     @test params[1] === Complex(99.0, 0.0)
# end

# mutable struct TuParams{T,L,N,U} <: CompositeFieldVector{T,L,N}
#     sub::U
# end

# @testset "Tuples in structs" begin
#     subsubparams = SubSubParams(4.0u"g", 5.0u"K")
#     subparams = SubParams(1.0, 2.0, 3.0)
#     tupleparams = TuParams(Float64, (subparams, subsubparams))
#     typeof(tupleparams)

#     @inferred tupleparams[4]
#     @test tupleparams[1] === 1.0
#     @test tupleparams[2] === 2.0
#     @test tupleparams[3] === 3.0
#     @test tupleparams[4] === 4.0
#     @test tupleparams[5] === 5.0
# end

# struct Test1{F}
#     p1::Array{F}
# end

@testset "Reconstruct" begin
    subsubparams = SubSubParams(4.0u"K", 5.0u"g")
    subparams = SubParams(2.0, 3.0, subsubparams)
    params = Params(1.0u"g", subparams, 6.0u"s", :x);
    params_test = reconstruct(params, [0.001, 0.002, 0.003, 0.004, 0.005, 0.006])
    @test flatten(params) == flatten(params_test) .* 1000
    @code_llvm flatten(params)

    subsubparams = SubSubParams(4.0, 5.0)
    values = complex.([4.0, 5.0], 1.0)
    subsubparams_test = reconstruct(subsubparams, values)
    @test complex(subsubparams.p4, 1.0) == subsubparams_test.p4
    @test complex(subsubparams.p5, 1.0) == subsubparams_test.p5

    subparams = SubParams(2.0, 3.0, subsubparams)
    values = complex.([2.0, 3.0, 4.0, 5.0], 1.0)
    subparams_test = reconstruct(subparams, values)
    @test complex(subparams.p2, 1.0) == subparams_test.p2
    @test complex(subparams.p3, 1.0) == subparams_test.p3

    params = Params(1.0, subparams, 6.0, :x)
    values = complex.([1.0, 2.0, 3, 4.0, 5.0, 6.0], 1.0)
    params_test = reconstruct(params, values)
    @test complex(params.p1, 1.0) == params_test.p1
    @test complex(params.p6, 1.0) == params_test.p6

    params = Params(nothing, subparams, 6.0, :x)
    values = [2.0, 3.0, 4.0, 5.0, 6.0]
    params_test = reconstruct(params, values)
    @test params.p1 == params_test.p1
    @test params.sub.p2 == params_test.sub.p2
    @test params.p6 == params_test.p6
end

@testset "Deconstruct and fieldnames" begin
    subsubparams = SubSubParams(4.0u"K", 5.0u"g")
    subparams = SubParams(2.0, 3.0, subsubparams)
    params = Params(1.0u"g", subparams, 6.0u"s", :x);
    @test flatten(params) == [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
    @test flatten_fieldnames(params) == [:p1, :p2, :p3, :p4, :p5, :p6]
end


@reflattenable mutable struct SubSubParams{T1,T2}
    p4::T1 | true
    p5::T2 | false
end

@testset "update falttenable fields" begin
    values = [1.0, 2.0, 3.0, 4.0, 6.0]
    subsubparams = SubSubParams(4.0u"K", 5.0u"g")
    subparams = SubParams(2.0, 3.0, subsubparams)
    params = Params(1.0u"g", subparams, 6.0u"s", :x);
    params_test = reconstruct(params, values)
    @test params.p1 == params_test.p1
    @test params.sub.p2 == params_test.sub.p2
    @test params.p6 == params_test.p6
    @test flatten(params) == [1.0, 2.0, 3.0, 4.0, 6.0]
    @test flatten_fieldnames(params) == [:p1, :p2, :p3, :p4, :p6]
end

@reflattenable mutable struct SubSubParams{T1,T2}
    p4::T1 | true
    p5::T2 | true
end

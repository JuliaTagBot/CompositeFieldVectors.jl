module CompositeFieldVectors

import Base: getindex, setindex!, size, vec, show, length#, 
             # similar, convert, map, map!, reduce, mapreduce, broadcast,
             # broadcast!, conj, hcat, vcat, ones, zeros, one, reshape, fill, fill!, inv,
             # iszero, sum, prod, count, any, all, minimum, maximum, extrema, mean,
             # copy, read, read!, write

export CompositeFieldVector,
       getindex,
       setindex!,
       size,
       length

const LOOKUP = 1
const LENGTH = 2
const FIELDTYPE = 3

abstract type CompositeFieldVector{L,N,T} <: AbstractVector{T} end

include("methods.jl")

(::Type{F})(args...) where F<:CompositeFieldVector = begin
    lookup = buildlookup(args, 1)
    b = body(F)
    types = union(b.types)
    paramdif = symdiff(b.parameters, b.super.parameters[LOOKUP:LENGTH]) 
    userparams = typeof.(args[indexin(types, paramdif)])
    F{lookup, length(lookup), userparams...}(args...)
end

buildlookup(fs::Tuple{T,Vararg}, i, l...) where T = 
    (buildlookup(fs[1], i, l...)..., buildlookup(Base.tail(fs), i + 1, l...)...)
buildlookup(fs::Tuple{T}, i, l...) where T = buildlookup(fs[1], i, l...)
buildlookup(fs::Tuple{}, i, l...) = tuple()
buildlookup(f::Number, i, l...) = ((l..., i),)
buildlookup(f, i, l...) = 
    buildlookup((getfield.(f, fieldnames(f))...), 1, l..., i)

body(x::UnionAll) = body(x.body)
body(x::DataType) = x

end # module

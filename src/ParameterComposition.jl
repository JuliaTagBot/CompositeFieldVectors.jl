module ParameterComposition

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

include("methods.jl")

abstract type CompositeFieldVector{L,N,T} <: AbstractVector{T} end

(::Type{F})(args...) where F<:CompositeFieldVector = begin
    lookup = buildlookup(args, 1, 1)
    F{lookup, length(lookup)}(args...)
end

mutable struct SubParams{A,S}
    p2::A
    p3::A
end

mutable struct Params{L,N,T,S} <: CompositeFieldVector{L,N,T}
    p1::T
    p2::T
    sub::S
end


buildlookup(fs::Tuple{T,Vararg}, i, l...) where T = 
    (buildlookup(fs[1], i, l...)..., buildlookup(Base.tail(fs), i + 1, l...)...)
buildlookup(fs::Tuple{T}, i, l...) where T = buildlookup(fs[1], i, l...)
buildlookup(fs::Tuple{}, i, l...) = tuple()
buildlookup(f::Number, i, l...) = ((l..., i),)
buildlookup(f, i, l...) = 
    buildlookup(fieldtuple(f, tuple(fieldnames(f)...)), 1, l..., i)

fieldtuple(field, fnames::Tuple{Vararg}) = 
    (getfield(field, fnames[1]), fieldtuple(field, fnames[2:end])...)
fieldtuple(field, fnames::Tuple{Symbol}) = (getfield(field, fnames[1]),)
fieldtuple(field, fnames::Tuple{}) = tuple()

end # module

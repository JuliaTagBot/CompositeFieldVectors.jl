module ParameterComposition

using StaticArrays


import Base: getindex, setindex!, size, similar, vec, show, length, convert, promote_op,
             promote_rule, map, map!, reduce, reducedim, mapreducedim, mapreduce, broadcast,
             broadcast!, conj, hcat, vcat, ones, zeros, one, reshape, fill, fill!, inv,
             iszero, sum, prod, count, any, all, minimum, maximum, extrema, mean,
             copy, read, read!, write

export CompositeFieldVector, 
       getindex, 
       setindex!, 
       size, 
       length

const TUPLELOOKUP = 3
abstract type CompositeFieldVector{N,T,L} end

length(x::CompositeFieldVector) = length(typeof(x).parameters[TUPLELOOKUP])
size(x::CompositeFieldVector) = (length(x),)

getindex(v::CompositeFieldVector, i::Int) = 
    dogetfield(v, typeof(v).parameters[TUPLELOOKUP], i)

setindex!(v::CompositeFieldVector, x, i::Int) = begin
    dosetfield!(v, typeof(v).parameters[TUPLELOOKUP], i, x)
    nothing
end

dosetfield!(v, l, i, x) = recursive_setfield!(v, l[i], x) # Separated out for type stability
dogetfield(v, l, i) = recursive_getfield(v, l[i]) # Separated out for type stability

recursive_setfield!(v, l::Tuple{Int,Vararg}, x) = recursive_setfield!(getfield(v, l[1]), l[2:end], x); nothing
recursive_setfield!(v::V, l::Tuple{Int}, x) where V = setfield!(v, l[1], x); nothing

recursive_getfield(v, l::Tuple{Int,Vararg}) = recursive_getfield(getfield(v, l[1]), l[2:end])
recursive_getfield(v, l::Tuple{Int}) = getfield(v, l[1])

end # module

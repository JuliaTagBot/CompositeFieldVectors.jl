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

include("constructors.jl")
include("methods.jl")

end # module

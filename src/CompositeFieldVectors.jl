module CompositeFieldVectors

import Base: getindex, setindex!, size, vec, length, copy 
             # read, read!, write

export CompositeFieldVector,
       getindex,
       setindex!,
       size,
       vec,
       length,
       copy,
       compositefieldparent,
       compositefieldparents,
       compositefieldname,
       compositefieldnames


const LOOKUP = 1
const LENGTH = 2
const FIELDTYPE = 3

include("constructors.jl")
include("methods.jl")

end # module

__precompile__()

module CompositeFieldVectors

using Requires

@require Unitful begin
    using Unitful
end
 

import Base: getindex, setindex!, endof, size, vec, length, copy # read, read!, write

export CompositeFieldVector,
       getindex,
       setindex!,
       endof,
       size,
       vec,
       length,
       copy,
       compositefieldparent,
       compositefieldparents,
       compositefieldname,
       compositefieldnames

include("constructors.jl")
include("methods.jl")

end # module

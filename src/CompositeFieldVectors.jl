# __precompile__()

module CompositeFieldVectors

using Requires, MetaFields

@require Unitful begin
    using Unitful
end
 
@metafield flattenable true

import Base: getindex, setindex!, endof, size, vec, length, copy # read, read!, write

export CompositeFieldVector,
       reconstruct,
       flatten,
       flatten_fieldnames,
       @flattenable,
       @reflattenable,
       flattenable,
       getindex,
       setindex!,
       endof,
       size,
       vec,
       length,
       copy

include("constructors.jl")
include("methods.jl")

end # module

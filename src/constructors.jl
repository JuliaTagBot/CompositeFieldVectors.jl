abstract type CompositeFieldVector{L,N,T} <: AbstractVector{T} end

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

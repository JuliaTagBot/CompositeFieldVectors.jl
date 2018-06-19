abstract type CompositeFieldVector{T,L,N} <: AbstractVector{T} end

" determines is a field is included in the composite vector "
composite(typ, field) = true

(::Type{F})(typ, args...) where F <: CompositeFieldVector = begin
    lookup = buildlookup(typ, filter(F, args), 1)
    tlookup = tuplelookup(lookup)
    F{typ, tlookup, length(lookup), typeof.(args)...}(args...)
end

filter(F, args) = begin
    include = composite.(F, fieldnames(F))
    x = [args...]
    x[.!include] .= nothing
    x
end

buildlookup(t, fs::Array, i, l...) = begin 
    if length(fs) > 1
        (buildlookup(t, fs[1], i, l...)..., buildlookup(t, fs[2:end], i + 1, l...)...)
    elseif length(fs) == 1 
        (buildlookup(t, fs[1], i, l...)...,) 
    else
        tuple()
    end
end
buildlookup(t, fs::Tuple, i, l...) = buildlookup(t, [fs...], 1, l..., i)
buildlookup(t, fs::Tuple{}, i, l...) = tuple()
buildlookup(t, f, i, l...) = begin
    typeof(f) <: Type(t) && return ((l..., i),)
    fns = fieldnames(f)
    if length(fns) > 0
        fns[composite.(typeof(f), fns)]
        buildlookup(t, Any[getfield.(f, fns)...], 1, l..., i)
    else
        tuple()
    end
end
@require Unitful begin
    buildlookup(t, f::T, i, l...) where T <: Unitful.Quantity = 
        typeof(f.val) <: Type(t) ? ((l..., i),) : nothing
end

function tuplelookup(lookup)
    typelookup = []
    for l in lookup
        push!(typelookup, Tuple{l...})
    end
    Tuple{typelookup...}
end

body(x::UnionAll) = body(x.body)
body(x::DataType) = x

abstract type CompositeFieldVector{T,L,N} <: AbstractVector{T} end

# (::Type{F})(typ::Type, args...) where F <: CompositeFieldVector = begin
#     lookup = buildlookuplist(typ, filter(F, args), 1)
#     tlookup = tuplelookup(lookup)
#     F{typ, tlookup, length(lookup), typeof.(args)...}(args...)
# end

# filter(F, args) = begin
#     include = flattenable.(F, fieldnames(F))
#     x = Any[args...]
#     x[.!include] .= nothing
#     x
# end

# buildlookuplist(t, fs::Array, i, l...) = begin
#     if length(fs) > 1
#         (buildlookup(t, fs[1], i, l...)..., buildlookuplist(t, fs[2:end], i + 1, l...)...)
#     elseif length(fs) == 1
#         (buildlookup(t, fs[1], i, l...)...,)
#     else
#         tuple()
#     end
# end
# buildlookup(t, fs::Tuple, i, l...) = begin
#     buildlookuplist(t, [fs...], 1, l..., i)
# end
# buildlookup(t, fs::Tuple{}, i, l...) = tuple()
# buildlookup(t, f::F, i, l...) where F = begin
#     F <: t && return ((l..., i),)
#     fns = fieldnames(F)
#     if length(fns) > 0 fs = Any[]
#         for fn in fns

#             push!(fs, getfield(f, fn))
#         end
#         fs = filter(F, fs)
#         buildlookuplist(t, fs, 1, l..., i)
#     else
#         tuple()
#     end
# end

# function tuplelookup(lookup)
#     typelookup = []
#     for l in lookup
#         push!(typelookup, Tuple{l...})
#     end
#     Tuple{typelookup...}
# end

# body(x::UnionAll) = body(x.body)
# body(x::DataType) = x

# @require Unitful begin
#     buildlookup(t, f::T, i, l...) where T <: Unitful.Quantity =
#         typeof(f.val) <: Type(t) ? ((l..., i),) : nothing

# end

"""
Reconstruct a composite type from an array
"""
Base.@pure reconstruct(ref, values::A) where A = begin
    x, rem::A = _reconstruct(ref, values)
    num_vals::Int = length(values)
    num_rem::Int = length(rem)
    # num_rem > 0 && error("array length $num_vals did not match available fields $(num_vals - num_rem)")
    x
end

# _reconstruct(ref::CompositeFieldVector{T,L,N}, rem_values) where {T,L,N} = begin
#     fields = []
#     fnames = fieldnames(ref)
#     fields, rem_values = composite_reconstruct(ref, rem_values)
#     t = typeof(ref).name.wrapper
#     return t(eltype(rem_values), fields...), rem_values
# end
Base.@pure _reconstruct(refs::Tuple, rem_values::AbstractVector{T}) where T = begin
    fields = []
    for ref in refs
        f, rem_values = _reconstruct(ref, rem_values)
        push!(fields, f)
    end
    tuple(fields...), rem_values
end
Base.@pure _reconstruct(ref, rem_values) = begin
    fields, rem_values = composite_reconstruct(ref, rem_values)
    t = typeof(ref).name.wrapper
    return t(fields...), rem_values
end
Base.@pure _reconstruct(refs::Void, rem_values) = nothing, rem_values
Base.@pure _reconstruct(ref::Number, rem_values) = rem_values[1], rem_values[2:end]

@require Unitful begin
    _reconstruct(ref::T, rem_values) where T <: Unitful.Quantity = begin
        (rem_values[1] * Unitful.unit(ref), rem_values[2:end])
    end
end

Base.@pure composite_reconstruct(ref, rem_values::AbstractVector{T}) where T = begin
    fields = []
    for fname in fieldnames(ref)
        if flattenable(ref, fname)
            t = typeof(getfield(ref, fname)).name.wrapper
            f, rem_values = _reconstruct(getfield(ref, fname), rem_values)
            push!(fields, f)
        else
            push!(fields, getfield(ref, fname))
        end
    end
    fields, rem_values
end

flatten(x; T=Float64) = flatten(x, :no_fieldname, T)
flatten(x, fname, T) = begin
    out = T[]
    for fname in fieldnames(x)
        if flattenable(x, fname)
            out = vcat(out, flatten(getfield(x, fname), fname, T))
        end
    end
    out
end
flatten(xs::Tuple, fname::Symbol, T) = begin
    out = T[]
    for x in xs
        out = vcat(out, flatten(x, fname, T))
    end
    out
end
flatten(x::Real, fname, T) = T[x]
flatten(x::Void, fname, T) = T[]
@require Unitful begin
    flatten(x::U, fname, T) where U <: Unitful.Quantity = T[x.val]
end

flatten_fieldnames(x) = flatten_fieldnames(x, :no_fieldname)
flatten_fieldnames(x, fname) = begin
    out = Symbol[]
    for fname in fieldnames(x)
        if flattenable(x, fname)
            out = vcat(out, flatten_fieldnames(getfield(x, fname), fname))
        end
    end
    return out
end
flatten_fieldnames(xs::Tuple, fname::Symbol) = begin
    out = Symbol[]
    for x in xs
        out = vcat(out, flatten_fieldnames(x, fname))
    end
    out
end
flatten_fieldnames(x::Real, fname) = [fname]
flatten_fieldnames(x::Void, fname) = Symbol[]
@require Unitful begin
    flatten_fieldnames(x::T, fname) where T <: Unitful.Quantity = [fname]
end



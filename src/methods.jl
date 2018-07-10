const CFV = CompositeFieldVector

# length(::CFV{T,L,N}) where {T,L,N} = N
# size(::CFV{T,L,N}) where {T,L,N} = (N,)
# vec(v::CFV) = getindex(v, :)
# copy(v::CFV) = typeof(v)([getfield(v, f) for f in fieldnames(v)]...)
# endof(v::CFV{T,L,N}) where {T,L,N} = N

# getindex(v::CFV{T,L}, I::AbstractArray) where {T,L} = [lookupget(v, T, L, i) for i in I]
# getindex(v::CFV{T,L,N}, I::Colon) where {T,L,N} = [lookupget(v, T, L, i) for i in 1:N]
# getindex(v::CFV{T,L}, i::Int) where {T,L} = lookupget(v, T, L, i)

# setindex!(v::CFV{T,L}, x, i::Int) where {T,L} = lookupset!(v, T, L, i, x)

# Build functions programmatically to handle up to 200 fields
# for num_args = 1:200
#     types = join([Symbol.(string.("_T",i)) for i = 1:num_args], ",")

#     ex = parse("lookupget(v::V, t::Type{T}, f::Type{Tuple{$types}}, i) where {T, V,$types} = 
#                     compositeget(v, t, ($types)[i])::T")
#     eval(ex)

#     ex = parse("lookupset!(v::V, t::Type{T}, f::Type{Tuple{$types}}, i, x) where {T, V,$types} = 
#                     compositeset!(v, t, ($types)[i], x)::T")
#     eval(ex)
# end

# get_string(t::Tuple{T,Vararg}) where T = "getf($(get_string(Base.tail(t))), $(t[1]))"
# get_string(t::Tuple{}) = "v"

# # Maximum tree depth is 10
# for num_args = 1:20
#     types = tuple([Symbol.(string.("_T",i)) for i = 1:num_args]...)
#     types_str = join(types, ",")
#     revtypes = reverse(types)

#     getstr = get_string(revtypes)
#     ex = parse("compositeget(v::V, t, f::Type{Tuple{$types_str}}) where {V,$types_str} = $getstr")
#     eval(ex)

#     getstr = "setf!($(get_string(Base.tail(revtypes))), $(revtypes[1]), x)"
#     ex = parse("compositeset!(v::V, t, f::Type{Tuple{$types_str}}, x) where {V,$types_str} = $getstr")
#     eval(ex)
# end

# getf(v::V, f) where V <: Tuple = v[f]
# getf(v, f) = strip(getfield(v, f))
# strip(f) = f
# setf!(v::V, f, x) where V = setftyped!(v, f, fieldtype(V, f), x)
# setftyped!(v, f, t, x) = setfield!(v, f, x)


# @require Unitful begin
#     strip(f::T) where T <: Quantity = f.val
#     setftyped!(v, f, t::Type{T}, x) where T <: Quantity = begin
#         setfield!(v, f, x * oneunit(t))
#         x
#     end
# end


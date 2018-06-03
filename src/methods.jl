const CFV = CompositeFieldVector

length(::CFV{L,N}) where {L,N} = N
size(::CFV{L,N}) where {L,N} = (N,)
vec(v::CFV) = getindex(v, :)
copy(v::CFV) = typeof(v)([getfield(v, f) for f in fieldnames(v)]...)

getindex(v::CFV{L}, I::AbstractArray) where L = [dogetfield(v, L, i) for i in I]
getindex(v::CFV{L}, I::Colon) where L = [dogetfield(v, L, i) for i in 1:length(v)]
getindex(v::CFV{L}, i::Int) where L = dogetfield(v, L, i)

setindex!(v::CFV{L}, x, i::Int) where L = dosetfield!(v, L, i, x)



recursive_setfield!(v, l::Tuple{Int,Vararg}, x) = 
    recursive_setfield!(getfield(v, l[1]), Base.tail(l), x)

recursive_setfield!(v, l::Tuple{Int}, x) = begin 
    setfield!(v, l[1], x)
    nothing
end

recursive_getfield(v, l::Tuple{Int,Vararg}) = 
    recursive_getfield(selectfield(v, tuple(fieldnames(v)), l[1]), Base.tail(l))

recursive_getfield(v, l::Tuple{Int})::Float64 = getfield(v, l[1])

compositefieldname(v::CFV{L}, i) where L = 
    recursive_fieldname(v, L[i][1:end-1], L[i][end])
recursive_fieldname(v, l, i) = 
    recursive_fieldname(selectfield(v, l[1]), Base.tail(l), i)
recursive_fieldname(v, l::Tuple{}, i) = fieldnames(v)[i]

compositefieldnames(v::CFV{L}) where L =
    [compositefieldname(v, i) for i in 1:length(v)]

compositefieldparent(v::CFV{L}, i::Int) where L = 
    recursive_fieldparent(v, L[i][1:end-1])
recursive_fieldparent(v, l) = 
    recursive_fieldparent(getfield(v, l[1]), Base.tail(l))
recursive_fieldparent(v, l::Tuple{}) = v
compositefieldparents(v::CFV{L}) where L =
    [compositefieldparent(v, i) for i in 1:length(v)]

type Syms{T} end

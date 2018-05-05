
length(::CompositeFieldVector{L,N}) where {L,N} = N
size(::CompositeFieldVector{L,N}) where {L,N} = (N,)
vec(v::CompositeFieldVector) = getindex(v, :)

getindex(v::CompositeFieldVector, I::AbstractArray) =
    [dogetfield(v, typeof(v).parameters[LOOKUP], i) for i in I]
getindex(v::CompositeFieldVector, I::Colon) =
    [dogetfield(v, typeof(v).parameters[LOOKUP], i) for i in 1:length(v)]
getindex(v::CompositeFieldVector, i::Int) =
    dogetfield(v, typeof(v).parameters[LOOKUP], i)

setindex!(v::CompositeFieldVector, x, i::Int) = 
    dosetfield!(v, typeof(v).parameters[LOOKUP], i, x)

# Separated out for type stability
dosetfield!(v, l, i, x) = recursive_setfield!(v, l[i], x)
dogetfield(v, l, i) = recursive_getfield(v, l[i])

recursive_setfield!(v, l::Tuple{Int,Vararg}, x) =
    recursive_setfield!(getfield(v, l[1]), l[2:end], x)
recursive_setfield!(v::V, l::Tuple{Int}, x) where V = setfield!(v, l[1], x)
recursive_getfield(v, l::Tuple{Int,Vararg}) =
    recursive_getfield(getfield(v, l[1]), l[2:end])
recursive_getfield(v, l::Tuple{Int})::Number = getfield(v, l[1])

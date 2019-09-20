doc = read(open("build/03-Interaktion.tex"),String)

abstract type State end
abstract type Transition end
struct Done <: State end
struct DoneAt <: State
    position::Int
end

struct SearchCmd{T<:Union{Regex,AbstractString}} <: State
    cmd::T
    position::Int
    SearchCmd(cmd::T,position::Int=1) where T = new{T}(cmd,position)
end


struct ExtractArgument <: State
    argument::String
    balance::NTuple{2,Int}
    position::Int
    ExtractArgument(pos::Int=1,balance::NTuple{2,Int}=(0,0),argument::String="") = new(argument,balance,pos)
end

mutable struct Read <: Transition
    str::AbstractString
end

mutable struct ReadDelimited <: Transition
    str::AbstractString
    delimiters::NTuple{2,Char}
end

function Base.step(collector::Vector{String},state::SearchCmd,transition::Read)
    pos = findnext(state.cmd,transition.str,state.position)
    if pos == nothing
        return Done()
    else
        return ExtractArgument(nextind(transition.str,last(pos)))
    end
end

isopening(transition::ReadDelimited,c::Char) = transition.delimiters[1] == c
iscloseing(transition::ReadDelimited,c::Char) = transition.delimiters[2] == c
isfirst(state::ExtractArgument) = state.argument==""
balances(state::ExtractArgument) = state.balance[1] == state.balance[2]

function Base.step(collector::Vector{String},state::ExtractArgument,transition::ReadDelimited)
    c = transition.str[state.position]
    if isfirst(state) && !isopening(transition,c)
        return DoneAt(state.position)
    elseif isopening(transition,c)
        return ExtractArgument(nextind(transition.str,state.position),state.balance.+(1,0),state.argument*c)
    elseif iscloseing(transition,c)
        return ExtractArgument(nextind(transition.str,state.position),state.balance.+(0,1),state.argument*c)
    elseif balances(state)
        push!(collector, state.argument[2:end-1])
        return DoneAt(state.position)
    end
    return ExtractArgument(nextind(transition.str,state.position),state.balance,state.argument*c)
end

function Base.step(collector::Vector{String},state::DoneAt,transition::ReadDelimited)
    c = transition.str[state.position]
    return ExtractArgument(state.position)
end

col = String[]
sc = SearchCmd(r"\\footnotetext")
sa = step(col,sc,Read(doc))

while (sa = step(col,sa,ReadDelimited(doc,('[',']')))) |> typeof == ExtractArgument
end

while (sa = step(col,sa,ReadDelimited(doc,('{','}')))) |> typeof == ExtractArgument
end

col

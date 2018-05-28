export Result, Field, FieldTM, FieldTE
export AxisX, AxisY, AxisComponent

const AxisX = Axis{:x}
const AxisY = Axis{:y}
const AxisComponent = Axis{:component, Array{Symbol,1}}

abstract type Result{T,N} <: AbstractArray{T,N} end
abstract type Field{N} <: Result{Complex,N} end

Base.size(A::Result) = size(A.data)
Base.IndexStyle(A::Result) = IndexStyle(A.data)

@inline @Base.propagate_inbounds Base.getindex(A::Result, i...) =
  getindex(A.data, i...)
@inline @Base.propagate_inbounds Base.getindex(A::Result, i::Int...) =
  getindex(A.data, i...)
@inline @Base.propagate_inbounds Base.setindex!(A::Result, val, i...) =
  setindex!(A.data, val, i...)
@inline @Base.propagate_inbounds Base.setindex!(A::Result{T}, val::T, i::Int...) where T =
  setindex!(A.data, val, i...)

# ============================================================================ #

struct FieldTM <: Field{3}
    grid::Grid{2}
    ω::Complex
    data::AxisArray
end

function FieldTM(grid::Grid{2}, ω::Number, data::Array{<:Complex,3})
    return FieldTM(grid, Complex(ω), AxisArray(data, AxisX(xc(grid)), AxisY(yc(grid)), AxisComponent([:Ez, :Hx, :Hy])))
end

function FieldTM(grid::Grid{2}, ω::Number, Ez::Array{<:Complex,1}, Hx::Array{<:Complex,1}, Hy::Array{<:Complex,1})
  	sz = size(grid);
    return FieldTM(grid, ω, cat(3, reshape(Ez, sz), reshape(Hx, sz), reshape(Hy, sz)))
end

struct FieldTE <: Field{3}
    grid::Grid{2}
    ω::Complex
    data::AxisArray
end

function FieldTE(grid::Grid{2}, ω::Number, data::Array{<:Complex,3})
    return FieldTE(grid, Complex(ω), AxisArray(data, AxisX(xc(grid)), AxisY(yc(grid)), AxisComponent([:Hz, :Ex, :Ey])))
end

function FieldTE(grid::Grid{2}, ω::Number, Hz::Array{<:Complex,1}, Ex::Array{<:Complex,1}, Ey::Array{<:Complex,1})
  	sz = size(grid);
    return FieldTE(grid, ω, cat(3, reshape(Hz, sz), reshape(Ex, sz), reshape(Ey, sz)))
end

# ============================================================================ #

struct Flux2D <: Field{2}
    grid::Grid{2}
    data::AxisArray
end

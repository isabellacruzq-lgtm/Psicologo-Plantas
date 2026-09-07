"""
    Estadisticas

Módulo responsable exclusivamente de calcular estadísticas
agregadas sobre un conjunto de plantas (promedios y extremos).
Todos los cálculos se realizan de forma normal y secuencial,
recorriendo el vector de plantas una sola vez.
"""
module Estadisticas

using ..Plantas: Planta

export ResumenEstadisticas, resumen_estadisticas

"""
    ResumenEstadisticas

Contiene los valores agregados calculados sobre un conjunto de
plantas: la cantidad de plantas, los promedios de cada estadística
y los nombres de la planta más feliz y la más estresada.
"""
struct ResumenEstadisticas
    cantidad::Int
    felicidad_promedio::Float64
    estres_promedio::Float64
    energia_promedio::Float64
    soledad_promedio::Float64
    planta_mas_feliz::String
    planta_mas_estresada::String
end

"""
    promedio(valores) -> Float64

Calcula el promedio de una colección de números. Devuelve `0.0`
si la colección está vacía, para evitar dividir por cero.
"""
promedio(valores) = isempty(valores) ? 0.0 : sum(valores) / length(valores)

"""
    resumen_estadisticas(plantas::Vector{Planta}) -> ResumenEstadisticas

Calcula, de forma secuencial, los promedios de felicidad, estrés,
energía y soledad de un conjunto de plantas, y determina cuál es la
planta más feliz y cuál la más estresada.

Lanza un `ArgumentError` si el vector de plantas está vacío.
"""
function resumen_estadisticas(plantas::Vector{Planta})
    isempty(plantas) && throw(ArgumentError("No hay plantas para calcular estadísticas"))

    mas_feliz = plantas[1]
    mas_estresada = plantas[1]
    for planta in plantas
        if planta.felicidad > mas_feliz.felicidad
            mas_feliz = planta
        end
        if planta.estres > mas_estresada.estres
            mas_estresada = planta
        end
    end

    ResumenEstadisticas(
        length(plantas),
        promedio([p.felicidad for p in plantas]),
        promedio([p.estres for p in plantas]),
        promedio([p.energia for p in plantas]),
        promedio([p.soledad for p in plantas]),
        mas_feliz.nombre,
        mas_estresada.nombre,
    )
end

end # module Estadisticas

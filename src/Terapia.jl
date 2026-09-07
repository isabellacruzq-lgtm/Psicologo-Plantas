"""
    Terapia

Módulo responsable exclusivamente de las acciones terapéuticas que
el jugador puede aplicar sobre una planta. No sabe nada de cómo se
muestra el menú ni de cómo se calculan diagnósticos o estadísticas
(Single Responsibility Principle).
"""
module Terapia

using ..Plantas: Planta, ajustar_estadistica!

export AccionTerapia, Escuchar, DarConsejo, ContarChiste, DarAgua, DarSol,
       aplicar!, descripcion, acciones_disponibles

"""
    AccionTerapia

Tipo abstracto para las acciones terapéuticas disponibles en el
consultorio. Cada acción concreta implementa `aplicar!` y
`descripcion`. Agregar una acción nueva consiste en definir un
`struct` nuevo y sus métodos, sin modificar el código existente
(Open/Closed Principle). La interfaz es pequeña a propósito:
solo exige estas dos funciones (Interface Segregation Principle).
"""
abstract type AccionTerapia end

struct Escuchar <: AccionTerapia end
struct DarConsejo <: AccionTerapia end
struct ContarChiste <: AccionTerapia end
struct DarAgua <: AccionTerapia end
struct DarSol <: AccionTerapia end

"""
    descripcion(accion::AccionTerapia) -> String

Devuelve el texto legible de una acción terapéutica, usado en el menú.
"""
descripcion(::Escuchar) = "Escuchar"
descripcion(::DarConsejo) = "Dar un consejo"
descripcion(::ContarChiste) = "Contar un chiste"
descripcion(::DarAgua) = "Dar agua"
descripcion(::DarSol) = "Dar exposición al sol"

"""
    aplicar!(accion::AccionTerapia, planta::Planta) -> Planta

Aplica los efectos de una acción terapéutica sobre una planta,
modificando sus estadísticas dentro del rango permitido [0, 100].
Cada tipo concreto de `AccionTerapia` implementa su propia versión
mediante multiple dispatch.
"""
function aplicar! end

"""
    aplicar!(::Escuchar, planta::Planta)

Escuchar a la planta: Felicidad +5, Estrés -5, Soledad -10.
"""
function aplicar!(::Escuchar, planta::Planta)
    ajustar_estadistica!(planta, :felicidad, 5)
    ajustar_estadistica!(planta, :estres, -5)
    ajustar_estadistica!(planta, :soledad, -10)
    return planta
end

"""
    aplicar!(::DarConsejo, planta::Planta)

Dar un consejo a la planta: Felicidad +3, Estrés -8.
"""
function aplicar!(::DarConsejo, planta::Planta)
    ajustar_estadistica!(planta, :felicidad, 3)
    ajustar_estadistica!(planta, :estres, -8)
    return planta
end

"""
    aplicar!(::ContarChiste, planta::Planta)

Contar un chiste a la planta: Felicidad +10, Estrés -5.
"""
function aplicar!(::ContarChiste, planta::Planta)
    ajustar_estadistica!(planta, :felicidad, 10)
    ajustar_estadistica!(planta, :estres, -5)
    return planta
end

"""
    aplicar!(::DarAgua, planta::Planta)

Dar agua a la planta: Energía +5, Felicidad +2.
"""
function aplicar!(::DarAgua, planta::Planta)
    ajustar_estadistica!(planta, :energia, 5)
    ajustar_estadistica!(planta, :felicidad, 2)
    return planta
end

"""
    aplicar!(::DarSol, planta::Planta)

Dar exposición al sol a la planta: Energía +5, Felicidad +5.
"""
function aplicar!(::DarSol, planta::Planta)
    ajustar_estadistica!(planta, :energia, 5)
    ajustar_estadistica!(planta, :felicidad, 5)
    return planta
end

"""
    acciones_disponibles() -> Vector{AccionTerapia}

Lista de acciones terapéuticas disponibles, en el orden en que se
muestran al usuario en el menú de atención.
"""
acciones_disponibles() = AccionTerapia[Escuchar(), DarConsejo(), ContarChiste(), DarAgua(), DarSol()]

end # module Terapia

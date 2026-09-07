"""
    Diagnostico

Módulo responsable exclusivamente de determinar los diagnósticos
ficticios de una planta a partir de sus estadísticas actuales.
Estos diagnósticos son parte del juego y **no representan
diagnósticos médicos ni psicológicos reales**.
"""
module Diagnostico

using ..Plantas: Planta

export Regla, diagnosticar, reglas_diagnostico

"""
    Regla

Representa una regla de diagnóstico ficticio: un predicado que
recibe una `Planta` y devuelve `Bool`, junto con el nombre del
diagnóstico que aplica cuando el predicado es verdadero.

Agregar un nuevo diagnóstico consiste simplemente en agregar una
nueva `Regla` a `reglas_diagnostico`, sin modificar la función
`diagnosticar` (Open/Closed Principle).
"""
struct Regla
    condicion::Function
    nombre::String
end

"""
    reglas_diagnostico() -> Vector{Regla}

Devuelve las reglas de diagnóstico ficticio del consultorio,
evaluadas en el orden en que aparecen en el vector. Una misma
planta puede recibir varios diagnósticos si cumple varias reglas.
"""
function reglas_diagnostico()
    Regla[
        Regla(p -> p.soledad > 60, "Soledad Botánica"),
        Regla(p -> p.estres > 70, "Ansiedad Fotosintética"),
        Regla(p -> p.felicidad < 40, "Síndrome de la Hoja Triste"),
        Regla(p -> p.personalidad == "Dramática" && p.felicidad < 60, "Drama Floral Agudo"),
        Regla(p -> p.personalidad == "Ansioso" && p.estres > 60, "Crisis Existencial Floral"),
        Regla(p -> p.energia < 30, "Estrés de Maceta"),
    ]
end

"""
    diagnosticar(planta::Planta) -> Vector{String}

Determina los diagnósticos ficticios que aplican a una planta según
sus estadísticas actuales, recorriendo `reglas_diagnostico()` de
forma secuencial. Si ninguna regla aplica, devuelve un mensaje
indicando que la planta no presenta ningún diagnóstico.
"""
function diagnosticar(planta::Planta)
    resultados = String[regla.nombre for regla in reglas_diagnostico() if regla.condicion(planta)]
    return isempty(resultados) ? ["Sin diagnóstico aparente"] : resultados
end

end # module Diagnostico

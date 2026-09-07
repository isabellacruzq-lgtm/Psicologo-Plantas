"""PsicologoPlantas

Módulo raíz del proyecto académico "🌱 Psicólogo de Plantas"
(también llamado "PsicoBotánica").

Agrupa e importa los módulos internos, cada uno con una
responsabilidad clara y separada:

- `Plantas`: modelos de plantas y sus tipos.
- `Terapia`: acciones terapéuticas.
- `Diagnostico`: reglas de diagnóstico ficticio.
- `Estadisticas`: cálculo de estadísticas agregadas.
- `Juego`: menú e interacción con el usuario.

El programa es una aplicación de consola, completamente
secuencial: no utiliza hilos, tareas, canales, locks ni ningún
tipo de concurrencia o paralelismo.
"""
module PsicologoPlantas

include("Plantas.jl")
include("Terapia.jl")
include("Diagnostico.jl")
include("Estadisticas.jl")
include("Juego.jl")

using .Plantas
using .Terapia
using .Diagnostico
using .Estadisticas
using .Juego

export TipoPlanta, Cactus, Girasol, Rosa, Bonsai, PlantaCarnivora,
       Planta, crear_planta, ajustar_estadistica!, emoji, nombre_tipo,
       plantas_iniciales,
       AccionTerapia, Escuchar, DarConsejo, ContarChiste, DarAgua, DarSol,
       aplicar!, descripcion, acciones_disponibles,
       Regla, diagnosticar, reglas_diagnostico,
       ResumenEstadisticas, resumen_estadisticas,
       iniciar_juego

end # module PsicologoPlantas

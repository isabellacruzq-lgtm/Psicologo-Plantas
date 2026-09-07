"""
Módulo responsable exclusivamente del menú y del flujo de
interacción con el usuario. Coordina los módulos `Plantas`,
`Terapia`, `Diagnostico` y `Estadisticas`, pero no implementa la
lógica interna de ninguno de ellos (Single Responsibility Principle).

El bucle principal es completamente secuencial: se muestra el menú,
se lee una opción, se ejecuta la acción correspondiente y se
muestra el resultado antes de volver al menú.
"""
module Juego

using ..Plantas
using ..Terapia
using ..Diagnostico
using ..Estadisticas

export iniciar_juego

function iniciar_juego(; entrada::IO=stdin, salida::IO=stdout)
    plantas = plantas_iniciales()
    continuar = true
    while continuar
        mostrar_menu(salida)
        opcion = leer_entero(entrada)
        continuar = ejecutar_opcion(opcion, plantas, entrada, salida)
    end
end

function leer_entero(entrada::IO)
    linea = readline(entrada)
    return tryparse(Int, strip(linea))
end

"""Espera a que el usuario presione Enter antes de volver al menú."""
function pausar(entrada::IO, salida::IO)
    println(salida)
    print(salida, "Presiona Enter para continuar...")
    try
        readline(entrada)
    catch e
        # Permite usar IOs que lleguen a EOF, por ejemplo en pruebas.
        e isa EOFError || rethrow()
    end
end

function mostrar_menu(salida::IO)
    println(salida, "=========================================")
    println(salida, " PsicoBotánica 🌱 Psicología de Plantas")
    println(salida, "=================================")
    println(salida)
    println(salida, "1. Ver plantas")
    println(salida, "2. Atender una planta")
    println(salida, "3. Diagnosticar una planta")
    println(salida, "4. Ver estadísticas")
    println(salida, "5. Salir")
    println(salida)
    print(salida, "Seleccione una opción: ")
end

function ejecutar_opcion(opcion, plantas, entrada::IO, salida::IO)
    if opcion == 1
        ver_plantas(plantas, salida)
        pausar(entrada, salida)
    elseif opcion == 2
        atender_planta(plantas, entrada, salida)
    elseif opcion == 3
        diagnosticar_planta(plantas, entrada, salida)
    elseif opcion == 4
        ver_estadisticas(plantas, salida)
        pausar(entrada, salida)
    elseif opcion == 5
        println(salida, "Gracias por cuidar de las plantas. ¡Hasta pronto!")
        return false
    else
        println(salida, "Opción inválida. Intente nuevamente.")
        pausar(entrada, salida)
    end
    println(salida)
    return true
end

"""Muestra todas las plantas del consultorio y sus estadísticas actuales."""
function ver_plantas(plantas, salida::IO)
    println(salida, "=================================")
    println(salida, "           MIS PLANTAS")
    println(salida, "=================================")
    println(salida)

    for (i, planta) in enumerate(plantas)
        println(salida, "$i. $(emoji(planta.tipo)) $(planta.nombre) - $(nombre_tipo(planta.tipo))")
        println(salida, "   Personalidad: $(planta.personalidad)")
        println(salida, "   Problema: $(planta.problema)")
        println(salida, "   Felicidad: $(planta.felicidad)/100")
        println(salida, "   Estrés: $(planta.estres)/100")
        println(salida, "   Energía: $(planta.energia)/100")
        println(salida, "   Soledad: $(planta.soledad)/100")
        println(salida)
    end
end

function seleccionar_planta(plantas, entrada::IO, salida::IO)
    println(salida)
    println(salida, "PLANTAS DISPONIBLES")
    for (i, planta) in enumerate(plantas)
        println(salida, "$i. $(emoji(planta.tipo)) $(planta.nombre)")
    end
    println(salida, "$(length(plantas) + 1). Volver")
    print(salida, "Seleccione una planta: ")
    indice = leer_entero(entrada)
    if indice === nothing || indice < 1 || indice > length(plantas)
        println(salida, "Planta inválida.")
        return nothing
    end
    return plantas[indice]
end

function atender_planta(plantas, entrada::IO, salida::IO)
    planta = seleccionar_planta(plantas, entrada, salida)
    planta === nothing && return

    println(salida)
    println(salida, "¿Qué quieres hacer con $(planta.nombre)?")
    println(salida)
    acciones = acciones_disponibles()
    for (i, accion) in enumerate(acciones)
        println(salida, "$i. $(descripcion(accion))")
    end
    println(salida, "$(length(acciones) + 1). Volver")
    print(salida, "Seleccione una opción: ")
    opcion = leer_entero(entrada)

    if opcion === nothing || opcion < 1 || opcion > length(acciones)
        println(salida, "Volviendo al menú principal.")
        return
    end

    accion = acciones[opcion]
    estado_anterior = (
        felicidad=planta.felicidad,
        estres=planta.estres,
        energia=planta.energia,
        soledad=planta.soledad,
    )

    aplicar!(accion, planta)
    mostrar_feedback(accion, planta, estado_anterior, salida)
    pausar(entrada, salida)
end

"""Muestra un mensaje concreto y el cambio de estado producido por la terapia."""
function mostrar_feedback(accion::AccionTerapia, planta, antes, salida::IO)
    println(salida)
    println(salida, "✓ Acción realizada: $(descripcion(accion))")

    if accion isa Escuchar
        println(salida, "$(planta.nombre) pudo desahogarse y ahora se siente más acompañado/a.")
    elseif accion isa DarConsejo
        println(salida, "$(planta.nombre) recibió un consejo y se siente un poco más tranquilo/a.")
    elseif accion isa ContarChiste
        println(salida, "¡Le contaste un chiste a $(planta.nombre) y su estrés bajó un 5%! 🌱😄")
    elseif accion isa DarAgua
        println(salida, "💧 $(planta.nombre) recibió agua y recuperó energía.")
    elseif accion isa DarSol
        println(salida, "☀️ $(planta.nombre) recibió un poco de sol y recuperó energía y felicidad.")
    else
        println(salida, "$(planta.nombre) recibió atención y su estado ha sido actualizado.")
    end

    println(salida)
    println(salida, "Estado actual de $(planta.nombre):")
    println(salida, "  Felicidad: $(antes.felicidad) → $(planta.felicidad)")
    println(salida, "  Estrés:    $(antes.estres) → $(planta.estres)")
    println(salida, "  Energía:   $(antes.energia) → $(planta.energia)")
    println(salida, "  Soledad:   $(antes.soledad) → $(planta.soledad)")
end

function diagnosticar_planta(plantas, entrada::IO, salida::IO)
    planta = seleccionar_planta(plantas, entrada, salida)
    planta === nothing && return

    println(salida)
    println(salida, "=================================")
    println(salida, "     DIAGNÓSTICO DE $(planta.nombre)")
    println(salida, "=================================")
    println(salida)

    resultados = diagnosticar(planta)
    println(salida, "Resultado de las reglas de diagnóstico:")
    for diagnostico in resultados
        println(salida, "- $diagnostico")
    end

    println(salida)
    println(salida, "Nota: los diagnósticos son ficticios y forman parte del juego.")
    pausar(entrada, salida)
end

function ver_estadisticas(plantas, salida::IO)
    resumen = resumen_estadisticas(plantas)
    println(salida, "=================================")
    println(salida, "          ESTADÍSTICAS")
    println(salida, "=================================")
    println(salida)
    println(salida, "Plantas atendidas: $(resumen.cantidad)")
    println(salida)
    println(salida, "Felicidad promedio: $(round(resumen.felicidad_promedio, digits=1))")
    println(salida, "Estrés promedio: $(round(resumen.estres_promedio, digits=1))")
    println(salida, "Energía promedio: $(round(resumen.energia_promedio, digits=1))")
    println(salida, "Soledad promedio: $(round(resumen.soledad_promedio, digits=1))")
    println(salida)
    println(salida, "🌟 Planta más feliz: $(resumen.planta_mas_feliz)")
    println(salida, "⚠️ Planta con más estrés: $(resumen.planta_mas_estresada)")
end

end # module Juego

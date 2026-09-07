# Psicólogo de Plantas (PsicoBotánica)

Aplicación de consola escrita en Julia donde el usuario interpreta a un
psicólogo de plantas: puede ver a sus pacientes (plantas con personalidades
y problemas ficticios), atenderlas con acciones terapéuticas, diagnosticarlas
y revisar estadísticas generales del consultorio.

> Los diagnósticos y problemas de este proyecto son completamente
> ficticios y con fines académicos y de entretenimiento. No representan
> diagnósticos médicos ni psicológicos reales.

## Objetivo académico

Este proyecto no busca ser un videojuego complejo, sino demostrar de forma
simple y explicable:

- Programación orientada a objetos idiomática en Julia.
- Los cinco principios **SOLID**, aplicados de forma natural (sin copiar
  patrones de Java).
- Abstracciones mediante `abstract type` y `struct`.
- **Multiple dispatch** como mecanismo de extensión.
- Separación de responsabilidades entre módulos.
- Inyección de dependencias sencilla (sin frameworks).
- Documentación con docstrings idiomáticos de Julia.
- Pruebas unitarias con el módulo estándar `Test`.

Todo el programa es **100% secuencial**: no utiliza hilos, tareas, canales,
locks, worker pools, ni ningún mecanismo de concurrencia o paralelismo.

## Arquitectura

El código se organiza en 5 módulos, cada uno con una responsabilidad única:

| Módulo | Archivo | Responsabilidad |
|---|---|---|
| `Plantas` | `src/Plantas.jl` | Modela qué es una planta, sus tipos (Cactus, Girasol, Rosa, Bonsai, Planta carnívora) y sus estadísticas. |
| `Terapia` | `src/Terapia.jl` | Modela las acciones terapéuticas (Escuchar, Dar consejo, Contar chiste, Dar agua, Dar sol) y sus efectos. |
| `Diagnostico` | `src/Diagnostico.jl` | Modela las reglas de diagnóstico ficticio según las estadísticas de la planta. |
| `Estadisticas` | `src/Estadisticas.jl` | Calcula promedios y extremos sobre el conjunto de plantas. |
| `Juego` | `src/Juego.jl` | Muestra el menú, lee la entrada del usuario y coordina los demás módulos. |

`src/PsicologoPlantas.jl` es el módulo raíz que incluye e importa todo lo
anterior, y expone `iniciar_juego` como punto de entrada.

El flujo del programa es un bucle secuencial:

```
Mostrar menú → Leer opción → Ejecutar acción → Mostrar resultado → Repetir
```

## SOLID en este proyecto

- **S — Responsabilidad única:** cada módulo hace una sola cosa (tabla de
  arriba). Por ejemplo, `Juego.jl` nunca calcula un diagnóstico ni un
  promedio; delega esas tareas a `Diagnostico` y `Estadisticas`.

- **O — Abierto/Cerrado:** agregar una acción terapéutica nueva es crear un
  `struct <: AccionTerapia` y un método `aplicar!` — no se toca ningún
  código existente. Lo mismo con los diagnósticos: se agrega una `Regla`
  (predicado + nombre) al vector de `reglas_diagnostico()`, sin modificar
  la función `diagnosticar`.

- **L — Sustitución de Liskov:** cualquier subtipo de `TipoPlanta` (por
  ejemplo `Cactus` o `Girasol`) puede usarse donde se espera un
  `TipoPlanta`, porque `emoji` y `nombre_tipo` están definidos por
  multiple dispatch para cada tipo, sin comportamientos artificiales ni
  casos especiales.

- **I — Segregación de interfaces:** las interfaces son pequeñas y
  puntuales. `AccionTerapia` solo exige `aplicar!` (y `descripcion` para
  mostrarse en el menú); `TipoPlanta` solo exige `emoji` y `nombre_tipo`.
  No hay interfaces gigantes ni funciones que no se usan.

- **D — Inversión de dependencias:** `iniciar_juego(; entrada::IO=stdin,
  salida::IO=stdout)` recibe los flujos de entrada/salida como parámetros
  con valores por defecto. El juego depende de la abstracción `IO`, no de
  la consola concreta, lo que permite (en teoría) probarlo con flujos
  distintos sin acoplarlo a `stdin`/`stdout`.

## Estructura del proyecto

```
psicologo-plantas/
│
├── Project.toml
├── README.md
│
├── src/
│   ├── PsicologoPlantas.jl   (módulo raíz)
│   ├── Plantas.jl
│   ├── Terapia.jl
│   ├── Diagnostico.jl
│   ├── Estadisticas.jl
│   └── Juego.jl

```

## Ejecución

Instalar dependencias:

```bash
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

Iniciar el juego:

```bash
julia --project=. -e 'using PsicologoPlantas; iniciar_juego()'
```

Las pruebas cubren:

- **Plantas:** creación correcta, valores iniciales y rango 0–100.
- **Terapia:** que cada acción modifique las estadísticas como se espera
  y que nunca superen el rango permitido.
- **Diagnóstico:** que las reglas de soledad, estrés y felicidad disparen
  el diagnóstico correcto, y que una planta sin condiciones no reciba
  ninguno.
- **Estadísticas:** cantidad de plantas, promedios y extremos (planta más
  feliz / con más estrés).

## Ejemplo de uso

```
=================================
     PSICÓLOGO DE PLANTAS
=================================

1. Ver plantas
2. Atender una planta
3. Diagnosticar una planta
4. Ver estadísticas
5. Salir

Seleccione una opción: 2
1. Spike
2. Sunny
3. Rosa
4. Bonsai
5. Chompy
Seleccione una planta: 1

¿Qué quieres hacer?

1. Escuchar
2. Dar un consejo
3. Contar un chiste
4. Dar agua
5. Dar exposición al sol
6. Volver
Seleccione una opción: 1
Spike se siente atendido/a.

Seleccione una opción: 3
1. Spike
...
Seleccione una planta: 1

Diagnóstico de Spike:
- Soledad Botánica
```


# Link del Repositorio
https://github.com/isabellacruzq-lgtm/Psicologo-Plantas/

# Link Actividad Alcance y Encadenamiento
https://github.com/EthanLopz/Alcance
https://github.com/valentinaortizm-sketch/TAREA

## Conclusión

El proyecto demuestra, con un alcance pequeño y fácil de explicar, cómo
Julia permite aplicar principios de diseño orientado a objetos (SOLID,
abstracción, composición) usando sus propias herramientas idiomáticas
—`struct`, `abstract type` y multiple dispatch— en lugar de imitar
patrones de otros lenguajes. También muestra cómo separar
responsabilidades en módulos, documentar con docstrings y escribir
pruebas unitarias deterministas, todo dentro de un programa de consola
100% secuencial.

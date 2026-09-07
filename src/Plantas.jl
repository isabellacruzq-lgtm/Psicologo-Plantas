"""
Módulo responsable exclusivamente de modelar qué es una planta:
su tipo (especie), su personalidad, su problema y sus estadísticas.

No sabe nada de terapia, diagnóstico ni del menú del juego
(Single Responsibility Principle).
"""
module Plantas

export TipoPlanta, Cactus, Girasol, Rosa, Bonsai, PlantaCarnivora,
       Planta, crear_planta, ajustar_estadistica!, emoji, nombre_tipo,
       plantas_iniciales

"""
    TipoPlanta

Tipo abstracto que representa la especie de una planta.

Cada especie concreta (`Cactus`, `Girasol`, `Rosa`, `Bonsai`,
`PlantaCarnivora`) implementa sus propios métodos de `emoji` y
`nombre_tipo` mediante multiple dispatch. Agregar una nueva especie
no requiere modificar el código existente (Open/Closed Principle),
y cualquier subtipo puede usarse donde se espera un `TipoPlanta`
(Liskov Substitution Principle).
"""
abstract type TipoPlanta end

struct Cactus <: TipoPlanta end
struct Girasol <: TipoPlanta end
struct Rosa <: TipoPlanta end
struct Bonsai <: TipoPlanta end
struct PlantaCarnivora <: TipoPlanta end

"""
    emoji(tipo::TipoPlanta) -> String

Devuelve el emoji asociado a un tipo de planta.
"""
emoji(::Cactus) = "🌵"
emoji(::Girasol) = "🌻"
emoji(::Rosa) = "🌹"
emoji(::Bonsai) = "🌳"
emoji(::PlantaCarnivora) = "🌿"

"""
    nombre_tipo(tipo::TipoPlanta) -> String

Devuelve el nombre legible de la especie de la planta.
"""
nombre_tipo(::Cactus) = "Cactus"
nombre_tipo(::Girasol) = "Girasol"
nombre_tipo(::Rosa) = "Rosa"
nombre_tipo(::Bonsai) = "Bonsai"
nombre_tipo(::PlantaCarnivora) = "Planta carnívora"

const LIMITE_MIN = 0
const LIMITE_MAX = 100

"""
    limitar(valor::Int) -> Int

Restringe un valor entero al rango permitido [0, 100].
"""
limitar(valor::Int) = clamp(valor, LIMITE_MIN, LIMITE_MAX)

"""
    Planta

Representa el estado de una planta dentro del consultorio.

Es `mutable` porque sus estadísticas (`felicidad`, `estres`,
`energia`, `soledad`) cambian durante las sesiones de terapia; esa
es la única razón para usar mutabilidad en este proyecto.

# Campos
- `nombre::String`: nombre de la planta.
- `tipo::TipoPlanta`: especie de la planta.
- `personalidad::String`: rasgo de personalidad ficticio.
- `problema::String`: problema ficticio que la aqueja.
- `felicidad::Int`, `estres::Int`, `energia::Int`, `soledad::Int`:
  estadísticas, siempre dentro del rango [0, 100].
"""
mutable struct Planta
    nombre::String
    tipo::TipoPlanta
    personalidad::String
    problema::String
    felicidad::Int
    estres::Int
    energia::Int
    soledad::Int
end

"""
    crear_planta(nombre, tipo, personalidad, problema;
                 felicidad, estres, energia, soledad) -> Planta

Crea una nueva planta, asegurando que las estadísticas iniciales
queden dentro del rango permitido [0, 100] aunque los valores de
entrada estén fuera de rango.
"""
function crear_planta(nombre::String, tipo::TipoPlanta, personalidad::String, problema::String;
                       felicidad::Int, estres::Int, energia::Int, soledad::Int)
    Planta(nombre, tipo, personalidad, problema,
           limitar(felicidad), limitar(estres), limitar(energia), limitar(soledad))
end

"""
    ajustar_estadistica!(planta::Planta, campo::Symbol, delta::Int) -> Planta

Modifica una estadística de la planta (`:felicidad`, `:estres`,
`:energia` o `:soledad`) sumando `delta`, asegurando que el
resultado permanezca dentro del rango [0, 100]. Modifica la
planta en el lugar y la devuelve para permitir encadenar llamadas.
"""
function ajustar_estadistica!(planta::Planta, campo::Symbol, delta::Int)
    valor_actual = getfield(planta, campo)
    setfield!(planta, campo, limitar(valor_actual + delta))
    return planta
end

"""
    plantas_iniciales() -> Vector{Planta}

Devuelve el conjunto de plantas con el que inicia el juego:
Spike, Sunny, Rosa, Bonsai y Chompy.
"""
function plantas_iniciales()
    Planta[
        crear_planta("Spike", Cactus(), "Tímido", "Siente que nadie quiere acercarse a él.";
                      felicidad=50, estres=40, energia=60, soledad=70),
        crear_planta("Sunny", Girasol(), "Optimista", "Quiere ayudar a todos y termina agotándose.";
                      felicidad=80, estres=30, energia=40, soledad=20),
        crear_planta("Rosa", Rosa(), "Dramática", "Cree que nadie aprecia su belleza.";
                      felicidad=45, estres=65, energia=55, soledad=50),
        crear_planta("Bonsai", Bonsai(), "Ansioso", "Se preocupa demasiado por crecer correctamente.";
                      felicidad=40, estres=75, energia=50, soledad=40),
        crear_planta("Chompy", PlantaCarnivora(), "Irritable", "Tiene problemas para controlar su mal humor.";
                      felicidad=35, estres=70, energia=80, soledad=60),
    ]
end

end # module Plantas

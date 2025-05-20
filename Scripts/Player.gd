#Esta clase es un singletone, por lo que se puede acceder desde otro script
class_name mainPlayer extends Sprite2D

signal playerReady
signal menuVisibleChange

@onready var inventory : Inventory
@onready var menuBackground : PanelContainer

@onready var assignedPlayer : playerData:
	set(value):
		assignedPlayer = value
		inventory = assignedPlayer.inventory
		menuBackground = assignedPlayer.menuBackground
		emit_signal("playerReady")

#extraContent Cargará una escena personalizada en la interfaz del menú extra, de modo que quede en la capa adecuada
@export var extraContent : PackedScene:
	set(value):
		extraContent = value
		if extraContent == null:
			assignedPlayer.clear_extra_content()
		else:
			assignedPlayer.add_extra_content(extraContent)

"""
@onready var inventory : Inventory:
	set(value):
		inventory = value
		emit_signal("invenoryReady")
"""

#Stats del jugador
var life: int = 100
var energy: int = 100
var hunger: int = 100

#Envía la señal de cambio de visibilidad del menu con el valor 2 a verdadero si hay contenido extra
#Eso significa que se accedió al menú extra desde otra fuente que no es la tecla "I" (abrir inventario)
var extraOpen = false:
	set(value):
		extraOpen = value
		menuVisibleChange.emit(value, extraContent != null)

#Envía la señal de cambio de visibilidad del menu con el valor 2 a falso, porque esta variable llama al menú extra
#para mostrar el inventario
var invOpen = false:
	set(value):
		invOpen = value
		menuVisibleChange.emit(value, false)

#Herramientas del juego (no se rompen ni requieren ser creadas)
var tool_levels = {
	"axe": 1,
	"bucket": 1,
	"fishing_rod": 1,
	"pickaxe" : 1
}

#Método que mejora una de las herramientas
func upgrade_tool(tool_name: String):
	tool_name = tool_name.to_lower()
	if tool_levels.has(tool_name):
		tool_levels[tool_name] += 1
	else:
		push_warning("Intentaste mejorar una herramienta que no existe: %s" % tool_name)

func _process(delta):
	if Input.is_action_just_pressed("inventory") && !extraOpen:
		invOpen = not invOpen

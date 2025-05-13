#Esta clase es un singletone, por lo que se puede acceder desde otro script
class_name mainPlayer extends Sprite2D

@onready var inventory : Inventory = $Inventory

#Stats del jugador
var life: int = 100
var energy: int = 100
var hunger: int = 100

#Herramientas del juego (no se rompen ni requieren ser creadas)
var tool_levels = {
	"axe": 1,
	"bucket": 1,
	"fishing_rod": 1,
	"pickaxe" : 1
}

func _ready():
	#Asigno de forma global la referencia al inventario
	Player.inventory = inventory

#Método que mejora una de las herramientas
func upgrade_tool(tool_name: String):
	tool_name = tool_name.to_lower()
	if tool_levels.has(tool_name):
		tool_levels[tool_name] += 1
	else:
		push_warning("Intentaste mejorar una herramienta que no existe: %s" % tool_name)

func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		inventory.visible = true

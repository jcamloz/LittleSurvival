#Esta clase es un singletone, por lo que se puede acceder desde otro script
class_name mainPlayer extends Sprite2D

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

#Método que mejora una de las herramientas
func upgrade_tool(tool_name: String):
	tool_name = tool_name.to_lower()
	if tool_levels.has(tool_name):
		tool_levels[tool_name] += 1
	else:
		push_warning("Intentaste mejorar una herramienta que no existe: %s" % tool_name)

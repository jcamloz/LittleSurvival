class_name ScenarioController extends Node2D

func _on_axe_button_pressed(tool_name : String):
	if Player.tool_levels.has(tool_name):
		print(tool_name , " level: " , Player.tool_levels[tool_name])
	else:
		print("No existe la herramienta: " , tool_name)

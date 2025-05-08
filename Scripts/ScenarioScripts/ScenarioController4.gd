class_name ScenarioController extends Node2D

@export var lootTable : LootTable

func _on_axe_button_pressed(tool_name : String):
	if Player.tool_levels.has(tool_name):
		print(tool_name , " level: " , Player.tool_levels[tool_name])
	else:
		print("No existe la herramienta: " , tool_name)

	print(Player.inventory.add_item(preload("res://Resources/Items/Madera.tres"), randi_range(1, 3)))#randi_range(1, 3)

func _on_explore_button_pressed():
	var loot = lootTable.get_random_item(Player.tool_levels["axe"])
	if loot != null:
		print("Nombre: " , loot.item.name, ", Cantidad: ", randi_range(1, loot.amount))
	else:
		print("No debiera ocurrir, pero no te ha tocado nada...")
	Player.inventory.add_item(loot.item, randi_range(1, loot.amount))

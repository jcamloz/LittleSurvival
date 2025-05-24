class_name ScenarioController4 extends Node2D

@export var lootTable : LootTable
@onready var chopAnimation = $ChopAnimation
@onready var wood = preload("res://Resources/Items/Madera.tres")

var gainedAmount = 0

func _on_axe_button_pressed(tool_name : String):
	if Player.invOpen == false:
		if !chopAnimation.is_playing():
			print("Pressed")
			chopAnimation.play("Chop")
			await chopAnimation.animation_finished
			gainedAmount = randi_range(1, (3*Player.tool_levels.get(tool_name)))
			Player.inventory.add_item(wood, gainedAmount)
			Player.generate_floating_text(wood.name + " x" + str(gainedAmount))

func _on_explore_button_pressed():
	if Player.invOpen == false:
		var loot = lootTable.get_random_item()
		#Start Debug Info
		if loot == null:
			print("No debiera ocurrir, pero no te ha tocado nada...")
		#End Debug Info
		gainedAmount = randi_range(1, loot.amount)
		Player.inventory.add_item(loot.item, gainedAmount)
		
		Player.generate_floating_text(loot.item.name + " x" + str(gainedAmount))

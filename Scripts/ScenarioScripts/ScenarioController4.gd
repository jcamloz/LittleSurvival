class_name ScenarioController4 extends Node2D

@export var lootTable : LootTable
@onready var chopAnimation = $ChopAnimation
@onready var wood = preload("res://Resources/Items/Madera.tres")

var gainedAmount = 0
var left_amount : int

func _on_axe_button_pressed(tool_name : String):
	if Player.invOpen == false:
		if !chopAnimation.is_playing():
			chopAnimation.play("Chop")
			await chopAnimation.animation_finished
			
			gainedAmount = randi_range(1, (3*Player.tool_levels.get(tool_name)))
			left_amount = Player.inventory.add_item(wood, gainedAmount)
			left_amount = clamp(left_amount, 0, gainedAmount)
			
			if left_amount < gainedAmount:
				Player.generate_floating_text(wood.name + " x" + str(gainedAmount))
			else:
				Player.generate_floating_text("No queda espacio...")

func _on_explore_button_pressed():
	if Player.invOpen == false:
		var loot = lootTable.get_random_item()
		#Start Debug Info
		if loot == null:
			print("No debiera ocurrir, pero no te ha tocado nada...")
		#End Debug Info
		gainedAmount = randi_range(1, loot.amount)
		left_amount = Player.inventory.add_item(loot.item, gainedAmount)
		
		#Ajusto la cantidad mínima que no se a añadido a 0
		left_amount = clamp(left_amount, 0, gainedAmount)
		
		if left_amount < gainedAmount:
			Player.generate_floating_text(loot.item.name + " x" + str(gainedAmount - left_amount))
		else:
			Player.generate_floating_text("No queda espacio...")

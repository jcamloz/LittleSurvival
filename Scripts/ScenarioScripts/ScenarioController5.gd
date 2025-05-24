class_name ScenarioController5 extends Node2D

@export var lootTable : LootTable
@onready var mineAnimation = $MineAnimation

var gainedAmount = 0

func _on_mine_button_pressed(tool_name : String):
	if Player.invOpen == false:
		if !mineAnimation.is_playing():
			mineAnimation.play("Chop")
			await mineAnimation.animation_finished
			var loot = lootTable.get_random_item(Player.tool_levels[tool_name])
			#Start Debug Info
			if loot == null:
				print("No debiera ocurrir, pero no te ha tocado nada...")
			#End Debug Info
			gainedAmount = randi_range(1, loot.amount)
			Player.inventory.add_item(loot.item, gainedAmount)
			Player.generate_floating_text(loot.item.name + " x" + str(gainedAmount))

class_name ScenarioController3 extends Node2D

@export var lootTable : LootTable
@onready var fishingAnimation = $FishingAnimation
@onready var timer = $Timer

var gainedAmount = 0
var isFishing = false
var left_amount : int

func _ready():
	timer.wait_time = 3
	timer.one_shot = true

func _on_fish_button_pressed(tool_name : String):
	if Player.invOpen == false && !isFishing:
		if !fishingAnimation.is_playing():
			isFishing = true
			fishingAnimation.play("StartFishing")
			await fishingAnimation.animation_finished
			
			timer.start()
			await timer.timeout
			
			fishingAnimation.play("EndFishing")
			await fishingAnimation.animation_finished
			
			var loot = lootTable.get_random_item(Player.tool_levels[tool_name])
			#Start Debug Info
			if loot == null:
				print("No debiera ocurrir, pero no te ha tocado nada...")
			#End Debug Info
			gainedAmount = randi_range(1, loot.amount)
			left_amount = Player.inventory.add_item(loot.item, gainedAmount)
			
			left_amount = clamp(left_amount, 0, gainedAmount)
			
			if left_amount < gainedAmount:
				Player.generate_floating_text(loot.item.name + " x" + str(gainedAmount))
			else:
				Player.generate_floating_text("No queda espacio...")
			
			isFishing = false

class_name ScenarioController0 extends Node2D

@onready var hboxContainer = $HBoxContainer

func _ready():
	hboxContainer.visible = false

func hboxToggleVisibility():
	hboxContainer.visible = not hboxContainer.visible

func _on_craft_button_pressed():
	hboxToggleVisibility()

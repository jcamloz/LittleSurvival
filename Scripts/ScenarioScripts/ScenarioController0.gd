class_name ScenarioController0 extends Node2D

@onready var storageMenu = $HBoxContainer
@onready var craftMenu = $CraftMenu

func _ready():
	craftMenu.visible = false
	storageMenu.visible = false

func toggleCraftMenuVisibility():
	craftMenu.visible = not craftMenu.visible

func toggleStorageMenuVisibility():
	storageMenu.visible = not storageMenu.visible

func _on_craft_button_pressed():
	toggleCraftMenuVisibility()

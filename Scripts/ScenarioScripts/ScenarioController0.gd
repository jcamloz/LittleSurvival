class_name ScenarioController0 extends Node2D

@onready var storageMenu = $HBoxContainer
@onready var craftMenu = $CraftMenu

func _ready():
	craftMenu.visible = false
	storageMenu.visible = false
	Player.extraContent = preload("res://Scenes/CraftMenu.tscn")

func toggleStorageMenuVisibility():
	storageMenu.visible = not storageMenu.visible

func _on_craft_button_pressed():
	Player.extraOpen = true

class_name main extends Node2D

@onready var scenario_container = $ScenarioContainer
var current_index = 0
var scenarios = [
	"res://Scenes/Scenarios/Scenario_0.tscn",
	"res://Scenes/Scenarios/Scenario_1.tscn",
	"res://Scenes/Scenarios/Scenario_2.tscn"
]

func _ready():
	load_scenario(current_index)

func load_scenario(index):
	clear_scenario()
	var scene = ResourceLoader.load(scenarios[index])
	if scene is PackedScene:
		var scene_instance = scene.instantiate()
		scenario_container.add_child(scene_instance)
	else:
		print("Error: no se pudo cargar el escenario en el índice ", index)

func clear_scenario():
	for child in scenario_container.get_children():
		child.queue_free()


func _on_left_arrow_pressed():
	if current_index > 0:
		current_index -= 1
		load_scenario(current_index)


func _on_right_arrow_pressed():
	if current_index < scenarios.size() - 1:
		current_index += 1
		load_scenario(current_index)

class_name main extends Node2D

#Referencias al ScenarioContainer
@onready var scenario_container = $ScenarioContainer

#Indice del escenario actual y array con los diferentes escenarios
var current_index = 0
var scenarios = [
	"res://Scenes/Scenarios/Scenario_0.tscn",
	"res://Scenes/Scenarios/Scenario_1.tscn",
	"res://Scenes/Scenarios/Scenario_4.tscn"
]

func _ready():
	load_scenario(current_index)

#Se encarga de cargar el escenario actual
func load_scenario(index):
	#Limpio primero el escenario previo
	clear_scenario()
	#Cargo el escenario actual y compruebo si es un PackedScene para instanciarlo
	var scene = ResourceLoader.load(scenarios[index])
	if scene is PackedScene:
		var scene_instance = scene.instantiate()
		scenario_container.add_child(scene_instance)
	else:
		print("Error: no se pudo cargar el escenario en el índice ", index)

#Destruyo cualquier hijo de ScenarioContainer
func clear_scenario():
	for child in scenario_container.get_children():
		child.queue_free()

#Decremento en 1 el índie del escenario actual y lo cargo
func _on_left_arrow_pressed():
	if current_index > 0:
		current_index -= 1
		load_scenario(current_index)

#Aumento en 1 el índie del escenario actual y lo cargo
func _on_right_arrow_pressed():
	if current_index < scenarios.size() - 1:
		current_index += 1
		load_scenario(current_index)

class_name main extends Node2D

#Referencias al ScenarioContainer
@onready var scenario_container = $ScenarioContainer
@onready var left_arrow = $LeftArrow
@onready var right_arrow = $RightArrow


#Indice del escenario actual y array con los diferentes escenarios
var current_index = 2
var scenarios = [
	"res://Scenes/Scenarios/Scenario_0.tscn",
	"res://Scenes/Scenarios/Scenario_3.tscn",
	"res://Scenes/Scenarios/Scenario_4.tscn",
	"res://Scenes/Scenarios/Scenario_5.tscn"
]

func _ready():
	randomize()
	Player.assignedPlayer = $Player
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
		check_arrow_button_enabled()
	else:
		print("Error: no se pudo cargar el escenario en el índice ", index)

#Destruyo cualquier hijo de ScenarioContainer
func clear_scenario():
	#Le asigno al contenido extra del Player null para limpiarlo
	if Player.extraContent != null:
		Player.extraContent = null
	for child in scenario_container.get_children():
		child.queue_free()

#Decremento en 1 el índie del escenario actual y lo cargo
func _on_left_arrow_pressed():
	if current_index > 0:
		current_index -= 1
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		load_scenario(current_index)

#Aumento en 1 el índie del escenario actual y lo cargo
func _on_right_arrow_pressed():
	if current_index < scenarios.size() - 1:
		current_index += 1
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		load_scenario(current_index)

#Comprueba si los botones de las flechas pueden visualizarse y usarse
#Estarán habilitadas si puedes desplazarte más a la derecha o a la izquierda
func check_arrow_button_enabled():
	if current_index + 1 > scenarios.size()-1:
		right_arrow.visible = false
	else:
		right_arrow.visible = true
	
	if current_index - 1 < 0:
		left_arrow.visible = false
	else:
		left_arrow.visible = true

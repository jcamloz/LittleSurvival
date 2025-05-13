#La escena Transition_screen es un singletone, por lo que es accesible a nivel global
class_name Transition extends CanvasLayer

#Señal que indica que la transición ha terminado
signal on_transition_finished

@onready var fade_screen = $FadeScreen
@onready var fade_animation = $FadeAnimation

func _ready():
	fade_screen.visible = false
	#Realizo un "binding" con el valor "animation_finished" y lo conecto a la función "_on_animation_finished"
	fade_animation.animation_finished.connect(_on_animation_finished)

#Se encarga de transicionar entre fade_in y fade out
func _on_animation_finished(anim_name):
	if anim_name == "fade_in":
		on_transition_finished.emit()
		fade_animation.play("fade_out")
	elif anim_name == "fade_out":
		fade_screen.visible = false

#Comienza la animación y la hace visible
func transition():
	fade_screen.visible = true
	fade_animation.play("fade_in")

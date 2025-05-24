class_name FloatingLabel extends Label

@export var float_distance: float = 100.0
@export var float_duration: float = 1.5
@export var fade_out: bool = true

func _ready():
	var tween = get_tree().create_tween()

	# Mover de abajo hacia arriba
	tween.tween_property(self, "position:y", position.y - float_distance, float_duration)

	# Desvanecer
	if fade_out:
		modulate.a = 1.0
		tween.tween_property(self, "modulate:a", 0.0, float_duration)

	# Cuando termine, destruir
	tween.tween_callback(queue_free)

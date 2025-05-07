class_name Tile_data extends Resource

signal data_changed

@export var item : Item:
	set(value):
		if item != value:
			item = value
			emit_signal("data_changed")

@export_range(0, 999, 1) var amount : int:
	set(value):
		var clamped_value = clamp(value, 0, item.max_stack) if item != null else value
		if amount != clamped_value:
			amount = clamped_value
			emit_signal("data_changed")

func is_empty():
	return amount == 0 || item == null || item.texture == null

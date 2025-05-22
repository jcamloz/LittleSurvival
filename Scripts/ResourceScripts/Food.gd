class_name Food extends Item

@export_range(0, 100, 1) var heal : int
@export_range(0, 100, 1) var hunger_recovery : int
@export var cooked_food : Food = null

func can_cook() -> bool:
	return cooked_food != null

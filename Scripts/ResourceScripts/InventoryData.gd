class_name InventoryData extends Resource

@export var inventoryName = "default"
@export var slots: Array[Tile_data] = []

func ensure_slots():
	#Si una de las casillas no es un Tile_data (entonces es null), le asigna uno
	for i in range(slots.size()):
		if slots[i] == null:
			slots[i] = Tile_data.new()

func debug_print():
	print("Inventario:", inventoryName)
	for i in range(slots.size()):
		var s = slots[i]
		if s != null and s.item != null:
			print("Slot", i, "->", s.item.name, "x", s.amount)
		else:
			print("Slot", i, "-> vacío")

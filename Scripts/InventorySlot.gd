class_name Inventory_slot extends TextureRect

@onready var itemSlot = $ItemSlot
@onready var amountLabel = $Label

signal slot_updated  # DEBUG -> SEÑALA QUE SE HA CAMBIADO UN ITEM DE LUGAR

var focus_texture = preload("res://Assets/PNG/Default/ui_select.png")
var unfocus_texture = preload("res://Assets/PNG/Default/ui_box.png")

var tile_data : Tile_data = null

func set_item(slotData : Tile_data):
	tile_data = slotData
	#ASEGURO QUE AL CARGAR LOS DATOS, EL ARRAY ESTÉ CORRECTO (INCLUSO SI SE CORRIGE SOLO, POR SI ACASO)
	if slotData == null or slotData.is_empty():
		itemSlot.texture = null
	else:
		itemSlot.texture = slotData.item.texture
	update_label()

func update_label():
	if tile_data && tile_data.amount > 0:
		amountLabel.text = str(tile_data.amount)
	else:
		amountLabel.text = ""

func _on_mouse_entered():
	self.texture = focus_texture
	
	#Si hay un item en la casilla, el cursor cambiará al icono del dedo, si no, vuelve a ser la flecha
	if tile_data.item != null:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	else:
		mouse_default_cursor_shape = Control.CURSOR_ARROW

func _on_mouse_exited():
	self.texture = unfocus_texture

# --- DRAG & DROP ---

func _get_drag_data(at_position):
	if tile_data == null or tile_data.item == null:
		return null
	
	var drag_preview = itemSlot.duplicate()
	drag_preview.modulate = Color(1, 1, 1, 0.6)
	set_drag_preview(drag_preview)

	return {
		"tile_data": tile_data,
		"origin_slot": self,
	}

func _can_drop_data(at_position, data):
	return data.has("tile_data") and data["tile_data"] is Tile_data

func _drop_data(at_position, data):
	var incoming = data["tile_data"]
	var origin_slot = data["origin_slot"]

	# Si el slot está vacío, simplemente copia
	if tile_data.item == null:
		tile_data.item = incoming.item
		tile_data.amount = incoming.amount
		incoming.item = null
		incoming.amount = 0

	# Si el mismo tipo de ítem, intenta stackear
	elif tile_data.item == incoming.item:
		var space = tile_data.item.max_stack - tile_data.amount
		if space > 0:
			var to_move = min(space, incoming.amount)
			tile_data.amount += to_move
			incoming.amount -= to_move
			if incoming.amount == 0:
				incoming.item = null
		else:
			# Ambos están llenos, intercambia
			swap_tile_data_with(incoming)


	# Si son distintos, intercambia
	else:
		swap_tile_data_with(incoming)
		
	#DEBUG -> EMITIR SEÑAL AL MOVER UN ITEM DE UN LADO A OTRO
	#emit_signal("slot_updated")
#Intercamia los items entre casillas
func swap_tile_data_with(other_data: Tile_data):
	var temp_item = tile_data.item
	var temp_amount = tile_data.amount

	tile_data.item = other_data.item
	tile_data.amount = other_data.amount

	other_data.item = temp_item
	other_data.amount = temp_amount

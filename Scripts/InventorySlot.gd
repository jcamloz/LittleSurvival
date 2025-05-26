class_name Inventory_slot extends TextureRect

@onready var itemSlot = $ItemSlot
@onready var amountLabel = $Label
@onready var hoverPopUp = $HoverPopUp

signal slot_updated  # DEBUG -> SEÑALA QUE SE HA CAMBIADO UN ITEM DE LUGAR

var mouse_inside = false
var focus_texture = preload("res://Assets/PNG/Default/ui_select.png")
var unfocus_texture = preload("res://Assets/PNG/Default/ui_box.png")

var tile_data : Tile_data = null

#CLICK VALUES
var last_click_time = 0.0
const DOUBLE_CLICK_MAX_DELAY := 0.3

func set_item(slotData : Tile_data):
	tile_data = slotData
	#ASEGURO QUE AL CARGAR LOS DATOS, EL ARRAY ESTÉ CORRECTO (INCLUSO SI SE CORRIGE SOLO, POR SI ACASO)
	if slotData == null or slotData.is_empty():
		itemSlot.texture = null
	else:
		itemSlot.texture = slotData.item.texture
	update_label()
	#Fuerzo la función _on_mouse_entered si el ratón está sobre un item que ha cambiado
	if mouse_inside:
		_on_mouse_entered()

func update_label():
	if tile_data && tile_data.amount > 0:
		amountLabel.text = str(tile_data.amount)
	else:
		amountLabel.text = ""

func _on_mouse_entered():
	var itemSelected = null
	mouse_inside = true
	texture = focus_texture
	#Si hay un item en la casilla, el cursor cambiará al icono del dedo, si no, vuelve a ser la flecha
	if !tile_data.is_empty():
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		#Si el item es comida, muestro un popUp con la información de lo que cura
		if tile_data.item is Food:
			itemSelected = tile_data.item as Food
		else:
			itemSelected = tile_data.item
		hoverPopUp.show_info(itemSelected.name, (("Curación: +" + str(itemSelected.heal) + "\nSaciedad: +" + str(itemSelected.hunger_recovery))) if itemSelected is Food else "")
	else:
		mouse_default_cursor_shape = Control.CURSOR_ARROW
		if hoverPopUp.visible:
			hoverPopUp.hide_info()

func _on_mouse_exited():
	mouse_inside = false
	texture = unfocus_texture
	#Escondo el popUp
	if hoverPopUp.visible:
			hoverPopUp.hide_info()

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

#--- CLICK ---
func _gui_input(event: InputEvent) -> void:
	#Compruebo si es click izquierdo
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#Obtengo el tiempo actual en millis y lo adapto dividiendo entre 1000
		var current_time = Time.get_ticks_msec() / 1000.0
		#Compruebo que el tiempo desde el último click hasta el actual es válido
		if current_time - last_click_time <= DOUBLE_CLICK_MAX_DELAY:
			last_click_time = 0.0
			#Si la casilla clickeada tiene un item Food, lo usa y gasta
			if !tile_data.is_empty() && tile_data.item is Food:
				if Player.hunger < 100 || Player.life < 100:
					Player.eat(tile_data.item as Food)
					tile_data.amount -=1
					print("Hambre player: " , Player.hunger)
		else:
			#Asigno al último click hecho el valor de tiempo actual
			last_click_time = current_time

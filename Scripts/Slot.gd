class_name Slot extends TextureRect

@onready var itemSlot = $ItemSlot
@onready var amountLabel = $Label

var tile_data : Tile_data

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

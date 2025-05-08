class_name Inventory extends PanelContainer

@export var inventory : InventoryData:
	set(value):
		#Si el inventario importado tiene datos, llama a la función ensure_slots()
		if value:
			value.ensure_slots()
		inventory = value

@onready var invGrid = $VBoxContainer2/InventoryGrid
@onready var invNameLabel = $VBoxContainer2/InventoryName
@onready var slot = preload("res://Scenes/inv_slot.tscn")

func _ready():
	if inventory != null:
		invNameLabel.text = inventory.inventoryName
		# Itera a través de los slots del inventario
		for i in range(inventory.slots.size()):
			var item = inventory.slots[i]

			# Conecta la señal 'data_changed' del item a la función '_on_tile_data_changed'
			item.connect("data_changed", Callable(self, "_on_tile_data_changed").bind(i))
			# Instancia el slot visual y lo añáde como hijo
			var slot_instance = slot.instantiate()
			invGrid.add_child(slot_instance)

		# Carga el inventario (asigna las texturas, cantidades, etc.)
		loadInv()

func _on_tile_data_changed(index):
	# Obtiene el hijo (slot) correspondiente y actualiza su visualización
	var child = invGrid.get_child(index)
	child.set_item(inventory.slots[index])

func loadInv():
	# Recorre los hijos (slots) y asigna los datos correspondientes
	for i in invGrid.get_children():
		var slot_data = inventory.slots[i.get_index()]
		i.set_item(slot_data)
		
		#DEBUG -> PARA CONECTAR LA SEÑAR AL MOVER LOS ITEMS DEL INVENTARIO
		#i.connect("slot_updated", Callable(self, "_on_slot_updated"))

#DEBUG -> PARA MOSTRAR EL INVENTARIO AL QUE SE MUEVE EL ITEM
"""
func _on_slot_updated():
	if inventory:
		inventory.debug_print()
"""

#Añade los n items al inventario, excepto que no sea posible
#Devuelve la cantidad sobrante: 
	#negativo si no sobra, sino falta para llegar al máximo
	#positivo si sobra
#Sobra decir que 0 es que se ha añadido todo

func add_item(item : Item, amount : int):
	var index = 0
	var assigned = false
	
	var inv_slot  = null
	#Asigno el sobrante a la cantidad pasada por parámetro de modo que si no añade nada, el sobrante es todo
	var left_amount = amount
	
	while index < inventory.slots.size() && !assigned :
		inv_slot = inventory.slots[index]
		assigned = inv_slot.is_empty() || inv_slot.item == item && inv_slot.amount < item.max_stack
		if assigned:
			#Guardo el sobrante (si es positivo, sobra y por tanto no se ha añadido todo lo que se incicó)
			left_amount = (amount + inv_slot.amount) - item.max_stack
			inv_slot.item = item
			inv_slot.amount += amount
			if left_amount > 0 && left_amount != amount:
				left_amount = add_item(item, left_amount)
		index+=1
	return left_amount

class_name Inventory extends PanelContainer

@export var show : bool = false
@export var inventory : InventoryData:
	set(value):
		#Si el inventario importado tiene datos, llama a la función ensure_slots()
		if value:
			value.ensure_slots()
		inventory = value

@onready var invGrid = $VBoxContainer/InventoryGrid
@onready var invNameLabel = $VBoxContainer/InventoryName
@onready var slot = preload("res://Scenes/inv_slot.tscn")


# Copia de los slots actuales
var saved_slots: Array = []

func _ready():
	#Al crearse será visible o invisible según se haya indicado al crear el inventario
	visible = show
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
		prepareInv()
		#Guardo una copia inicial del inventario
		save_data()
#Guardo el estado actual del inventario
func save_data():
	#Limpio lo que había antes
	saved_slots.clear()
	#Esta variable sirve para guardar el contenido actual del inventario de forma profunda,
	#de modo que no se crearán nuevas instancias de items y por lo tanto el juego funcionará sin problema
	var tile_copy = Tile_data.new()
	
	for slot in inventory.slots:
		tile_copy.item = slot.item
		tile_copy.amount = slot.amount
		#Uso la función duplicate para obtener una copia del item y cantidad sin enlazarlo con el aniguo item ni cantidad
		saved_slots.append(tile_copy.duplicate())

#Función que permite realizar un cargado de datos desde el último guardado
func rollback():
	#En caso de error por culpa del programador (inventario diferente al guardado), se notificará de ello
	if saved_slots.size() != inventory.slots.size():
		push_error("Rollback fallido: El tamaño de los slots no coincide.")
	else:
		#Guardo el item y cantidad uno a uno para mayor seguridad ante enlace de datos
		for i in range(saved_slots.size()):
			inventory.slots[i].item = saved_slots[i].item
			inventory.slots[i].amount = saved_slots[i].amount

func _on_tile_data_changed(index):
	# Obtiene el hijo (slot) correspondiente y actualiza su visualización
	var child = invGrid.get_child(index)
	child.set_item(inventory.slots[index])

func prepareInv():
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

func toggle_visibility():
	visible = not visible

#Añade los n items al inventario, excepto que no sea posible
#Devuelve la cantidad sobrante relativa al máximo del inventario: 
	#negativo si no sobra, sino falta para llegar al máximo
	#positivo si sobra
#Sobra decir que 0 es que se ha ocupado el 100% del espacio

func add_item(item: Item, amount: int):
	var index = search_next_free_item(item)
	var inv_slot = null
	#Asigno el sobrante a la cantidad pasada por parámetro de modo que si no añade nada, el sobrante es todo
	var left_amount = amount
	
	if index > -1:
		inv_slot = inventory.slots[index]
		#Guardo el sobrante (si es positivo, sobra y por tanto no se ha añadido todo lo que se incicó)
		left_amount = (amount + inv_slot.amount) - item.max_stack
		
		inv_slot.amount += amount
		if left_amount > 0 && left_amount != amount:
			left_amount = add_item(item, left_amount)
	else:
		left_amount = add_new_item(item, amount)
	return left_amount

func add_new_item(item: Item, amount: int):
	var index = 0
	var assigned = false
	var inv_slot = null
	#Asigno el sobrante a la cantidad pasada por parámetro de modo que si no añade nada, el sobrante es todo
	var left_amount = amount
	
	while !assigned && index < inventory.slots.size():
		inv_slot = inventory.slots[index]
		assigned = inv_slot.is_empty()
		if assigned:
			left_amount = (amount + inv_slot.amount) - item.max_stack
			inv_slot.item = item
			inv_slot.amount += amount
			if left_amount > 0 && left_amount != amount:
				left_amount = add_item(item, left_amount)
		index+=1
	return left_amount

#Devuelve la cantidad que no ha podido borrar de todo lo indicado
#Ejemplo, se pide borrar 4 elementos pero solo se han podido borrar 2, devuelve -2
#Eso no significa que no queden en el inventario, solo indica lo que falta por borrar de lo indicado
func remove_item(item: Item, amount: int):
	var index = search_item(item)
	var inv_slot = null
	
	#left_amount en esta función representa la cantidad a eliminar restante, no lo que queda de ese item en el inventario
	var left_amount = amount
	
	if index > -1:
		inv_slot = inventory.slots[index]
		left_amount = (amount - inv_slot.amount)
		
		inv_slot.amount -= amount
		if left_amount > 0 && left_amount != amount:
			left_amount = remove_item(item, left_amount)
	return left_amount

#Función que busca un ítem con espacio disponible para almacenar más
func search_next_free_item(item: Item) -> int:
	var item_index = -1
	
	#Empiezo a buscar desde la primera aparición del item en el inventario
	var index = search_item(item)
	var found = false
	var inv_slot = null
	
	if index > -1:
		while !found && index < inventory.slots.size():
			inv_slot = inventory.slots[index]
			#Contará como encontrado y válido si el item es igual y le queda al menos 1 espacio libre
			found = !inv_slot.is_empty() && inv_slot.item == item && inv_slot.amount < item.max_stack
			if found:
				item_index = index
			index+=1
		
	return item_index

#Función que permite buscar en el inventario el item deseado
func search_item(item: Item) -> int:
	var item_index = -1
	
	var found = false
	var index = 0
	var inv_slot = null
	
	while !found && index < inventory.slots.size():
		inv_slot = inventory.slots[index]
		
		found = !inv_slot.is_empty() && inv_slot.item == item
		if found:
			item_index = index
		
		index+=1
	
	return item_index

#Función que devuelve la cantidad que hay de un item
func get_amount(item: Item):
	var amount = 0
	var index = search_item(item)
	var inv_slot = null
	
	if index > -1:
		while index < inventory.slots.size():
			inv_slot = inventory.slots[index]
			if !inv_slot.is_empty() && inv_slot.item == item:
				amount+=inv_slot.amount
			index+=1
	return amount

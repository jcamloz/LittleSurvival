class_name ItemCraft extends Resource

@export var craftedItem: Tile_data
@export var itemsNeeded: Array[Tile_data] = []

#Determino si puede crear un item o no a partir de un inventario
func can_craft(inventory: Inventory) -> bool:
	var canCraft = true
	var requiredItem = null
	var index = 0
	
	#Primero, compruebo que tiene los items suficientes para crear el item
	while(index < itemsNeeded.size() && canCraft):
		requiredItem = itemsNeeded[index]
		canCraft = inventory.get_amount(requiredItem.item) >= requiredItem.amount
		index += 1
	
	#Después, si tiene los items necesarios hago un intento de fabricación y si es exitosa, canCraft será true
	if canCraft:
		#Guardo el estado del inventario
		inventory.save_data()
		#Elimino los items requeridos
		for itemNeeded in itemsNeeded:
			inventory.remove_item(itemNeeded.item, itemNeeded.amount)
		#Añado y compruebo que se ha podido añadir el item a crear
		canCraft = inventory.add_item(craftedItem.item, craftedItem.amount)<=0
		#Realizo un rollback
		inventory.rollback()
	
	return canCraft

#Esta función crea el item y gasta los necesarios solo si es posible
func craft(inventory: Inventory) -> bool:
	var canCraft = can_craft(inventory)
	if canCraft:
		for required in itemsNeeded:
			inventory.remove_item(required.item, required.amount)
		inventory.add_item(craftedItem.item, craftedItem.amount)
	return canCraft

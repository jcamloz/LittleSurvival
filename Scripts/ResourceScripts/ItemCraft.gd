class_name ItemCraft extends Resource

@export var craftedItem: Tile_data
@export var itemsNeeded: Array[Tile_data] = []

func can_craft(inventory: Inventory) -> bool:
	for required in itemsNeeded:
		if inventory.get_amount(required.item)==0:
			return false
	return true


func craft(inventory: Inventory) -> bool:
	if can_craft(inventory):
		for required in itemsNeeded:
			inventory.remove_item(required.item, required.amount)
		inventory.add_item(craftedItem.item, craftedItem.amount)
		return true
	return false

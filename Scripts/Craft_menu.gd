class_name CraftMenu extends PanelContainer

@onready var itemList = $HBoxContainer/VBoxContainer/ItemList
@onready var gridIngredients = $HBoxContainer/VBoxContainer2/GridIngredients
@onready var craftResultSlot = $HBoxContainer/VBoxContainer2/Slot
@onready var itemSlot = preload("res://Scenes/slot.tscn")

@export var itemCraftList : ItemCraftList
var craftRecipes : Array[ItemCraft] = []

func _ready():
	if itemCraftList != null && itemCraftList.itemCraft != null && !itemCraftList.itemCraft.is_empty():
		craftRecipes = itemCraftList.itemCraft
		for craft in craftRecipes:
			itemList.add_item(craft.craftedItem.item.name)
	itemList.select(0)
	load_recipe(craftRecipes[0])


func _on_item_list_item_selected(index):
	load_recipe(craftRecipes[itemList.get_selected_items()[0]])

func load_recipe(craftRecipe : ItemCraft):
	craftResultSlot.set_item(craftRecipe.craftedItem)
	clear_grid_container()
	for itemNeeded in craftRecipe.itemsNeeded:
		var slotInstance : Slot = itemSlot.instantiate()
		gridIngredients.add_child(slotInstance)
		slotInstance.set_item(itemNeeded)
	print(craftRecipe.can_craft($HBoxContainer/VBoxContainer2/InventoryContainer))

func clear_grid_container():
	for child in gridIngredients.get_children():
		child.queue_free()

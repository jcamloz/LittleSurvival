class_name CraftMenu extends PanelContainer

#Componentes visuales de esta escena:
	#itemList = Para los nombres de crafteos
	#gridIngredients = Cuadrícula para mostrar los ingredientes
	#craftResultSlot = Slot cuadrado para mostrar el resultado
	#craftButton = Para crear el item si es posible
@onready var itemList = $HBoxContainer/VBoxContainer/ItemList
@onready var gridIngredients = $HBoxContainer/VBoxContainer2/GridIngredients
@onready var craftResultSlot = $HBoxContainer/VBoxContainer2/Slot
@onready var craftButton = $HBoxContainer/VBoxContainer2/CraftButton

#Escena del slot para reutilizar
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
	
	craftButton.disabled = !craftRecipe.can_craft(Player.inventory)

func clear_grid_container():
	for child in gridIngredients.get_children():
		child.queue_free()

func _on_craft_button_pressed():
	var craftRecipe = craftRecipes[itemList.get_selected_items()[0]]
	craftRecipe.craft(Player.inventory)
	craftButton.disabled = !craftRecipe.can_craft(Player.inventory)


func _on_close_button_pressed():
	Player.extraOpen = false

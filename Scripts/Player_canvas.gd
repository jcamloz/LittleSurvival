class_name playerData extends AnimatedSprite2D

#Esto es el script de los datos del contenido del player pintado en la pantalla
#Cargará solo los datos del player, así como un menú extra para realizar ciertas acciones, como los crafteos o el almacén

@onready var menuBackground = $MenuCanvas/MenuBackground
@onready var extraContent = $MenuCanvas/MenuBackground/ExtraContent
@onready var inventory = $MenuCanvas/MenuBackground/Inventory

#Enlazo la señal "menuVisibleChange" con la función "_on_menu_background_change"
func _ready():
	Player.menuVisibleChange.connect(_on_menu_background_change)

#Esta función recibe dos parámetros: menuOpen y extraOpen
#Cuando menuOpen es true, se abre el menú.
#Si extraOpen es falso, cuando se abra el menú se mostrará el inventario
#Si extraOpen es verdadero, cuando se abra el menú se mostrará la escena añadida
func _on_menu_background_change(menuOpen : bool, extraOpen : bool):
	print(menuOpen, " | ",extraOpen)
	menuBackground.visible = menuOpen
	extraContent.visible = extraOpen
	if !extraOpen:
		inventory.toggle_visibility()

#Añade una escena extra
func add_extra_content(extraScene : PackedScene):
	#clear_extra_content()
	extraContent.add_child(extraScene.instantiate())

#Limpia cualquier escena extra
func clear_extra_content():
	for child in extraContent.get_children():
		child.queue_free()

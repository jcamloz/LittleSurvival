class_name playerData extends AnimatedSprite2D

#Esto es el script de los datos del contenido del player pintado en la pantalla
#Cargará solo los datos del player, así como un menú extra para realizar ciertas acciones, como los crafteos o el almacén

@onready var menuBackground = $MenuCanvas/MenuBackground
@onready var extraContent = $MenuCanvas/MenuBackground/ExtraContent
@onready var inventory = $MenuCanvas/MenuBackground/Inventory

#ProgressBars
@onready var healthBar = $HealthBar
@onready var healthLabel = $HealthBar/HealthLabel

@onready var hungerBar = $HungerBar
@onready var hungerLabel = $HungerBar/HungerLabel

@onready var energyBar = $EnergyBar
@onready var energyLabel = $EnergyBar/EnergyLabel

var label_scene = preload("res://Scenes/Floating_label.tscn")

#Enlazo la señal "menuVisibleChange" con la función "_on_menu_background_change"
func _ready():
	Player.menuVisibleChange.connect(_on_menu_background_change)
	#Conecto las señales de cambio en las estadísticas del jugador con las barras que representan dichas estadísticas
	Player.connect("healthChanged", health_bar_update)
	Player.connect("hungerChanged", hunger_bar_update)
	Player.connect("energyChanged", energy_bar_update)
	#Actualizo por primera vez las barras de progreso
	health_bar_update()
	hunger_bar_update()
	energy_bar_update()

#Esta función recibe dos parámetros: menuOpen y extraOpen
#Cuando menuOpen es true, se abre el menú.
#Si extraOpen es falso, cuando se abra el menú se mostrará el inventario
#Si extraOpen es verdadero, cuando se abra el menú se mostrará la escena añadida
func _on_menu_background_change(menuOpen : bool, extraOpen : bool):
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

func generate_floating_text(text : String):
	var label = label_scene.instantiate()
	label.text = text
	add_child(label)

func health_bar_update():
	healthBar.value = Player.life
	healthLabel.text = str(healthBar.value as int)

func hunger_bar_update():
	hungerBar.value = Player.hunger
	hungerLabel.text = str(hungerBar.value as int)

func energy_bar_update():
	energyBar.value = Player.energy
	energyLabel.text = str(energyBar.value as int)

class_name HoverPopUp extends CanvasLayer

@onready var hoverPopUpContainer = $HoverPopUpContainer
@onready var labelTitle = $HoverPopUpContainer/VBoxContainer/LableTitle
@onready var labelDesc = $HoverPopUpContainer/VBoxContainer/LabelDescription

func show_info(title: String, desc: String):
	labelTitle.text = title
	labelDesc.text = desc
	
	labelTitle.visible = !title.is_empty()
	labelDesc.visible = !desc.is_empty()
	
	visible = true

func hide_info():
	visible = false

func _process(_delta):
	if visible:
		var mouse_pos = get_viewport().get_mouse_position()
		hoverPopUpContainer.global_position = mouse_pos + Vector2(12, 12)

extends HBoxContainer

@onready var checked = preload("res://pause_menu/textures/checked.png")

func complete():
	$Checkbox.texture = checked

func burnt_out():
	modulate.a = .2

extends Control
class_name PauseMenu

@onready var menu_interact_sound_player : AudioStreamPlayer = $menu_interact

func _ready():
	get_tree().paused = true

func _input(event):
	if event.is_action_pressed("interact"):
		get_tree().paused = false
		visible = false

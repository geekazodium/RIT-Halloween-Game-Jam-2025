extends Control

func _ready() -> void:
	get_tree().paused = true

func _input(event):
	if event.is_action_pressed("interact"):
		get_tree().paused = false
		visible = false

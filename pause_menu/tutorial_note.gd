extends Control


func _input(event):
	if event.is_action_pressed("interact"):
		get_tree().paused = false
		visible = false

extends Control
var can_click = false
func _input(event):
	if can_click and event.is_action_pressed("interact"):
		get_tree().change_scene_to_file("res://menu/menu.tscn")

func _on_timer_timeout() -> void:
	can_click = true

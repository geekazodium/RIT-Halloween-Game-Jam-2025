extends Control
class_name PauseMenu

@export var pause_menu: Control

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pause_menu.visible = !pause_menu.visible;

func _on_resume_pressed() -> void:
	pause_menu.visible = false;

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/menu.tscn");

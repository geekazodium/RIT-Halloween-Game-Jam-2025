extends Control
class_name PauseMenu

@export var pause_menu: Control
@export var resume_image: TextureRect
@export var exit_image: TextureRect
var unchecked = load("res://pause_menu/textures/unchecked.png")
var checked = load("res://pause_menu/textures/checked.png")

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pause_menu.visible = !pause_menu.visible;

func _on_resume_pressed() -> void:
	pause_menu.visible = false;

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/menu.tscn");

func _on_resume_mouse_entered() -> void:
	resume_image.texture = checked

func _on_resume_mouse_exited() -> void:
	resume_image.texture = unchecked

func _on_quit_mouse_entered() -> void:
	exit_image.texture = checked

func _on_quit_mouse_exited() -> void:
	exit_image.texture = unchecked

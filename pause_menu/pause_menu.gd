extends Control
class_name PauseMenu

@onready var menu_interact_sound_player : AudioStreamPlayer = $menu_interact
@onready var button_click_sound_player : AudioStreamPlayer = $button_sound

@export var pause_menu: Control
@export var resume_image: TextureRect
@export var exit_image: TextureRect
var unchecked = load("res://pause_menu/textures/unchecked.png")
var checked = load("res://pause_menu/textures/checked.png")

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pause_menu.visible = !pause_menu.visible;
		get_tree().paused = pause_menu.visible
	

func _on_resume_pressed() -> void:
	button_click_sound_player.play()
	pause_menu.visible = false;
	get_tree().paused = false;

func _on_quit_pressed() -> void:
	button_click_sound_player.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false;
	get_tree().change_scene_to_file("res://menu/menu.tscn");

func _on_resume_mouse_entered() -> void:
	menu_interact_sound_player.play()
	resume_image.texture = checked

func _on_resume_mouse_exited() -> void:
	resume_image.texture = unchecked

func _on_quit_mouse_entered() -> void:
	menu_interact_sound_player.play()
	exit_image.texture = checked

func _on_quit_mouse_exited() -> void:
	exit_image.texture = unchecked

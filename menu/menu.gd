extends Control
class_name Menu

@onready var button_click_sound_player : AudioStreamPlayer = $button_sound

@export var options_menu: Control
@export var main_menu: VBoxContainer
@export var title: TextureRect

var starting_position: Vector2

func _ready():
	starting_position = title.position;

func _on_options_pressed() -> void:
	main_menu.visible = false;
	options_menu.visible = true;

func _on_quit_pressed() -> void:
	button_click_sound_player.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit();

func _on_back_pressed() -> void:
	main_menu.visible = true;
	options_menu.visible = false;


func _on_play_pressed() -> void:
	button_click_sound_player.play()
	get_tree().change_scene_to_file("res://main.tscn")

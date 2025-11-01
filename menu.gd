extends Control

@export var options_menu: Control
@export var main_menu: VBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_options_pressed() -> void:
	main_menu.visible = false;
	options_menu.visible = true;


func _on_quit_pressed() -> void:
	get_tree().quit();


func _on_back_pressed() -> void:
	main_menu.visible = true;
	options_menu.visible = false;

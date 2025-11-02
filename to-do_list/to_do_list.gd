extends Control

@export var roommate_node_path: NodePath
@export var vertical_container: VBoxContainer

@onready var task_display_scene = preload("res://to-do_list/task_display.tscn")
@onready var manager = get_node(roommate_node_path).get_node("RoommateTaskManager");
@onready var wash_dishes = load("res://to-do_list/textures/to_do_wash_dishes.png")
@onready var take_out_trash = load("res://to-do_list/textures/to_do_toss_trash.png")
@onready var brush_teeth = load("res://to-do_list/textures/to_do_brush_teeth.png")
@onready var pack_lunch = load("res://to-do_list/textures/to_do_pack_lunch.png")
@onready var carve_pumpkin = load("res://to-do_list/textures/to_do_carve_pumpkin.png")

func _ready() -> void:
	var task_dict = {"plate":wash_dishes, "trash":take_out_trash, "toothbrush":brush_teeth, "lunchbag":pack_lunch, "pumpkin":carve_pumpkin}
	
	for task in manager.tasks:
		var task_display = task_display_scene.instantiate();
		task_display.get_child(1).texture = task_dict.get(str(task.item_needed));
		print(pack_lunch)
		print(task_dict.get(str(task.item_needed)));
		print(typeof(str(task.item_needed)), str(task.item_needed) == task.item_needed)

		vertical_container.add_child(task_display);

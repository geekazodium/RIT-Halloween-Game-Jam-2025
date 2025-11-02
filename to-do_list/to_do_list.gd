extends Control

@export var roommate_node_path: NodePath
@export var player_node_path: NodePath
@export var vertical_container: VBoxContainer

@onready var task_display_scene = preload("res://to-do_list/task_display.tscn")
@onready var player = get_node(player_node_path);
@onready var manager = get_node(roommate_node_path);
@onready var wash_dishes = load("res://to-do_list/textures/to_do_wash_dishes.png")
@onready var take_out_trash = load("res://to-do_list/textures/to_do_toss_trash.png")
@onready var brush_teeth = load("res://to-do_list/textures/to_do_brush_teeth.png")
@onready var pack_lunch = load("res://to-do_list/textures/to_do_pack_lunch.png")
@onready var carve_pumpkin = load("res://to-do_list/textures/to_do_carve_pumpkin.png")

func _ready() -> void:
	
	if manager == null: 
		return
	manager = manager.get_node("RoommateTaskManager")
	
	var task_dict = {"plate":wash_dishes, "trash":take_out_trash, "toothbrush":brush_teeth, "lunchbag":pack_lunch, "pumpkin":carve_pumpkin}
	
	for task in manager.tasks:
		var task_display = task_display_scene.instantiate();
		task_display.get_child(1).texture = task_dict.get(str(task.item_needed));
		vertical_container.add_child(task_display);
	
	manager.task_status_updated.connect(_on_task_status_updated)

func _on_task_status_updated(index: int, status: RoommateTask.TaskStatus) -> void:
	if status == RoommateTask.TaskStatus.COMPLETE and $VBoxContainer.get_child_count() > index:
		$VBoxContainer.get_child(index).complete()
	elif status == RoommateTask.TaskStatus.GAVE_UP:
		$VBoxContainer.get_child(index).burnt_out()
	
func _process(_delta):
	var camera = get_viewport().get_camera_3d()
	if camera:
		var screen_pos = camera.unproject_position(player.global_position)
		
		var ui_rect = get_global_rect()
		if ui_rect.has_point(screen_pos):
			modulate.a = lerp(modulate.a, 0.3, 0.2) # fade
		else:
			modulate.a = lerp(modulate.a, 1.0, 0.2) # restore
	
	

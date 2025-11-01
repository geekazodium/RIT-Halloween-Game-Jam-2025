extends Node
class_name Room

@export var containers : Array[ItemContainer];

@export var camera_z_relative : float
@export var camera_y_relative : float
@export var camera_fov : float
@export var camera_x_rotation : float

func _enter_tree() -> void:
	WorldRooms.room_enter_tree.call_deferred(self);

func _exit_tree() -> void:
	WorldRooms.room_exit_tree(self);

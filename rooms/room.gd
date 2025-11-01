@tool
extends Node3D
class_name Room

@export var containers : Array[ItemContainer];

@export var size : Vector3 = Vector3(2,2,2)
var check_size : Vector3

var faces : Array

@export var door1_active : bool = false
@export var door2_active : bool = false
@export var door3_active : bool = false

@onready var collider_shape : CollisionShape3D = $StaticBody3D/CollisionShape3D
@onready var combiner :CSGCombiner3D = $CSGCombiner3D
@onready var camera : Camera3D = $Camera3D

var doors : Array

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		return;
	WorldRooms.room_enter_tree.call_deferred(self);

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		return;
	WorldRooms.room_exit_tree(self);

func _ready() -> void:
	if Engine.is_editor_hint():
		check_size = size
		faces.resize(5)
		faces[0] = $CSGCombiner3D/floor
		faces[1] = $CSGCombiner3D/wall1
		faces[2] = $CSGCombiner3D/wall2
		faces[3] = $CSGCombiner3D/wall3
		faces[4] = $CSGCombiner3D/wall4
		doors.resize(3)
		doors[0] = $CSGCombiner3D/door1
		doors[1] = $CSGCombiner3D/door2
		doors[2] = $CSGCombiner3D/door3
		doors[0].size = Vector3(1.1,1.5,0.1)
		doors[1].size = Vector3(1.1,1.5,0.1)
		doors[2].size = Vector3(1.1,1.5,0.1)
		doors[0].operation = 2
		doors[1].operation = 2
		doors[2].operation = 2
		resize()
	else:
		faces.resize(5)
		faces[0] = $CSGCombiner3D/floor
		faces[1] = $CSGCombiner3D/wall1
		faces[2] = $CSGCombiner3D/wall2
		faces[3] = $CSGCombiner3D/wall3
		faces[4] = $CSGCombiner3D/wall4
		doors.resize(3)
		doors[0] = $CSGCombiner3D/door1
		doors[1] = $CSGCombiner3D/door2
		doors[2] = $CSGCombiner3D/door3
		doors[0].size = Vector3(1.1,1.5,0.1)
		doors[1].size = Vector3(1.1,1.5,0.1)
		doors[2].size = Vector3(1.1,1.5,0.1)
		doors[0].operation = 2
		doors[1].operation = 2
		doors[2].operation = 2
		resize()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if size != check_size:
			print("resizing")
			check_size = size
			resize()

func resize():
	faces[0].position = Vector3(0,-size.y/2,0)
	faces[1].position = Vector3(size.x/2,0,0)
	faces[2].position = Vector3(-size.x/2,0,0)
	faces[3].position = Vector3(0,0,size.z/2)
	faces[4].position = Vector3(0,0,-size.z/2)
	
	faces[0].size = Vector3(size.z, 0.01, size.x)
	faces[1].size = Vector3(0.01, size.z, size.y)
	faces[2].size = Vector3(0.01, size.z, size.y)
	faces[3].size = Vector3(size.x, size.y, 0.01)
	faces[4].size = Vector3(size.x, size.y, 0.01)
	
	faces[0].rotation = Vector3(0,PI/2,0)
	faces[1].rotation = Vector3(PI/2,0,0)
	faces[2].rotation = Vector3(-PI/2,0,0)
	faces[3].rotation = Vector3(0,0,0)
	faces[4].rotation = Vector3(0,0,0)
	
	if door1_active:
		doors[0].position = Vector3(-size.x/2, (1.5-size.y)/2+0.005, 0)
		doors[0].rotation = Vector3(0,PI/2,0)
		doors[0].visible = true
	else:
		doors[0].visible = false
	
	if door2_active:
		doors[1].position = Vector3(0, (1.5-size.y)/2+0.005, -size.z/2)
		doors[1].visible = true
	else:
		doors[1].visible = false
	
	if door3_active:
		doors[2].position = Vector3(size.x/2, (1.5-size.y)/2+0.005,0)
		doors[2].rotation = Vector3(0,PI/2,0)
		doors[2].visible = true
	else:
		doors[2].visible = false
	
	faces[3].visible = true
	collider_shape.shape = combiner.bake_collision_shape()
	faces[3].visible = false

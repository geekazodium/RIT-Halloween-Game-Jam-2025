@tool
extends Node3D
class_name Room

@export var containers : Array[ItemContainer];

@export var size : Vector3 = Vector3(2,2,2)
var check_size : Vector3

var faces : Array

@export_category("doors")
@export var door1_active : bool = false
@export var door2_active : bool = false
@export var door3_active : bool = false

@export_category("textures")
@export var floor_texture : StandardMaterial3D
@export var wall1_texture : StandardMaterial3D
@export var wall2_texture : StandardMaterial3D
@export var wall3_texture : StandardMaterial3D

@onready var collider_shape : CollisionShape3D = $StaticBody3D/CollisionShape3D
@onready var combiner :CSGCombiner3D = $CSGCombiner3D
var camera : Camera3D

var area_shape : CollisionShape3D

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
		area_shape = $Area3D/CollisionShape3D
		area_shape.shape = BoxShape3D.new()
		resize()
		
		for child in get_children():
			if child is Camera3D:
				camera = child
				break
	

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if size != check_size:
			check_size = size
			resize()

func resize():
	print("resizing")
	
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
		
	area_shape.shape.size = size
	
	faces[3].visible = true
	collider_shape.shape = combiner.bake_collision_shape()
	faces[3].visible = false
	
	if floor_texture != null:
		floor_texture.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		faces[0].material = floor_texture
	if wall1_texture != null:
		faces[1].material = wall1_texture
	if wall2_texture != null:
		faces[2].material = wall2_texture
	if wall3_texture != null:
		faces[4].material = wall3_texture


func _on_area_3d_body_entered(body: Node3D) -> void:
	if camera != null:
		camera.make_current()

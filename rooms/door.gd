extends Area3D

@export var room_1 : Room
@export var room_2 : Room

func _on_body_entered(body: Node3D) -> void:
	if room_1.camera.current:
		room_2.camera.make_current()
	else:
		room_1.camera.make_current()

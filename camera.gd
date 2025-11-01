extends Camera3D

func move_to_room(room_x : float, room_y : float, room_z : float, relative_x : float, relative_y :float, relative_z : float, angle : float, fov : float):
	position = Vector3(room_x + relative_x, room_y + relative_y, room_z + relative_z)
	rotation.x = angle
	self.fov = fov

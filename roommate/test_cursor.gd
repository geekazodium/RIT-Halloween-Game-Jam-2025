extends Node3D
class_name TestCursor

@export var plane: Vector4 = Vector4(0,1,0,0);
var plane_norm: Vector3:
	get:
		return Vector3(
			plane.x,plane.y,plane.z
		)
var plane_point: Vector3:
	get: 
		return plane_norm * plane.z;

func _physics_process(_delta: float) -> void:
	var camera: Camera3D = self.get_viewport().get_camera_3d();
	var screen_pos: Vector2 = camera.get_viewport().get_mouse_position();
	## calculate ray direction using 2 points projected at different depths, this will account for how the camera projection is set up
	var ray_start: Vector3 = camera.project_position(screen_pos, 0.);
	var ray_dir: Vector3 = camera.project_position(screen_pos, 10.) - ray_start;
		
	var ray_length = self.plane_norm.dot(self.plane_point - ray_start) / self.plane_norm.dot(ray_dir);
	var point = ray_start + ray_dir * ray_length;
	self.global_position = point;

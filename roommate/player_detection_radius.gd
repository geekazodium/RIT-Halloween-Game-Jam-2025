extends Area3D
class_name PlayerDetectionRadius

@export_range(0, 180, 0.001, "radians_as_degrees") var vision_angle_range: float = PI/4;
@export var direction_src: UMCharacterBody3D;

func _physics_process(_delta: float) -> void:
	var facing: Vector2 = direction_src.last_nonzero_input_dir.normalized();
	var dot_prod_tolerance: float = cos(self.vision_angle_range);
	
	for body:PhysicsBody3D in self.get_overlapping_bodies():
		## uncomment when player type exists
		#if !body is player: return;
		var delta_position: Vector3 = body.global_position - self.global_position;
		var offset_x_z: Vector2 = Vector2(delta_position.x,delta_position.z).normalized();
		var dot: float = offset_x_z.dot(facing);
		if dot < dot_prod_tolerance:
			continue;
		print("shape detected");
	pass;

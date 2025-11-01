extends WishDirection
class_name RoommateWishDir

@export var nav_agent: NavigationAgent3D
@export var current_position_node: Node3D;
@export var target: Node3D;
@export var distance_tolerance: float = 5;

var direction_vec: Vector2 = Vector2.RIGHT;

func _physics_process(delta: float) -> void:
	self.nav_agent.target_position = target.global_position;
	var position: Vector3 = self.nav_agent.get_next_path_position();
	if self.nav_agent.get_path_length() <= distance_tolerance:
		self.direction_vec = Vector2.ZERO;
		self._physics_process_in_range(delta);
		return;
	position -= self.current_position_node.global_position;
	self.direction_vec = Vector2(position.x, position.z).normalized();

func _physics_process_in_range(_delta: float) -> void:
	pass;
	
func get_input_xz() -> Vector2:
	return self.direction_vec;

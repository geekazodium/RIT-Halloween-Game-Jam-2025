extends WishDirection
class_name RoommateWishDir

@export var nav_agent: NavigationAgent3D
@export var current_position_node: Node3D;
var target: Node3D:
	set(value):
		if target != value:
			target_position_dirty = true;
		target = value;
var target_position_dirty: bool = true;
@export var distance_tolerance: float = 5;

var is_in_range: bool:
	get:
		if self.target_position_dirty:
			return false;
		if self.nav_agent.get_current_navigation_path().size() == 0:
			return false;
		return self.nav_agent.get_path_length() <= distance_tolerance;

var direction_vec: Vector2 = Vector2.RIGHT;

signal physics_process_in_range(delta: float);

func _physics_process(delta: float) -> void:
	if self.target != null:
		self.nav_agent.target_position = target.global_position;
	var position: Vector3 = self.nav_agent.get_next_path_position();
	self.target_position_dirty = false;
	if self.is_in_range:
		self.direction_vec = Vector2.ZERO;
		self.physics_process_in_range.emit(delta);
		return;
	position -= self.current_position_node.global_position;
	self.direction_vec = Vector2(position.x, position.z).normalized();
	
func get_input_xz() -> Vector2:
	return self.direction_vec;

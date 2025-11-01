extends WishDirection
class_name PlayerWishDir

var direction_vec: Vector2 = Vector2.ZERO;

func _physics_process(_delta: float) -> void:
	self.direction_vec = Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _physics_process_in_range(_delta: float) -> void:
	pass;

func get_input_xz() -> Vector2:
	return self.direction_vec;

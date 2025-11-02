extends WishDirection
class_name PlayerWishDir

var direction_vec: Vector2 = Vector2.ZERO;

func _process(_delta):
	self.direction_vec = Input.get_vector("move_left", "move_right", "move_up", "move_down").rotated(-get_parent().rotation.y);


func get_input_xz() -> Vector2:
	if (self.get_parent() as Player).interacting:
		return Vector2.ZERO;
	return self.direction_vec;

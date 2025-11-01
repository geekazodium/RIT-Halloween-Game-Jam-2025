extends WishDirection
class_name PlayerWishDir

@export var sprite: AnimatedSprite3D

var direction_vec: Vector2 = Vector2.ZERO;
var held_item: Item = null
var looking_forward = true

func _physics_process(_delta: float) -> void:
	self.direction_vec = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction_vec.y == 1:
		looking_forward = true
	elif direction_vec.y == -1:
		looking_forward = false
	
	if direction_vec.x == 1:
		sprite.flip_h = true
	elif direction_vec.x == -1:
		sprite.flip_h = false
	
	var animation = ""
	if held_item != null:
		animation = "holding_"
	
	if(direction_vec == Vector2.ZERO):
		animation += "standing_"
	else:
		animation += "walking_"
	
	if(looking_forward):
		animation += "front"
	else: 
		animation += "back"
	
	sprite.play(animation)

func _physics_process_in_range(_delta: float) -> void:
	pass;

func get_input_xz() -> Vector2:
	return self.direction_vec;

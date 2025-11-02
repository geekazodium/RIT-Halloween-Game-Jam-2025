extends UMCharacterBody3D
class_name RoommateCharacterBody

## gets how suspicious of the player the roommate is
var suspicion: float:
	get:
		return _player_detection.suspicion;

@onready var _player_detection: PlayerDetectionRadius = $PlayerDetection3D;

@export var ideal_speed: float = 5;
@export var input_force_strength: float = 10;

@export var sprite: AnimatedSprite3D;
var looking_forward: bool = false;

var held_item: Item;

func _get_ideal_speed() -> float:
	return self.ideal_speed;

func _get_input_force_strength() -> float:
	return self.input_force_strength;

func _physics_process(delta: float) -> void:
	super._physics_process(delta);
	var direction_vec: Vector2 = self.movement_direction.get_input_xz().rotated(self.rotation.y);
	
	if sign(direction_vec.y) == 1:
		looking_forward = true;
	elif sign(direction_vec.y) == -1:
		looking_forward = false;
	
	if sign(direction_vec.x) == 1:
		sprite.flip_h = true;
	elif sign(direction_vec.x) == -1:
		sprite.flip_h = false;
	
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
	
	sprite.play(animation);

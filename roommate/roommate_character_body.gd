extends UMCharacterBody3D
class_name RoommateCharacterBody

## gets how suspicious of the player the roommate is
var suspicion: float:
	get:
		return _player_detection.suspicion;

@onready var _player_detection: PlayerDetectionRadius = $PlayerDetection3D;

@export var ideal_speed: float = 5;
@export var input_force_strength: float = 10;

func _get_ideal_speed() -> float:
	return self.ideal_speed;

func _get_input_force_strength() -> float:
	return self.input_force_strength;

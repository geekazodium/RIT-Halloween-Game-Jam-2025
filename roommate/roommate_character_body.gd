extends UMCharacterBody3D
class_name RoommateCharacterBody

@export var ideal_speed: float = 5;
@export var input_force_strength: float = 10;

func _get_ideal_speed() -> float:
	return self.ideal_speed;

func _get_input_force_strength() -> float:
	return self.input_force_strength;

extends UMCharacterBody3D
class_name RoommateCharacterBody

## gets how suspicious of the player the roommate is
var suspicion: float:
	get:
		return _player_detection.suspicion;

var roommate_task_manager: RoommateTaskManager:
	get:
		return $RoommateTaskManager;
@onready var _player_detection: PlayerDetectionRadius = $PlayerDetection3D;

@export_category("level settings")
@export var seconds_until_late: float;

@export_category("Character Settings")
@export var ideal_speed: float = 5;
@export var input_force_strength: float = 10;

@export var sprite: AnimatedSprite3D;
var looking_forward: bool = false;

var held_item: Item;

func _ready() -> void:
	RoommateGlobalRef.add_roommate(self);

func _get_ideal_speed() -> float:
	return self.ideal_speed;

func _get_input_force_strength() -> float:
	return self.input_force_strength;

func _physics_process(delta: float) -> void:
	var view = self.get_viewport();
	if view != null:
		var camera: Camera3D = view.get_camera_3d();
		if camera != null:
			self.global_rotation.y = camera.global_rotation.y;
	super._physics_process(delta);
	var direction_vec: Vector2 = self.movement_direction.get_input_xz().rotated(self.rotation.y);
	direction_vec = direction_vec.normalized();
	
	if direction_vec.y > sin(PI/8):
		looking_forward = true;
	elif direction_vec.y < -sin(PI/8):
		looking_forward = false;
	
	if direction_vec.x > sin(PI/8):
		sprite.flip_h = true;
	elif direction_vec.x < -sin(PI/8):
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

func swap_item_with_container(container: ItemContainer) -> void:
	if self.held_item != null: $HeldItemSlot.remove_child(self.held_item);
	self.held_item = container.swap_item(self.held_item);
	if self.held_item != null: 
		$HeldItemSlot.add_child(self.held_item);
		self.held_item.visible = true;

func leave_level() -> void:
	RoommateGlobalRef.roommate_leave(self);
	self.queue_free();

func _exit_tree() -> void:
	pass;

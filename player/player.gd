extends UMCharacterBody3D
class_name Player

var interact_time : float = 1
@onready var interact_sound_player : AudioStreamPlayer = $interacting

@export var ideal_speed: float = 2;
@export var input_force_strength: float = 10;
@export var sprite: AnimatedSprite3D
@export var wishDir: Node

var interaction_timer: SceneTreeTimer;
var interacting: bool:
	get:
		if interaction_timer == null:
			return false;
		if interaction_timer.time_left <= 0:
			interaction_timer = null;
		return interaction_timer != null;

func _get_ideal_speed() -> float:
	if self.interacting: return 0;
	return self.ideal_speed;

func _get_input_force_strength() -> float:
	return self.input_force_strength;

var held_item: Item = null
var interacting_container: ItemContainer = null;
var looking_forward = true

func _process(_delta: float) -> void:
	if held_item:
		if held_item.is_sus():
			collision_layer = 2 | 32
	else:
		collision_layer = 2
	
	if self.held_item != null:
		self.held_item.visible = true;
	
	$CanvasLayer.visible = self.interacting;
	if self.interacting:
		$CanvasLayer/Control/ProgressBar.value = self.interaction_timer.time_left;
	
	if Input.is_action_just_pressed("interact") && !self.interacting:
		var areas:Array[Area3D] = $InteractionRange.get_overlapping_areas();
		if areas.size() > 0:
			areas.sort_custom(
				func (a: Area3D, b: Area3D):
					return a.global_position.distance_squared_to(self.global_position) < \
					b.global_position.distance_squared_to(self.global_position);
			)
			var area: Area3D = areas[0];
			var node = area.get_parent();
			if node is ItemContainer:
				if node.item != null || self.held_item != null:
					self.interacting_container = node;
					interact_sound_player.play(randf_range(5.0,30.0))
					$CanvasLayer/Control/ProgressBar.max_value = node.time_to_interact;
					self.interaction_timer = get_tree().create_timer(node.time_to_interact);
	if Input.is_action_pressed("interact") && self.interacting_container != null:
		if self.interacting_container.item != null || self.held_item != null:
			if !self.interacting:
				self.interaction_timer = null;
				if self.held_item != null:
					self.remove_child(held_item);
					self.held_item.scale = Vector3(1,1,1)
				self.held_item = self.interacting_container.swap_item(self.held_item);
				if self.held_item != null:
					add_child(held_item) 
					held_item.position = position;
					held_item.scale = Vector3(2,2,2)
				
				self.interacting_container = null;
				interact_sound_player.stop();
		else:
			interact_sound_player.stop();
			self.interacting_container = null;
			self.interaction_timer = null;
	if Input.is_action_just_released("interact"):
		self.interacting = false;
		self.interacting_container = null;
		self.interaction_timer = null;
		interact_sound_player.stop();
	play_animation();

func play_animation():
	var direction_vec = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	
	if sign(direction_vec.y) == 1:
		looking_forward = true
	elif sign(direction_vec.y) == -1:
		looking_forward = false
	
	if sign(direction_vec.x) == 1:
		sprite.flip_h = true
	elif sign(direction_vec.x) == -1:
		sprite.flip_h = false
	
	var animation = ""
	
	if held_item != null:
		animation = "holding_"
		var target_global = global_position + Vector3(0, 0.75, 0)
		held_item.set_deferred("global_position", target_global);
	
	if(direction_vec == Vector2.ZERO):
		animation += "standing_"
	else:
		animation += "walking_"
	
	if(looking_forward):
		animation += "front"
	else: 
		animation += "back"
	sprite.play(animation)

func _on_interaction_range_area_entered(area: Area3D) -> void:
	var body = area.get_parent()
	if body is ItemContainer:
		body.show_item.call_deferred();


func _on_interaction_range_area_exited(area: Area3D) -> void:
	var body = area.get_parent()
	if body is ItemContainer:
		body.hide_item()

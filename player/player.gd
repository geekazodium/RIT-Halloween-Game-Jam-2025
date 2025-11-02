extends UMCharacterBody3D
class_name Player

@export var ideal_speed: float = 2;
@export var input_force_strength: float = 10;
@export var sprite: AnimatedSprite3D
@export var wishDir: Node
@export var area: Area3D

func _get_ideal_speed() -> float:
	return self.ideal_speed;

func _get_input_force_strength() -> float:
	return self.input_force_strength;

var held_item: Item = null
var looking_forward = true

func _process(_delta: float) -> void:
	play_animation()
	if Input.is_action_pressed("interact"):
		for node in area.get_overlapping_bodies():
			if node.get_class() == "ItemContainer":
				if node.item != null and held_item == null: #if container has item/player doesnt
					held_item = node.item
					node.item = null
					print("Player now has: ", held_item)
				elif held_item != null: #if player has item/container doesnt
					node.item = held_item
					held_item = null
					print("Container now has: ", node.item)

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
		body.show_item()


func _on_interaction_range_area_exited(area: Area3D) -> void:
	var body = area.get_parent()
	if body is ItemContainer:
		body.hide_item()

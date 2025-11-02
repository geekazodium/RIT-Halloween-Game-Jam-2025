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
	if Input.is_action_just_pressed("interact"):
		print("Player pressed interact s1")
		for area in area.get_overlapping_areas():
			print("node is in area overlap")
			var node = area.get_parent()
			if node is ItemContainer:
				print("Node is container s3")
				if node.item != null and held_item == null: #if container has item/player doesnt
					held_item = node.take_item()
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
		held_item.visible = true
		held_item.global_position = global_position + Vector3(0,1,0)
	
	if(direction_vec == Vector2.ZERO):
		animation += "standing_"
	else:
		animation += "walking_"
	
	if(looking_forward):
		animation += "front"
	else: 
		animation += "back"
	print(held_item)
	sprite.play(animation)

func _on_interaction_range_area_entered(area: Area3D) -> void:
	var body = area.get_parent()
	if body is ItemContainer:
		body.show_item()


func _on_interaction_range_area_exited(area: Area3D) -> void:
	var body = area.get_parent()
	if body is ItemContainer:
		body.hide_item()

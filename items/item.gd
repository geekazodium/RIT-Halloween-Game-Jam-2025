extends Node3D
class_name Item

@export var key: StringName
@export var suspicious_val: int

@onready var paperbag = preload("res://items/textures/paperbag.png")
@onready var plate = preload("res://items/textures/plate.png")
@onready var pumpkin = preload("res://items/textures/pumpkin.png")
@onready var toothbrush = preload("res://items/textures/toothbrush.png")
@onready var trash = preload("res://items/textures/trash.png")

func _ready():
	var texture_dict = {"plate":plate, "trash":trash, "toothbrush":toothbrush, "lunchbag":paperbag, "pumpkin":pumpkin}
	$Sprite3D.texture = texture_dict.get(key)

func _enter_tree() -> void:
	if self.get_parent() is ItemContainer:
		self.get_parent().item = self;

func is_sus():
	return suspicious_val > 0

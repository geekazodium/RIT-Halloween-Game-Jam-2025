extends Node3D
class_name Item

@export var key: StringName

func _enter_tree() -> void:
	if self.get_parent() is ItemContainer:
		self.get_parent().item = self;

extends Node3D
class_name ItemContainer

@export var _key: StringName = "";
## readonly key
var key:
	get:
		return _key;

@onready var item_holder: Node3D = $ItemHolder;

## getter/setter for item that is contained in itemholder
## itemholder is going to be the parent of the the item added or removed
## so the transform will be copied from there, adjust the itemholder node
## to change it for certain containers
var item: Item:
	get:
		if self.item_holder.get_child_count() == 0:
			return null;
		return self.item_holder.get_child(0) as Item;
	set(value):
		for c in self.item_holder.get_children():
			c.queue_free();
		self.item_holder.add_child(value);

extends Node3D
class_name ItemContainer

@export var _key: StringName = "";
## readonly key
var key:
	get:
		return _key;

## getter/setter for item that is contained in itemholder
## itemholder is going to be the parent of the the item added or removed
## so the transform will be copied from there, adjust the itemholder node
## to change it for certain containers
var item: Item = null:
	get:
		return item;
	set(value):
		if (self.item == null) == (value == null):
			return;
		if item != null:
			for c in self.item_holder.get_children():
				c.queue_free();
		else:
			self.move_to_item_holder.call_deferred(value);
		item = value;

var item_holder: Node3D:
	get: 
		return $ItemHolder;

func move_to_item_holder(v: Item) -> void:
	if v.is_inside_tree():
		v.get_parent().remove_child(v);
	self.item_holder.add_child.call_deferred(v);

func item_matches(item_key: StringName) -> bool:
	if self.item == null:
		return false;
	return self.item.key == item_key;

func take_item() -> Item:
	if self.item == null:
		return null;
	var taken: Item = self.item;
	self.item = null;
	return taken;

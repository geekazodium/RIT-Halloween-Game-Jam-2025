extends Node

var _rooms: Array[Room] = [];
var rooms:
	get:
		return _rooms;

var identified_containers: Dictionary[StringName, ItemContainer] = {};
var initial_item_locations: Dictionary[StringName, ItemContainer] = {};

func room_enter_tree(room: Room) -> void:
	self._rooms.append(room);
	for container: ItemContainer in room.containers:
		if container.key != "":
			self.identified_containers.set(container.key, container);
		if container.item != null:
			self.initial_item_locations.set(container.item.key, container);
	self.room_entering_tree.emit(room);

## can be optimized, not during game jam please.
func room_exit_tree(room: Room) -> void:
	self._rooms.remove_at(self._rooms.find(room));
	for container: ItemContainer in room.containers:
		if container.key != "":
			self.identified_containers.erase(container.key);
		
		#search for key here instead of using current item key, as that could
		#have been changed by player.
		var key = self.initial_item_locations.find_key(container);
		if key != null:
			self.initial_item_locations.erase(key);
	self.room_exiting_tree.emit(room);

signal room_entering_tree(room: Room);

signal room_exiting_tree(room: Room);

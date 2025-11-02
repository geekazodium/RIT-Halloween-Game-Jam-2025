extends Node
class_name RoommateTaskManager

@export var tasks: Array[RoommateTask];
var current_task: RoommateTask:
	get:
		if tasks.size() == 0:
			return null;
		return tasks[0];

@export var wish_dir: RoommateWishDir;

@export var character_body: RoommateCharacterBody;
@export var current_room_detector: Area3D;

@export var room_enter_detection_area: Area3D;
## CAUTION: this assumes the rooms in global never get changed *while*
## roommate is trying to find something;
var rooms_to_check: Array[Room];
var target_room: Room:
	get:
		if rooms_to_check.size() == 0:
			self._init_room_search_order();
		return rooms_to_check[0];

var current_room_to_check: Room = null;


var _state: State;

enum State{
	CheckRememberedItem,
	SearchForItemNextRoom,
	SearchForItemSearchRoom,
	GoToTargetContainer
}

func _ready() -> void:
	self._state = State.CheckRememberedItem;
	WorldRooms.room_entering_tree.connect(self._add_room_to_check);

func _add_room_to_check(room: Room) -> void:
	self.rooms_to_check.append(room);

func _physics_process(delta: float) -> void:
	if self.current_task == null:
		return;
	match self._state:
		State.CheckRememberedItem:
			self._nav_to_last_remembered();
		State.SearchForItemSearchRoom:
			self._search_current_room(delta);
		State.SearchForItemNextRoom:
			self._move_to_next_room();

func _nav_to_last_remembered() -> void:
	var item_key: StringName = self.current_task.item_needed;
	var container: ItemContainer = WorldRooms.initial_item_locations.get(item_key);
	if container == null:
		print(WorldRooms.initial_item_locations);
		WHATHAVEYOUDONE.WHAT_HAVE_YOU_DONE("no container found with key, scene definitely was not set up correctly");
		return;
	self.wish_dir.target = container;
	if self.wish_dir.is_in_range:
		var matches: bool = container.item_matches(item_key);
		if matches:
			self._state = State.GoToTargetContainer;
			self.character_body.held_item = container.take_item();
		else:
			self._init_room_search_order();
			self._state = State.SearchForItemSearchRoom;

func _init_room_search_order() -> void:
	print("reinitializing order of room search");
	self.rooms_to_check.clear();
	for room in WorldRooms.rooms:
		self._add_room_to_check(room);
	self.rooms_to_check.sort_custom(
		func(a: Room, b: Room):
			var a_distance: float = a.bounding_box.global_position.distance_squared_to(self.character_body.global_position);
			var b_distance: float = b.bounding_box.global_position.distance_squared_to(self.character_body.global_position);
			return a_distance > b_distance;
	);

func _move_to_next_room() -> void:
	self.wish_dir.target = self.target_room.bounding_box;
	for area in self.current_room_detector.get_overlapping_areas():
		var room = area.get_parent() as Room;
		if room == null:
			continue;
		var index: int = self.rooms_to_check.find(room);
		if index != -1:
			self._init_room_search(self.rooms_to_check[index]);
			self.rooms_to_check.remove_at(index);

func _init_room_search(room: Room):
	print("initializing room search for room ", room);
	self._state = State.SearchForItemSearchRoom;
	self.search_time_left = self.search_time_seconds;
	self.containers_to_search.clear();
	self.current_room_to_check = room;
	self.containers_to_search.append_array(self.current_room_to_check.containers);
	self.containers_to_search.sort_custom(
		func(a: ItemContainer, b: ItemContainer):
			return \
			a.global_position.distance_squared_to(self.character_body.global_position) < \
			b.global_position.distance_squared_to(self.character_body.global_position);
	);

var containers_to_search: Array[ItemContainer] = [];
var search_time_left: float = 0;
@export var search_time_seconds: float = 1;

func _search_current_room(delta: float) -> void:
	if containers_to_search.size() == 0:
		self._state = State.SearchForItemNextRoom;
		return;
	var target: ItemContainer = self.containers_to_search[0];
	self.wish_dir.target = target;
	if self.wish_dir.is_in_range:
		if search_time_left > 0:
			search_time_left -= delta;
			return; 
		if target.item == null || self.current_task.item_needed != target.item.key:
			print("failed to find");
			containers_to_search.pop_front();
		else:
			target.take_item();
			self._state = State.GoToTargetContainer;
		self.search_time_left = self.search_time_seconds;
#func _search_containers_for_item() -> void:
	#self.wish_dir.target = 
	#pass

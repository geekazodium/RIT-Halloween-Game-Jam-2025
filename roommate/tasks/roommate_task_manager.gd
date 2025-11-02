extends Node
class_name RoommateTaskManager

@export var tasks: Array[RoommateTask];
var current_task_index: int = 0;
var current_task: RoommateTask:
	get:
		if self.current_task_index >= self.tasks.size():
			return null;
		return tasks[self.current_task_index];

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
			self._init_room_search_order(self.character_body.global_position);
		return rooms_to_check[0];

@export var search_container_timer: float = 2;

var current_room_to_check: Room = null;
var give_up_time_left: float;

var _state: State;

enum State{
	CheckRememberedItem,
	SearchForItemNextRoom,
	SearchForItemSearchRoom,
	GoToTargetContainer
}

## note: I rewrote this to use an index instead of popping the front element,
## in theory, you now have a one-to-one relation between tasks in the array and
## a list instantiated in the corresponding order since the task list is never added
## or removed from.
signal task_status_updated(index: int, status: RoommateTask.TaskStatus);

var grab_item_timer: float = 0;

func _init_next_task() -> void:
	self._state = State.CheckRememberedItem;
	self.grab_item_timer = self.search_container_timer;
	if self.current_task != null:
		self.give_up_time_left = self.current_task.seconds_until_give_up;

func _ready() -> void:
	self._init_next_task();
	WorldRooms.room_entering_tree.connect(self._add_room_to_check);

func _add_room_to_check(room: Room) -> void:
	self.rooms_to_check.append(room);

func _physics_process(delta: float) -> void:
	if self.current_task == null:
		self.wish_dir.target = RoommateGlobalRef.exit_target;
		return;
	if self.override_chase_player || self.memory_location != null:
		self._chase_player(delta);
		return;
	match self._state:
		State.CheckRememberedItem:
			self._nav_to_last_remembered(delta);
		State.SearchForItemSearchRoom:
			self.give_up_time_left -= delta;
			self._search_current_room(delta);
		State.SearchForItemNextRoom:
			self.give_up_time_left -= delta;
			self._move_to_next_room();
		State.GoToTargetContainer:
			self._go_to_target_container(delta);

func _nav_to_last_remembered(delta: float) -> void:
	var item_key: StringName = self.current_task.item_needed;
	var container: ItemContainer = WorldRooms.initial_item_locations.get(item_key);
	if container == null:
		print(WorldRooms.initial_item_locations);
		WHATHAVEYOUDONE.WHAT_HAVE_YOU_DONE("no container found with key, scene definitely was not set up correctly");
		return;
	self.wish_dir.target = container;
	if self.wish_dir.is_in_range:
		if self.grab_item_timer > 0:
			self.grab_item_timer -= delta;
			return;
		var matches: bool = container.item_matches(item_key);
		if matches:
			self.character_body.swap_item_with_container(container);
			self._start_task();
		else:
			self._init_room_search_order(self.character_body.global_position);
			self._state = State.SearchForItemSearchRoom;

func _init_room_search_order(pos: Vector3) -> void:
	print("reinitializing order of room search");
	self.rooms_to_check.clear();
	for room in WorldRooms.rooms:
		self._add_room_to_check(room);
	self.rooms_to_check.sort_custom(
		func(a: Room, b: Room):
			var a_distance: float = a.bounding_box.global_position.distance_squared_to(pos);
			var b_distance: float = b.bounding_box.global_position.distance_squared_to(pos);
			return a_distance > b_distance;
	);

func check_give_up() -> bool:
	if self.give_up_time_left < 0:
		print("gave up");
		self.current_task.status = RoommateTask.TaskStatus.GAVE_UP;
		self.task_status_updated.emit(self.current_task_index, self.current_task.status);
		self.current_task_index += 1;
		self._init_next_task();
		return true;
	return false;

func _move_to_next_room() -> void:
	if self.check_give_up():
		return;
	self.wish_dir.target = self.target_room.bounding_box;
	self._check_interrupt_traversal_with_this_room();

func _check_interrupt_traversal_with_this_room() -> void:
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
	if self.character_body.held_item != null && \
	self.character_body.held_item.key == self.current_task.item_needed:
		self._start_task();
		return;
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
			if self.check_give_up():
				return;
		else:
			self.character_body.swap_item_with_container(target);
			self._start_task();
		self.search_time_left = self.search_time_seconds;
#func _search_containers_for_item() -> void:
	#self.wish_dir.target = 
	#pass

var task_time_left: float = 0;

func _start_task() -> void:
	self._state = State.GoToTargetContainer;
	self.task_time_left = self.current_task.seconds_required;

func _go_to_target_container(delta: float) -> void:
	var target_container: ItemContainer = WorldRooms.identified_containers.get(self.current_task.container_key);
	if target_container == null:
		WHATHAVEYOUDONE.WHAT_HAVE_YOU_DONE("you definitely named the task container and world container different things")
	self.wish_dir.target = target_container;
	if self.wish_dir.is_in_range:
		self.task_time_left -= delta;
		if self.task_time_left <= 0:
			self.current_task.status = RoommateTask.TaskStatus.COMPLETE;
			self.task_status_updated.emit(self.current_task_index, self.current_task.status);
			self.current_task_index += 1;
			self.character_body.swap_item_with_container(target_container);
			self._init_next_task();
			print("task done!");


@export var chase_player_time: float = 1;
var chase_player_time_left: float = 0;
var player_to_follow: Player;

var last_player_suspicion_position: Vector3;

var override_chase_player: bool:
	get:
		return chase_player_time_left > 0;

func _is_holding_current_task_item(player: Player) -> bool:
	if self.current_task == null || player.held_item == null:
		return false;
	if player.held_item.key != self.current_task.item_needed:
		return false;
	return true

func _on_suspicious_player_detected(player: Player) -> void:
	if !self._is_holding_current_task_item(player):
		return;
	self.chase_player_time_left = self.chase_player_time;
	self.player_to_follow = player;

var memory_location: Node3D;

func _chase_player(delta: float) -> void:
	self.chase_player_time_left -= delta;
	if !self.override_chase_player:
		## executes on first iter where it was chasing player but then isnt
		if self.memory_location == null:
			self.memory_location = Node3D.new();
			self.add_child(self.memory_location);
		self.wish_dir.target = self.memory_location;
		self.memory_location.global_position = self.last_player_suspicion_position;
		if self.wish_dir.is_in_range:
			self._init_room_search_order(self.last_player_suspicion_position);
			self.current_room_to_check = null;
			self.memory_location.queue_free();
			self.memory_location = null;
			self._check_interrupt_traversal_with_this_room();
	else:
		self.wish_dir.target = self.player_to_follow;
		#fix: roommate should now search for items starting with the last place 
		#the player had their item (even if they can't see that)
		if self._is_holding_current_task_item(self.player_to_follow):
			self.last_player_suspicion_position = self.player_to_follow.global_position;

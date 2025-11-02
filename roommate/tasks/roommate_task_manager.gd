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

@export var room_enter_detection_area: Area3D;
## CAUTION: this assumes the rooms in global never get changed *while*
## roommate is trying to find something;
var rooms_to_check: Array[Room];
var next_room_to_check: Room:
	get:
		if rooms_to_check.size() == 0:
			#self.rooms_to_check = 
			pass
		return rooms_to_check[0];


var _state: State;

enum State{
	CheckRememberedItem,
	SearchForItem,
	GoToTargetContainer
}

func _ready() -> void:
	self._state = State.CheckRememberedItem;
	WorldRooms.room_entering_tree.connect(self._add_room_to_check);
	for room in WorldRooms.rooms:
		self._add_room_to_check(room);

func _add_room_to_check(room: Room) -> void:
	self.rooms_to_check.append(room);

func _physics_process(_delta: float) -> void:
	if self.current_task == null:
		return;
	match self._state:
		State.CheckRememberedItem:
			self._nav_to_last_remembered();
		State.SearchForItem:
			self._search_containers_for_item();

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
			self._state = State.SearchForItem;

func _init_item_search() -> void:
	pass

func _search_containers_for_item() -> void:
	
	pass

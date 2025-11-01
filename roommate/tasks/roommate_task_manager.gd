extends Node
class_name RoommateTaskManager

@export var tasks: Array[RoommateTask];
var current_task: RoommateTask:
	get:
		if tasks.size() == 0:
			return null;
		return tasks[0];

@export var wish_dir: RoommateWishDir;

@export var room_enter_detection_area: Area3D;
## CAUTION: this assumes the rooms in global never get changed *while*
## roommate is trying to find something;
var rooms_to_check: Array[Room];

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

func _physics_process(delta: float) -> void:
	match self._state:
		State.CheckRememberedItem:
			self.wish_dir.target = WorldRooms.initial_item_locations.get(self.current_task.item_needed);
			self.wish_dir.is_in_range;

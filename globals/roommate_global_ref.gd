extends Node

## I was wrong, a global ref of the roommate is fine, I didn't think about it
## enough but this should be okay, I encapsulated most stuff to hopefully still
## preserve scalability once refactored.
var _roommate: RoommateCharacterBody;
var _roommate_time_spent: float; 
var _exit_target: Node3D;

var exit_target: Node3D:
	get:
		return _exit_target;

var has_all_roommates_exited: bool:
	get:
		return _roommate == null;

func set_global_exit_target(target: Node3D) -> void:
	self._exit_target = target;

func add_roommate(roommate: RoommateCharacterBody) -> void:
	self._roommate = roommate;
	self._roommate_time_spent = 0;

func roommate_leave(roommate: RoommateCharacterBody) -> void:
	if self._roommate != roommate:
		return;
	self._roommate = null;
	
	var time_diff: float = self._roommate_time_spent - roommate.seconds_until_late;
	
	self.all_roommates_left.emit(max(time_diff,0));

func get_roommate_time_spent() -> float:
	return self._roommate_time_spent;

func _physics_process(delta: float) -> void:
	if self.has_all_roommates_exited:
		return;
	self._roommate_time_spent += delta;

signal all_roommates_left(late_seconds: float);

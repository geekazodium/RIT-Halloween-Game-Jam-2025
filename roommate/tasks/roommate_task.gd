extends Resource
class_name RoommateTask

@export var item_needed: StringName;
@export var container_key: StringName;
@export var seconds_required: float;
@export var seconds_until_give_up: float;

var status: TaskStatus = TaskStatus.PENDING;

enum TaskStatus{
	PENDING,
	COMPLETE,
	GAVE_UP
}

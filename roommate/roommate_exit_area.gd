extends Area3D
class_name RoommateExitArea

const POLL_INTERVAL_SECONDS: float = .75;

var time_since_last_poll: float = 0;

func _ready() -> void:
	RoommateGlobalRef.set_global_exit_target(self);
	
	### FIXME: refactor this responsibility out to a seperate class, don't use this
	## to keep track of if game is over
	RoommateGlobalRef.all_roommates_left.connect(self.on_game_end);

func on_game_end(seconds_late: float) -> void:
	var tree: SceneTree = self.get_tree();
	tree.set_block_signals(true);
	tree.change_scene_to_file("res://menu/menu.tscn");
	tree.set_block_signals(false);

func _physics_process(delta: float) -> void:
	self.time_since_last_poll += delta;
	if self.time_since_last_poll >= POLL_INTERVAL_SECONDS:
		## skip multiple polls on same frame.
		self.time_since_last_poll = fposmod(self.time_since_last_poll,POLL_INTERVAL_SECONDS);
		for body in self.get_overlapping_bodies():
			self.attempt_exit_roommate(body);

func attempt_exit_roommate(body: PhysicsBody3D) -> void:
	var roommate: RoommateCharacterBody = body as RoommateCharacterBody;
	if roommate == null:
		return;
	if roommate.roommate_task_manager.current_task != null:
		return;
	roommate.leave_level();

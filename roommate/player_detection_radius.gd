extends Area3D
class_name PlayerDetectionRadius

@export_range(0, 180, 0.001, "radians_as_degrees") var vision_angle_range: float = PI/4;
@export var direction_src: UMCharacterBody3D;

@export var suspicion_decay_per_second: float = .1;
var suspicion: float = 0;
@export var display_mesh: Node3D;
const SUSPICIOUS_LAYER: int = 6;

signal suspicious_player_detected(player: Player);

var line_of_sight: RayCast3D:
	get:
		return $SuspicionLineOfSight

func _physics_process(delta: float) -> void:
	var facing: Vector2 = direction_src.last_nonzero_input_dir.normalized();
	self.display_mesh.global_rotation.y = -facing.angle();
	var dot_prod_tolerance: float = cos(self.vision_angle_range);
	
	var suspicious: bool = false;
	
	for body:PhysicsBody3D in self.get_overlapping_bodies():
		## uncomment when player type exists
		#if !body is player: return;
		var delta_position: Vector3 = body.global_position - self.global_position;
		var offset_x_z: Vector2 = Vector2(delta_position.x,delta_position.z).normalized();
		var dot: float = offset_x_z.dot(facing);
		if dot < dot_prod_tolerance:
			continue;
		
		if !self._check_line_of_sight(body):
			continue;
		
		self.suspicion += self._get_suspicion_per_second(body as CharacterBody3D) * delta;
		var player_coll: Player = body as Player;
		if player_coll != null: 
			self.suspicious_player_detected.emit(player_coll);
		print("sus");
		suspicious = true;
	if !suspicious:
		self.suspicion = max(self.suspicion - self.suspicion_decay_per_second * delta,0);


func _check_line_of_sight(body: PhysicsBody3D) -> bool:
	if self.is_colliding_with_suspicious_body(body.global_position - Vector3.UP * .3):
		return true;
	
	return self.is_colliding_with_suspicious_body(body.global_position - Vector3.DOWN * .1);

func is_colliding_with_suspicious_body(global_pos: Vector3) -> bool:
	self.line_of_sight.target_position = self.line_of_sight.to_local(global_pos);
	self.line_of_sight.target_position *= 1.1;
	self.line_of_sight.force_raycast_update();
	var coll = self.line_of_sight.get_collider();
	if coll is CollisionObject3D:
		if coll.get_collision_layer_value(SUSPICIOUS_LAYER):
			return true;
	return false;

func _get_suspicion_per_second(player: CharacterBody3D) -> float:
	return 1;

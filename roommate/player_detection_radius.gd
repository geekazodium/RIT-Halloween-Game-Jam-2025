extends Area3D
class_name PlayerDetectionRadius

func _physics_process(delta: float) -> void:
	for body:PhysicsBody3D in self.get_overlapping_bodies():
		## uncomment when player type exists
		#if !body is player: return;
		pass;
	pass;

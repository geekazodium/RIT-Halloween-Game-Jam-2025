extends Item

func _physics_process(delta: float) -> void:
	var p = self.get_parent().get_parent();
	if p is ItemContainer:
		p.item = null;

extends ItemContainer

func _physics_process(_delta: float) -> void:
	if(item != null):
		item = null

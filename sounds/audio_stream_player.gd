extends AudioStreamPlayer

static var music_place : float = 0
var length : float

func _ready() -> void:
	length = stream.get_length()
	play(music_place)

func _process(delta: float) -> void:
	music_place = (music_place + delta)
	if music_place > length:
		music_place -= length

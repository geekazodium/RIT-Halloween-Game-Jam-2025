extends Control

func _process(_delta: float) -> void:
	var time_left: float = RoommateGlobalRef.get_roommate_time_left();
	$ProgressBar.value = time_left;
	$TimeUntilClass.text = "Time Until Class: %sm %ss" % [floori(time_left / 60),floori(time_left) % 60];
	$ProgressBar.max_value = RoommateGlobalRef.get_roommate().seconds_until_late;

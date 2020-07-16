extends MarginContainer

func _physics_process(delta: float) -> void:
	$HBoxContainer/VBoxContainer/Stat01.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
	$HBoxContainer/VBoxContainer/Stat02.text = "Memory Static: " + str(round(Performance.get_monitor(Performance.MEMORY_STATIC)))
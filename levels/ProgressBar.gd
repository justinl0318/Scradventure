extends ProgressBar

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	value = get_tree().root.get_node("level1").get_node("Player").get_node("lifebar").value
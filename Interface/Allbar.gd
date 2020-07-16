extends CanvasLayer
var currentlevel = "level1"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$MarginContainer/HBoxContainer2/VBoxContainer/LifeBar.value = get_tree().root.get_node(currentlevel).get_node("Player").get_node("lifebar").value
	$MarginContainer/HBoxContainer2/VBoxContainer/ManaBar.value = get_tree().root.get_node(currentlevel).get_node("Player").get_node("ManaBar").value
	$MarginContainer/HBoxContainer2/VBoxContainer/XPBar.max_value = get_tree().root.get_node(currentlevel).get_node("Player").get_node("XPbar").max_value
	$MarginContainer/HBoxContainer2/VBoxContainer/XPBar.value = get_tree().root.get_node(currentlevel).get_node("Player").get_node("XPbar").value
	$MarginContainer/HBoxContainer2/VBoxContainer/XPBar/Label.text = get_tree().root.get_node(currentlevel).get_node("Player").get_node("level").text
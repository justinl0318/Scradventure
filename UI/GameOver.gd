extends Control
var text = "Game Over"


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CenterContainer/VBoxContainer/Label.text = text


func _on_Button_pressed() -> void:
	get_tree().change_scene("res://UI/TitleScreen.tscn")

extends Sprite

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pas

func _on_level1portalcollision_area_entered(area: Area2D) -> void:
	if area.get_name() == "collision":
		var targetPlayer = area.get_owner()
		var me = preload("res://actors/Player.tscn").instance()
		me.position = Vector2(100,100)
		get_tree().root.get_node("level2").add_child(me)
		#get_tree().change_scene("res://levels/level2.tscn")

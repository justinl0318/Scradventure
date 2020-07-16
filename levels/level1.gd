extends Node2D

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Music.play()
	$ParallaxBackground/ParallaxLayer/Sprite.modulate.a = 0.5
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_Music_finished() -> void:
	$Music.play()
	
func _process(delta: float) -> void:
	var text = $Player/level.text
	if int(text) >= 5:
		$portal.visible = true
		$portal/CollisionShape2D.disabled = false
		$portal/level1portalcollision/CollisionShape2D.disabled = false
	else:
		$portal.visible = false
		$portal/CollisionShape2D.disabled = true
		$portal/level1portalcollision/CollisionShape2D.disabled = true
		

		

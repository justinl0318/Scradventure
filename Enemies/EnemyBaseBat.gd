extends "res://Enemies/EnemyBase.gd"

onready var shootray = $"RayCast2D"

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func pursuit():
	vector = targetPlayer.position - self.position
	#vector.y += gravity
	if vector.x <= 100 and vector.x >= -100:
		pass
##		vector.x *= 3

func patrol():
	if not shootray.is_colliding():
		vector.y = 0
	else:
		vector.y = -50
	.patrol()
#	if vector.y = 100:
#		vector.y = -100
	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

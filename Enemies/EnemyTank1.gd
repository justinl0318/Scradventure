extends "res://Enemies/EnemyBaseTank.gd"



func _ready():
	numberOfMoves = 1
	anim = $"AnimatedSprite"
	collision = $"CollisionShape2D"
	
func ownProcess():
	self.visible = true
	.ownProcess()

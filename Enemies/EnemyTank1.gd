extends "res://Enemies/EnemyBaseTank.gd"



func _ready():
	numberOfMoves = 1
	anim = $"AnimatedSprite"
	



#func _on_EnemyTank1DetectionCollision_area_entered(area: Area2D) -> void:
#	if area.get_name() == "collision":
#		playerEnter = true
#
#func _on_EnemyTank1DetectionCollision_area_exited(area: Area2D) -> void:
#	if area.get_name() == "collision":
#		playerEnter = false

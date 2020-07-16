extends "res://Enemies/EnemyBase.gd"

func _ready():
	pass
	
func pursuit():
	vector = targetPlayer.position - self.position
	vector.y += gravity * 0.6
	
func patrol():
	vector.y += gravity * 0.6
	.patrol()
	
func ownProcess():
	self.visible = true
	.ownProcess()

#		vector.x *= 3
#		print(vector.x)
#	move_and_slide(vector, vectorNormal)
	




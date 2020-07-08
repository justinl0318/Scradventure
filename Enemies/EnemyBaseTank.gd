extends "res://Enemies/EnemyBase.gd"

func _ready():
	numberOfMoves = 3
	
func pursuit():
	vector = targetPlayer.position - self.position
	vector.y += gravity
	if vector.x <= 100 and vector.x >= -100:
		pass
#		vector.x *= 3
#		print(vector.x)
#	move_and_slide(vector, vectorNormal)
	

func choooseAttack():
	var random = randi()%numberOfMoves
	# Additional logic for attack selecton
	doAttack(random)
	
	
func doAttack(attackNumber:int):
	self.state.append("inaction")
	match attackNumber:
		0:
			pass
		1:
			pass
		2:
			pass




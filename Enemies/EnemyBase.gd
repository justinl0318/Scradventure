extends RigidBody2D

var numberOfMoves = 3
var state = [] # attacking = damage player when touhing hitbox; inaction = currently on move; 
var detectionRange = 100
var actionRange = 100
var movespeed = 100

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_testfunction()
	if not self.state.has("inaction"):
		_standby()
	# if has state attacking and player is touching hitbox: damange

func _testfunction():
	print(numberOfMoves)
	
func _standby():
	# if player range less than detectionRange:
		# pursuit
		# if player range less than actionRange:
			# chooseAttack()
	# else:
		# patrol
	
	pass

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

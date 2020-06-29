extends RigidBody2D

onready var anim

var numberOfMoves = 3
var state = [] # attacking = damage player when touhing hitbox; inaction = currently on move; 
var detectionRange = 100
var actionRange = 100
var movespeed = 100
var playerEnter = false
var vector = Vector2()
var targetPlayer

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
	#var distance = 
	# if has state attacking and player is touching hitbox: damange

func _testfunction():
	#print(numberOfMoves)
	pass
	
func _standby():
	# if player range less than detectionRange:
		# pursuit
		# if player range less than actionRange:
			# chooseAttack()
	# else:
		# patrol
	if playerEnter == true:
		vector = targetPlayer.position - self.position
		linear_velocity = vector

		if linear_velocity.y <= 0:
			gravity_scale = linear_velocity.y * -1
		#linear_velocity.x = 200
		#linear_velocity.y = 0
	

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


func _on_EnemyTankDetection_area_entered(area: Area2D) -> void:
	if area.get_name() == "collision":
		playerEnter = true
		targetPlayer = area.get_owner()


func _on_EnemyTankDetection_area_exited(area: Area2D) -> void:
	if area.get_name() == "collision":
		playerEnter = false

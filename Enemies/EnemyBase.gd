extends KinematicBody2D

onready var anim

const attackCoolDownTimerMax = 100
const hitTimerMax = 100

var numberOfMoves = 3
var state = [] # attacking = damage player when touhing hitbox; inaction = currently on move; 
var detectionRange = 100
var actionRange = 100
var movespeed = 100
var playerEnter = false
var vector = Vector2()
var vectorNormal = Vector2(0, -1)
var targetPlayer
var gravity = 800
var canAttack = false
var attackCoolDownTimer = 0

var walktimer = 300
var walktimer2 = 0
var change

var hitTimer = 0


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if hitTimer > 0:
		hitTimer -= 1
		#add vector against player
		#beingHitanimation
	else:
		_testfunction()
		if not self.state.has("inaction"):
			_standby()
		#var distance = 
		# if has state attacking and player is touching hitbox: damange
		if attackCoolDownTimer > 0:
			attackCoolDownTimer -= 1
	if vector.x < 0:
		anim.set_flip_h(false)
	else:
		anim.set_flip_h(true)
	move_and_slide(vector, vectorNormal)
	
	
	
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
		pursuit()
		if canAttack and attackCoolDownTimer == 0:
			targetPlayer.beingHit()
			attackCoolDownTimer = attackCoolDownTimerMax
	else:
		patrol()
		

func patrol():
	anim.animation = "walk"
	if walktimer >= 0:
		walktimer -= 1
		vector.x = -100
	if walktimer == -1:
		if walktimer2 < 300:
			walktimer2 += 1
			vector.x = 100		
	if walktimer2 == 300:
		change = walktimer
		walktimer = walktimer2
		walktimer2 = change



func pursuit():
#	vector = targetPlayer.position - self.position
#	move_and_slide(vector, vectorNormal)
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
		


func _on_EnemyDetectionRange_area_entered(area: Area2D) -> void:
	if area.get_name() == "collision":
		playerEnter = true
		targetPlayer = area.get_owner()


func _on_EnemyDetectionRange_area_exited(area: Area2D) -> void:
	if area.get_name() == "collision":
		playerEnter = false


func _on_HitBoxRange_area_entered(area: Area2D) -> void:
	if area.get_name() == "collision":
		canAttack = true


func _on_HitBoxRange_area_exited(area: Area2D) -> void:
	if area.get_name() == "collision":
		canAttack = false

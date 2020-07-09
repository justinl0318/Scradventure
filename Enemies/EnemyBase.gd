extends KinematicBody2D

onready var anim
onready var lifebar = $"Lifebar"
onready var tween = $"Tween"

const attackCoolDownTimerMax = 100
const hitTimerMax = 10
var maxlife = 20.0
const maxDamageResetTimer = 40
const maxDeathTimer = 100

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

var life = maxlife
var lastAttackID = -1
var damageResetTimer = -1
var animated_life = 100

var deathTimer = -1

const attackagainTimerMax = 100
var attackagainTimer = 0
var attackagainBool = false

var playerBossEnter = false

var bossAttack = true
var bossMoveSpeed = 1
var bosscanAttack = true

var currentAnimatedLife = animated_life
var maxhurtTimer = 10
var hurtTimer = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifebar.value = animated_life

		
	
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
#	if currentAnimatedLife != animated_life:
#		if hurtTimer < maxhurtTimer:
#			hurtTimer += 1
#			anim.animation = "hurt"
#			vector.x = 0
#		else:
#			hurtTimer = 0
#			currentAnimatedLife = animated_life
	
	if damageResetTimer > 0:
		damageResetTimer -= 1
		if damageResetTimer == 0:
			lastAttackID = -1
	if deathTimer > 0:
		anim.animation = "die"
		vector.x = 0
		$"AnimatedSprite".modulate.a = float(deathTimer)/maxDeathTimer
		deathTimer -= 1
		if deathTimer == 0:
			queue_free()
			for i in range(5):
				var xp = preload("res://actors/Projectiles/XP.tscn").instance()
				xp.position.x = rand_range(self.position.x - 10, self.position.x + 10)
				xp.position.y = rand_range(self.position.y - 10, self.position.y -5)
				get_parent().add_child(xp)

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
			targetPlayer.beingHitDamage()
			anim.animation = "attack"
			attackagainBool = true
			attackCoolDownTimer = attackCoolDownTimerMax
		
	else:
		patrol()
	
		
	
	if attackagainBool and bossAttack:
		playerEnter = false
		attackagainTimer += 1
		if attackagainTimer == attackagainTimerMax:
			playerEnter = false
			attackagainBool = false
			attackagainTimer = 0
		
		
func getHit(attackID, attackDamage):
	if lastAttackID != attackID:
		lastAttackID = attackID
		life -= attackDamage
		damageResetTimer = maxDamageResetTimer
		tween.interpolate_property(self, "animated_life", animated_life, int(life/maxlife*100), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
		if not tween.is_active():
			tween.start()
		if life < 1:
			if deathTimer < 0:
				deathTimer = maxDeathTimer
				#print(vector.x)

func patrol():
	anim.animation = "walk"
	if walktimer >= 0:
		walktimer -= 1
		vector.x = -100 * bossMoveSpeed 
	if walktimer == -1:
		if walktimer2 < 300:
			walktimer2 += 1
			vector.x = 100 * bossMoveSpeed 
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
	if area.get_name() == "bullet":
		life -= 10
		tween.interpolate_property(self, "animated_life", animated_life, int(life/maxlife*100), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
		if not tween.is_active():
			tween.start()
		if life < 1:
			if deathTimer < 0:
				deathTimer = maxDeathTimer
				anim.animation = "die"
	if area.get_name() == "Fireballcollision":
		life -= 7
		tween.interpolate_property(self, "animated_life", animated_life, int(life/maxlife*100), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
		if not tween.is_active():
			tween.start()
		if life < 1:
			if deathTimer < 0:
				deathTimer = maxDeathTimer
				anim.animation = "die"
			
		



func _on_HitBoxRange_area_exited(area: Area2D) -> void:
	if area.get_name() == "collision":
		canAttack = false
		

		




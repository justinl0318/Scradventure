extends KinematicBody2D

onready var anim
onready var lifebar = $"Lifebar"
onready var tween = $"Tween"
onready var collision = $"CollisionShape2D"

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
var animated_life = 100.0
var currentlife = maxlife

var deathTimer = -1

const attackagainTimerMax = 100
var attackagainTimer = 0
var attackagainBool = false

var playerBossEnter = false

var bossAttack = true
var bossMoveSpeed = 1
var bosscanAttack = true

var states = []
var maxattackAnimationTime = 20
var attackAnimationTime = 0

var animName

const maxhurtTimer = 30
var hurtTimer = 0

var direction

var MaxspawnsmallMobTimer
var spawnsmallMobTimer

var maxattackstopTimer = 30
var attackstopTimer = -1
var bathit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ownProcess()
	

func ownProcess():
	self.visible = true
	if not states.has("Walk"):
		states.append("Walk")
	lifebar.value = animated_life

#	print("life: ", life)
#	print("currentlife", currentlife)
	
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
		if attackstopTimer > 0:
			vector.x = sign(vector.x)
			attackstopTimer -= 1
			
	if bossAttack:
		if currentlife != life:
			if hurtTimer < maxhurtTimer:
				if not states.has("Hurt"):
					states.append("Hurt")
				vector.x = sign(vector.x)
				hurtTimer += 1
			else:
				currentlife = life
				if states.has("Hurt"):
					states.remove(states.find("Hurt"))
				hurtTimer = 0


	if damageResetTimer > 0:
		damageResetTimer -= 1
		if damageResetTimer == 0:
			lastAttackID = -1
	if bossAttack:
		if deathTimer > 0:
			$HitBoxRange/HitBoxCollision.disabled = true
			collision.disabled = true
			vector.x = 0
			vector.y = 0
			anim.modulate.a = float(deathTimer)/maxDeathTimer
			deathTimer -= 1
			if deathTimer == 70:
				if states.has("Die"):
					states.remove(states.find("Die"))
			if deathTimer == 0:
				self.queue_free()
				for i in range(5):
					var xp = preload("res://actors/Projectiles/XP.tscn").instance()
					xp.position.x = rand_range(self.position.x - 10, self.position.x + 10)
					xp.position.y = rand_range(self.position.y - 10, self.position.y -5)
					get_parent().add_child(xp)
		else:
			$HitBoxRange/HitBoxCollision.disabled = false
			collision.disabled = false


		
	if life <= 0:
		if not states.has("Die"):
			states.append("Die")
	
	move_and_slide(vector, vectorNormal)
	
	
	if states.has("Walk"):
		#anim.animation = "walk"
		animName = "walk"
	if states.has("Hurt"):
		#anim.animation = "hurt"
		animName = "hurt"
	if states.has("Attack"):
		#anim.animation = "attack"
		animName = "attack"
	if states.has("Die"):
		#anim.animation = "die"
		animName = "die"
	$AnimatedSprite.animation = animName
	#$"AnimatedSprite".animation = animName
	
	if bossAttack:
		if vector.x < 0:
			anim.set_flip_h(false)
			direction = -1
		else:
			anim.set_flip_h(true)
			direction = 1
	
	
func _testfunction():
	#print(numberOfMoves)
	pass
	
func _standby():
	if playerEnter == true:
		pursuit()
		if canAttack and attackCoolDownTimer == 0:
			targetPlayer.beingHit()
			targetPlayer.beingHitDamage()
			if not states.has("Attack"):
				states.append("Attack")	
			if bathit:
				playerEnter = false
			attackagainBool = true
			attackCoolDownTimer = attackCoolDownTimerMax
			attackstopTimer = maxattackstopTimer
		
	else:
		patrol()
	
	if states.has("Attack"):
		if attackAnimationTime < maxattackAnimationTime:
			attackAnimationTime += 1
			anim.animation = "attack"			
		else:
			if states.has("Attack"):
				states.remove(states.find("Attack"))
			attackAnimationTime = 0
			
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
		life -= 10.0
		tween.interpolate_property(self, "animated_life", animated_life, int(life/maxlife*100), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
		if not tween.is_active():
			tween.start()
		if life < 1:
			if deathTimer < 0:
				deathTimer = maxDeathTimer
				anim.animation = "die"
	if area.get_name() == "Fireballcollision":
		life -= 5.0
		print(life)
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
		

		




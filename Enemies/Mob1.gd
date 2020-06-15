extends KinematicBody2D
var maxlife = 20.0
const maxDamageResetTimer = 40
const maxDeathTimer = 100
const gravity = 800
const floorNormal = Vector2(0, -1)

onready var tween = $"Tween"
onready var lifebar = $"LifeBar"
onready var tweenmove = $"tweenmove"
onready var anim = $"AnimatedSprite"

var vector = Vector2()

var animated_life = 100
var lastAttackID = -1
var life = maxlife
var damageResetTimer = -1
var deathTimer = -1

var onHurtboxArea = false
var playerEnter = false
var targetPlayer
var hitPlayer

var walktimer = 300
var walktimer2 = 0
var change
var gap 


func _ready():
	pass
	
func _process(delta: float) -> void:
	lifebar.value = animated_life
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

	
	#ChasePlayer
	if playerEnter:
		if lifebar.value > 0:
			vector = interceptPlayer(vector)
			gap = (gravity*0.2) - vector.y
			vector.y += gap
	else:
		vector.y += gravity * 0.2
		if deathTimer < 0:
			anim.animation = "move"
			if walktimer >= 0:
				walktimer -= 1
				vector.x = -100
				anim.set_flip_h(false)
			if walktimer == -1:
				if walktimer2 < 300:
					walktimer2 += 1
					vector.x = 100
					anim.set_flip_h(true)
			if walktimer2 == 300:
				change = walktimer
				walktimer = walktimer2
				walktimer2 = change
	move_and_slide(vector * 0.5, floorNormal)
	
		
	#Automove
#	
		
	
	
func getHit(attackID, attackDamage):
	#if onHurtboxArea == true:
	if lastAttackID != attackID:
		lastAttackID = attackID
		life -= attackDamage
		damageResetTimer = maxDamageResetTimer
		#$"LifeBar".value = int((life / maxlife)*100)
		tween.interpolate_property(self, "animated_life", animated_life, int(life/maxlife*100), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
		if not tween.is_active():
			tween.start()
		if life < 1:
			if deathTimer < 0:
				deathTimer = maxDeathTimer
				$"AnimatedSprite".animation = "die"
	
				


func _on_detection_area_entered(area: Area2D) -> void:
	if area.get_name() == "collision":
		playerEnter = true
		targetPlayer = area.get_owner()

func _on_detection_area_exited(area: Area2D) -> void:
	if area.get_name() == "collision":
		playerEnter = false

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.get_name() == "bullet":
		life -= 10
		tween.interpolate_property(self, "animated_life", animated_life, int(life/maxlife*100), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
		if not tween.is_active():
			tween.start()
		if life < 1:
			if deathTimer < 0:
				deathTimer = maxDeathTimer
				$"AnimatedSprite".animation = "die"
				


func _on_mobhit_area_entered(area: Area2D) -> void:
	if area.get_name() == "collision":
		hitPlayer = area.get_owner()
		hitPlayer.beingHit()
		anim.animation = "attack"

func interceptPlayer(vector: Vector2) -> Vector2:
		vector = (targetPlayer.position - self.position)
		if vector.x < 0 :
			anim.set_flip_h(false)
		else:
			anim.set_flip_h(true)
		return vector

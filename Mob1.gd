extends KinematicBody2D
const maxlife = 20.0
const maxDamageResetTimer = 40
const maxDeathTimer = 100

onready var tween = $"Tween"
onready var lifebar = $"LifeBar"

var animated_life = 100
var lastAttackID = -1
var life = maxlife
var damageResetTimer = -1
var deathTimer = -1

var onHurtboxArea = false

func _ready():
	pass
	
func _process(delta: float) -> void:
	lifebar.value = animated_life
	if damageResetTimer > 0:
		damageResetTimer -= 1
		if damageResetTimer == 0:
			lastAttackID = -1
	if deathTimer > 0:
		$"AnimatedSprite".modulate.a = float(deathTimer)/maxDeathTimer
		deathTimer -= 1
		if deathTimer == 0:
			queue_free()
		
	
func getHit(attackID, attackDamage):
	#if onHurtboxArea == true:
	if lastAttackID != attackID:
		lastAttackID = attackID
		life -= attackDamage
		damageResetTimer = maxDamageResetTimer
		#$"LifeBar".value = int((life / maxlife)*100)
		tween.interpolate_property(self, "animated_life", animated_life, int(life/maxlife*100), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
		print(animated_life)
		if not tween.is_active():
			tween.start()
		if life < 1:
			if deathTimer < 0:
				deathTimer = maxDeathTimer
				$"AnimatedSprite".animation = "die"
				
				
func attack(attackID, attackDamage):
	self.attackID = attackID
	self.attackDamage = attackDamage
	

	

#func _on_hurtbox_area_entered(area: Area2D) -> void:
#	if area.is_in_group("sword"):
#		life -= 5
#		tween.interpolate_property(self, "animated_life", animated_life, int(life/maxlife*100), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
#		if not tween.is_active():
#			tween.start()
#		if life < 1:
#			if deathTimer < 0:
#				deathTimer = maxDeathTimer
#				$"AnimatedSprite".animation = "die"
#		#self.queue_free()
#	if area.is_in_group("sword1"):
#		life -= 10
#		tween.interpolate_property(self, "animated_life", animated_life, int(life/maxlife*100), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
#		if not tween.is_active():
#			tween.start()
#		if life < 1:
#			if deathTimer < 0:
#				deathTimer = maxDeathTimer
#				$"AnimatedSprite".animation = "die"
		


		





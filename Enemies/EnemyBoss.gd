extends "res://Enemies/EnemyBase.gd"

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim = $"AnimatedSprite"
	bossAttack = false
	bossMoveSpeed = 0.6
	bosscanAttack = false
	maxlife = 100.0
	
func _process(delta):
	lifebar.value = animated_life
	print(life)
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
		lifebar.rect_position.x = -27
		$"CollisionShape2D".position.x = 10
		$"HitBoxBoss".position.x = 0
		$"HurtBoxBoss".position.x = 10
	else:
		anim.set_flip_h(true)
		lifebar.rect_position.x = -93
		$"CollisionShape2D".position.x = -50
		$"HitBoxBoss".position.x = 35
		$"HurtBoxBoss".position.x = -50
	move_and_slide(vector, vectorNormal)

func pursuit():
	vector = targetPlayer.position - self.position
	if vector.x >= 100 or vector.x <= -100:
		vector.x *= 0.5
		
		
	vector.y += gravity 
	



func _on_HitBoxBoss_area_entered(area: Area2D) -> void:
	if area.get_name() == "collision":
		canAttack = true

func _on_HitBoxBoss_area_exited(area: Area2D) -> void:
	if area.get_name() == "collision":
		canAttack = false


func _on_EnemyBossDetectionRange_area_entered(area: Area2D) -> void:
	if area.get_name() == "collision":
		playerEnter = true
		targetPlayer = area.get_owner()


func _on_EnemyBossDetectionRange_area_exited(area: Area2D) -> void:
	if area.get_name() == "collision":
		playerEnter = false


func _on_HurtBoxBoss_area_entered(area: Area2D) -> void:
	if area.get_name() == "bullet":
		life -= 10
		tween.interpolate_property(self, "animated_life", animated_life, int(life/maxlife*100), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
		if not tween.is_active():
			tween.start()
		if life < 1:
			if deathTimer < 0:
				deathTimer = maxDeathTimer
				$"AnimatedSprite".animation = "die"
	if area.get_name() == "Fireballcollision":
		life -= 7
		tween.interpolate_property(self, "animated_life", animated_life, int(life/maxlife*100), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
		if not tween.is_active():
			tween.start()
		if life < 1:
			if deathTimer < 0:
				deathTimer = maxDeathTimer
				anim.animation = "die"

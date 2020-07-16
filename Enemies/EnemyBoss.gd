extends "res://Enemies/EnemyBase.gd"

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.


func _ready() -> void:
	anim = $"AnimatedSprite"
	bossAttack = false
	bossMoveSpeed = 1
	bosscanAttack = false
	maxlife = 100.0
	life = 100.0
	collision = $"CollisionShape2D"
	maxattackAnimationTime = 30
	MaxspawnsmallMobTimer = 1000
	spawnsmallMobTimer = 0
	
func ownProcess():
	if vector.x < 0:
		anim.set_flip_h(true)
	else:
		anim.set_flip_h(false)
	if deathTimer > 0:
		$HitBoxBoss/CollisionShape2D.disabled = true
		collision.disabled = true
		vector.x = 0
		vector.y = 0
		$"AnimatedSprite".modulate.a = float(deathTimer)/maxDeathTimer
		deathTimer -= 1
		if deathTimer == 70:
			if states.has("Die"):
				states.remove(states.find("Die"))
		if deathTimer == 0:
			queue_free()
			for i in range(5):
				var xp = preload("res://actors/Projectiles/XP.tscn").instance()
				xp.position.x = rand_range(self.position.x - 10, self.position.x + 10)
				xp.position.y = rand_range(self.position.y - 10, self.position.y -5)
				get_parent().add_child(xp)
		else:
			$HitBoxBoss/CollisionShape2D.disabled = false
			collision.disabled = false
	spawnMob()
	.ownProcess()
	
func spawnMob():
		if spawnsmallMobTimer < MaxspawnsmallMobTimer:
			spawnsmallMobTimer += 1
		else:
			spawnsmallMobTimer = 0			
			var mobtank = preload("res://Enemies/EnemyTank1.tscn").instance()
			var mobbat = preload("res://Enemies/EnemyBat1.tscn").instance()
			$RayCastTank.cast_to = Vector2(rand_range(-400,400), rand_range(50,55))
			$RayCastBat.cast_to = Vector2(rand_range(-400,400), rand_range(10,-200))
			if $RayCastTank.is_colliding():
				while $RayCastTank.is_colliding():
					$RayCastTank.cast_to = Vector2(rand_range(-400,400), rand_range(50,55))
			else:
				mobtank.position = self.position + $RayCastTank.cast_to
				get_tree().root.get_node("level2").add_child(mobtank)
			if $RayCastBat.is_colliding():
				while $RayCastBat.is_colliding():
					$RayCastBat.cast_to = Vector2(rand_range(-400,400), rand_range(10,-200))
			else:
				if $RayCastBat.cast_to.x >= 0.0:
					$RayCastBat.cast_to.x -= 100
				else:
					$RayCastBat.cast_to.x += 100
				mobbat.position.x = self.position.x + $RayCastBat.cast_to.x
				mobbat.position.y = self.position.y + $RayCastBat.cast_to.y + 50
				get_tree().root.get_node("level2").add_child(mobbat)

func pursuit():
	vector = targetPlayer.position - self.position
#	if vector.x >= 100 or vector.x <= -100:
#		vector.x *= 1		
	vector.y += gravity * 0.4
	
func patrol():
	vector.y += gravity * 0.02
	.patrol()
	



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
		life -= 5
		tween.interpolate_property(self, "animated_life", animated_life, int(life/maxlife*100), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
		if not tween.is_active():
			tween.start()
		if life < 1:
			if deathTimer < 0:
				deathTimer = maxDeathTimer
				anim.animation = "die"

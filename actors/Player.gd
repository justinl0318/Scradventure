extends KinematicBody2D

var gravity = 800
const gravity2 = 10
const floorNormal = Vector2(0,-1)
const Fireball = preload("res://actors/Projectiles/Fireball.tscn")
const attackTimerMax = [40, 40, 80]
const attackComboMax = 3
const shootingTimerMax = 80
const attackDamge = [5,6,10]
const dashTimerMax = 20

var dashTimer = 0
var moveSpeed = 300
var jumpForce = 500

var vector = Vector2()
onready var pos = $"PositionProjectile"
onready var anim = $"AnimatedSprite"
onready var portalPos = $"PositionPortal"
var states = []
onready var DebugLabel = $"DebugLabel"
onready var lifebar = $"lifebar"

var jumpCount = 0

var shootingDirection = 1
var shootingTimer = 0


var attackCombo = 0
var attackBuffer = 0
var attackTimer = attackTimerMax[attackCombo]

var portals = []
var teleportcooldownTimer = 100
var touchPortal = false
var portalname 

var hitboxEnter = false
var targetEnemy 

var currentXp = 0
var level = 1
var maxXp = 100
var xp = 0

var mana = 0
var currentmana = 0

var life = 100
var currentlife = 100


func _ready():
	pass


func _physics_process(delta):
	
	
	
	if Input.is_action_just_pressed("slide"):
		if not states.has("dash") and states.has("run"):
			anim.modulate.a = 0.5
			states.append("dash")
			moveSpeed = 700
	if states.has("dash"):
		if dashTimer >= dashTimerMax:
			dashTimer = 0
			states.remove(states.find("dash"))
			moveSpeed = 300
			anim.modulate.a = 1
		else:
			dashTimer += 1
	#gravity
	if states.has("jump") and states.has("attack") and attackCombo != 2:
		vector.y = gravity2 * delta
	else:
		vector.y += gravity * delta
	
	vector.x = 0
	if Input.is_action_pressed("ui_right"):
		if not states.has("run"):
			states.append("run")
		vector.x += moveSpeed
		anim.set_flip_h(false)
		if sign(pos.position.x) == -1:
			pos.position.x *= -1
		shootingDirection = 1
	elif Input.is_action_pressed("ui_left"):
		if not states.has("run"):
			states.append("run")
		vector.x += -moveSpeed
		anim.set_flip_h(true)	
		if sign(pos.position.x) == 1:
			pos.position.x *= -1
		shootingDirection = -1
	else:
		if states.has("run"):
			states.remove("run")

	if states.has("attack"):
		vector.x *= 0.1

#Process Movement
	vector = move_and_slide(vector, floorNormal)
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		if "Mob1" in collision.collider.name or "Enemy" in collision.collider.name:
#			if states.has("attack") and hitboxEnter == true:
#				collision.collider.getHit(attackCombo,attackDamge[attackCombo])
				
#shooting
	if Input.is_action_just_pressed("rasengan"):
		if $"ManaBar".value >= 20:
			if not states.has("shooting"):
				states.append("shooting")
				shoot()
				mana = currentmana
				mana -= 20
				$"Tween".interpolate_property(self, "currentmana", currentmana, mana, 1, Tween.TRANS_BACK, Tween.EASE_OUT)
				if not $"Tween".is_active():
					$"Tween".start()

	
	if states.has("shooting"):
		moveSpeed = 0
		gravity = 10
		vector.y = 0
		if shootingTimer > shootingTimerMax:
			shootingTimer = 0
			states.remove(states.find("shooting"))
		else:
			shootingTimer += 1
	if not states.has("shooting") and not states.has("dash"):
		moveSpeed = 300
		gravity = 800

#Jump movement
	if states.empty() or states == ["run"]:
		if Input.is_action_pressed("ui_jump"):
			if jumpCount < 2:
				jumpCount += 1
				vector.y = -jumpForce
	if is_on_floor():
		jumpCount = 0
		if states.has("jump"):
			states.remove("jump")
	else:
		if not states.has("jump"):
			states.append("jump")
			
#attack 
	if Input.is_action_just_pressed("combo"):
		if attackBuffer < 3:
			attackBuffer += 1
		if not states.has("attack"):
			states.append("attack")
	if states.has("attack"):
		attackTimer -= 1
		if attackTimer <= 0:
			attackBuffer -= 1
			attackTimer = 40
			attackCombo += 1
		if attackCombo == 3 or attackBuffer == 0:
			states.remove("attack")
			attackCombo = 0
			attackBuffer = 0
		
#Shooting
	if Input.is_action_just_pressed("fireball"):
		var fireball = Fireball.instance()
		if shootingDirection == 1:
			fireball.set_fireball_direction(1)
		else:
			fireball.set_fireball_direction(-1)
		get_parent().add_child(fireball)
		fireball.position = pos.global_position

	
#Portal
	if Input.is_action_just_pressed("shootPortal"):
		var portal = preload("res://actors/Projectiles/Portal.tscn").instance()
		portals.append(portal)
		if portals.size() > 2:
			portals.front().queue_free()
			portals.remove(0)
		if shootingDirection == 1:
			portal.set_portal_direction(1)
		else:
			portal.set_portal_direction(-1)
		get_parent().add_child(portal)
		portal.position = pos.global_position

	teleportcooldownTimer -= 1
	if teleportcooldownTimer < 0:	
		if touchPortal == true:
			if portals.size() > 1:
				var targetPortal
				if portalname == portals[0]:
					targetPortal = portals[1]
				elif portalname == portals[1]:
					targetPortal = portals[0]			
				self.position.x = targetPortal.position.x
				self.position.y = targetPortal.position.y - 50
				teleportcooldownTimer = 100
					

	if shootingDirection == 1:
		$hitbox/CollisionShape2D.position.x = 27
	else:
		$hitbox/CollisionShape2D.position.x = -27

	if states.has("attack"):
		if hitboxEnter:
			targetEnemy.getHit(attackCombo,attackDamge[attackCombo])

#XP
	checklevelUp()
	$"XPbar".value = currentXp
	$"level".text = str(level)
	$"lifebar".value = life
	
#Mana
	if states.empty():
		if currentmana <= 100:
			currentmana += 0.3
	
	if currentmana >= 100:
		$"manacharge".enabled = false
	else:
		$"manacharge".enabled = true
		
	$"ManaBar".value = currentmana
		
			
	
#label
	var stateString = ""
	for state in states:
		stateString += state + " "
	DebugLabel.text = stateString + str(hitboxEnter)
	
#Lighting
	if states.has("attack"):
		$"Light2D".enabled = true
	else:
		$"Light2D".enabled = false
		
	#$"Music".play()
	

#Animation  

	var animName = "idle"
	if states.has("run"):
		animName = "run"
	if states.has("jump"):
		animName = "jump"
	if states.has("dash"):
		animName = "slide"
	if states.has("attack"):
		if states.has("jump"):		
			animName = "airattack" + str(attackCombo)
		else:
			animName = "attack" + str(attackCombo)
	if states.has("shooting"):
		animName = "shoot"

	
	anim.animation = animName
	
	
	
func shoot():
	var rasengan = preload("res://actors/Projectiles/Rasengan.tscn").instance()
	rasengan.setDirection(shootingDirection)
	rasengan.setLaunchTimer(shootingTimerMax)
	rasengan.position = self.position
	rasengan.position.x += 60 * shootingDirection
	get_parent().add_child(rasengan)
	
func isInAction():
	if states.has("attacking") or states.has("shooting"):
		return true
	else:
		return false
		

func _on_hitbox_area_entered(area: Area2D) -> void:
	
	if area.get_name() == "hurtbox":
		hitboxEnter = true
		targetEnemy = area.get_owner()
	#targetEnemy = area.get_owner()
#	area.get_owner().getHit(attackCombo,attackDamge[attackCombo])

func _on_hitbox_area_exited(area: Area2D) -> void:
	hitboxEnter = false
	
func beingHit():
	currentlife = life
	life -= 20
	$"Tween".interpolate_property(self, "life", currentlife, life, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not $"Tween".is_active():
		$"Tween".start()

func _on_collision_area_entered(area: Area2D) -> void:
	if area.get_name() == "Xpcollision":
		xp = currentXp
		currentXp += 20
		area.get_owner().queue_free()
		area.get_owner().playSound()
		$"XP".play(0)
		$"Tween".interpolate_property(self, "xp", xp, currentXp, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		if not $"Tween".is_active():
			$"Tween".start()
	if area.get_name() == "Portalcollision":
		touchPortal = true
		portalname = area.get_owner()

func _on_collision_area_exited(area: Area2D) -> void:
	if area.get_name() == "Portalcollision":
		touchPortal = false
			
func checklevelUp():
	if currentXp >= maxXp:
		level += 1
		maxXp += (currentXp * 0.1)
		currentXp = 0
		$"XPbar".max_value = maxXp
	

	
		
		






extends KinematicBody2D

var gravity = 800
const gravity2 = 10
const floorNormal = Vector2(0,-1)
const Fireball = preload("res://Projectiles/Fireball.tscn")
const attackTimerMax = [40, 40, 80]
const attackComboMax = 3
const shootingTimerMax = 80
const attackDamge = [5,6,10]
const dashTimerMax = 20

var dashTimer = 0
var moveSpeed = 300
var jumpForce = 500

var vector = Vector2()
onready var pos = $"PositionFireball"
onready var anim = $"AnimatedSprite"
onready var portalPos = $"PositionPortal"
onready var posrasengan = $"PositionRasengan"
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

var hitboxEnter = false
var targetEnemy 


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
		if sign(portalPos.position.x) == -1:
			portalPos.position.x *= -1
		shootingDirection = 1
	elif Input.is_action_pressed("ui_left"):
		if not states.has("run"):
			states.append("run")
		vector.x += -moveSpeed
		anim.set_flip_h(true)	
		if sign(pos.position.x) == 1:
			pos.position.x *= -1
		if sign(portalPos.position.x) == 1:
			portalPos.position.x *= -1
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
		if not states.has("shooting"):
			states.append("shooting")
			shoot()

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
		if sign(pos.position.x) == 1:
			fireball.set_fireball_direction(1)
		else:
			fireball.set_fireball_direction(-1)
		get_parent().add_child(fireball)
		fireball.position = pos.global_position
		
		

	
#Portal
	if Input.is_action_just_pressed("shootPortal"):
		var portal = preload("res://Projectiles/Portal.tscn").instance()
		portals.append(portal)
		if portals.size() > 2:
			portals.front().queue_free()
			portals.remove(0)
		if sign(portalPos.position.x) == 1:
			portal.set_portal_direction(1)
		else:
			portal.set_portal_direction(-1)
		get_parent().add_child(portal)
		portal.position = portalPos.global_position
	
	teleportcooldownTimer -= 1
	if teleportcooldownTimer < 0:
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.name != "TileMap" and collision.collider.name != "TileMap2" and collision.collider.name != "Mob1" and collision.collider.name != "Rasengan":
				if portals.size() > 1:
					var targetPortal 
					if collision.collider == portals[0]:
						targetPortal = portals[1]
					elif collision.collider == portals[1]:
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
	var rasengan = preload("res://Projectiles/Rasengan.tscn").instance()
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
	lifebar.value -= 20




extends KinematicBody2D

var speed = 200
const dyingTimerMax = 400.0

var velocity = Vector2()
var launchTimer = 1
var launchTimerTemp = 1
var direction = 1
var dyingTimer = 0.0

onready var anim = $"AnimatedSprite"
onready var light = $"Light2D"
onready var particlesOrbit = $"ParticlesOrbit"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if launchTimerTemp <= 0:
		self.velocity.x += delta * speed * direction
	else:
		self.launchTimerTemp -= 1
		var opacity = float(launchTimer - launchTimerTemp)/launchTimer
		self.anim.modulate.a = opacity
		self.anim.scale = Vector2(1 + opacity, 1 + opacity)
		self.particlesOrbit.get_process_material().set("emission_sphere_radius", 36 + launchTimerTemp)
#		print(launchTimerTemp)
		$"CollisionShape2D".scale = Vector2(1 + opacity, 1 + opacity)
		
	if is_on_wall():
		if dyingTimer >= dyingTimerMax:
			self.queue_free()
		else:
			self.dyingTimer += 1
			self.velocity.x = 0
			self.anim.modulate.a = (dyingTimerMax-dyingTimer)/dyingTimerMax
#			self.particlesOrbit.get_process_material().set("emission_sphere_radius", 36 - ((dyingTimerMax-dyingTimer)/dyingTimerMax) * 36)
#			$"WorldEnvironment".environment.set("glow_strength", 1 + (dyingTimer/dyingTimerMax * 0.35))
	self.move_and_slide(velocity)

	
func setDirection(direction:int):
	self.direction = direction

func setLaunchTimer(time:int):
	self.launchTimer = time
	self.launchTimerTemp = time
extends KinematicBody2D
var throwSpeed = 300
var vector = Vector2()
var gravityPortal = 8
var direction = 1
var initialVelocity = -300
var floorNormal = Vector2(0,-1)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_portal_direction(dir):
	direction = dir
	if direction == -1:
		$"AnimatedSprite".flip_h = true
	else:
		$"AnimatedSprite".flip_h = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_on_floor():
		vector.x = 0
		$"AnimatedSprite".rotation_degrees = -90
		$"AnimatedSprite".scale = Vector2(0.04, 0.1)
		$"CollisionShape2D".rotation_degrees = -90
	else:
		vector.x = throwSpeed * delta * direction
	if is_on_wall():
		vector.y = 0
		$"AnimatedSprite".scale = Vector2(0.04, 0.1)
		$"AnimatedSprite".rotation_degrees = 0
	else:
		initialVelocity += gravityPortal
		vector.y = initialVelocity * delta
	if is_on_ceiling():
		vector.y = 0
		vector.x = 0
		$"AnimatedSprite".rotation_degrees = -90
		$"CollisionShape2D".rotation_degrees = -90
		$"AnimatedSprite".scale = Vector2(0.04, 0.1)
				
	
	vector = move_and_slide(vector, floorNormal)		
	translate(vector)
	
	
	if isFlying():
		$"AnimatedSprite".scale = Vector2(0.02, 0.02)
	
func isFlying():
	if vector.x != 0 and vector.y != 0:
		return true
	else:
		return false


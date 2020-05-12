extends Area2D
var moveSpeed = 400
var vector = Vector2()
var direction = 1
var shootTimer = 1


func _ready():
	$Particles2D.process_material.gravity = Vector3(50,0,0)
	$Particles2D.process_material.gravity = Vector3(-50,0,0)
	
func set_fireball_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true
		$Particles2D.process_material.gravity = Vector3(50,0,0)
	else:
		$Particles2D.process_material.gravity = Vector3(-50,0,0)
		
		

func _physics_process(delta):
	vector.x = moveSpeed * delta * direction
	translate(vector)
	
			
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func _on_Fireball_body_entered(body):
	queue_free()

extends "res://Enemies/Mob2.gd"

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.maxlife = 50.0
	self.life = self.maxlife

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func getHit(attackID, attackDamage):
	.getHit(attackID, attackDamage)

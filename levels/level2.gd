extends Node2D
var currentlevel = "level2"
onready var player = $Player

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	$Music.play()
	$ParallaxBackground/ParallaxLayer/Sprite.modulate.a = 0.5	
	var global = get_tree().root.get_node("global")
	player.life = global.life
	player.currentmana = global.mana
	player.currentXp = global.xp
	player.maxXp = global.maxxp
	player.level = int(global.level)
	player.currentlevel = "level2"
	
#	print($Player/level.text)
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_Music_finished() -> void:
	$Music.play()
	
func _process(delta: float) -> void:
	$Interface/MarginContainer/HBoxContainer2/VBoxContainer/LifeBar.value = player.life
	$Interface/MarginContainer/HBoxContainer2/VBoxContainer/ManaBar.value = player.currentmana
	$Interface/MarginContainer/HBoxContainer2/VBoxContainer/XPBar.max_value = player.currentXp
	$Interface/MarginContainer/HBoxContainer2/VBoxContainer/XPBar.value = player.maxXp
	$Interface/MarginContainer/HBoxContainer2/VBoxContainer/XPBar/Label.text = str(player.level)
	$Player/level.text = str(global.level)
	if not has_node("EnemyBoss1") and not has_node("EnemyBoss2"):
		get_tree().change_scene("res://UI/YouWin.tscn")
	

	

	
	

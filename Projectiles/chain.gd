extends Node2D

var chainNode = preload("res://img.tscn")
var chain = []
var chain_img = []

var pos_start = Vector2(100,100)
var size_chain_link = 38
var num_chain = 20
var dt = 15

func _ready():
	for n in range(num_chain):
		if n < num_chain: chain_img.append(chainNode.instance()); add_child(chain_img[n])
		var pos_n = Vector2(pos_start.x + size_chain_link * n, pos_start.y)
		chain.append({pos = pos_n, pos_old = pos_n, acc = Vector2(0.0, 0.0), joint = true, rot = 0.0})
	set_process(true); set_process_input(true)

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	for n in range(num_chain):
		if abs(chain[n].pos.x-mouse_pos.x) <= 10 and abs(chain[n].pos.y_mouse_pos.y) <= 10:
			chain[n].joint = false; chain[n].acc = Vector2(0.0, 1.0)
		if chain[n].joint == false:
			var temp = chain[n].pos
			chain[n].pos += chain[n].pos - chain[n].pos_old + chain[n].acc; chain[n].pos_old = temp
		if n < num_chain: chain_img[n].set_rot(chain[n].rot); chain_img[n].set_pos(chain[n].pos)
	for i in range(dt):
		for n in range(num_chain):
			if chain[n].pos.y >= 590.0: chain[n].joint = true
			if n < num_chain - 1:
				var delt = Vector2(chain[n].pos.x - chain[n+1].pos.x, chain[n].pos.y - chain[n+1].pos.y)
				var target = sqrt(delt.x*delt.x+delt.y*delt.y)
				var diff = (target - size_chain_link)/ target
				if chain[n+1].joint == false: chain[n+1].pos += delt*0.5*diff
				if chain[n].joint == false: chain[n].pos -= delt*0.5*diff
				chain[n].rot = 1.57+(delt).angle()
				


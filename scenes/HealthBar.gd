extends Node2D

var player = null

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	var err = player.connect("hurt", self, "on_hurt")
	if err:
		print("Failed connect hurt: ", err)

func on_hurt():
	var count = 1
	for child in get_children():
		child.modulate.a = 1.0
		if player.cur_health < count:
			child.modulate.a = 0.25
		count += 1

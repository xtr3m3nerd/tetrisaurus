extends Node2D

onready var shape_spawn = $VBoxContainer/Shape/Spawn
var shape: Shape0 = null
var shapes = []

func set_shapes(_shapes):
	shapes = _shapes

func set_shape(num, rot, types):
	if shape != null:
		shape_spawn.remove_child(shape)
	shape = shapes[num].instance()
	shape.types = types
	shape.rotate_position = rot
	shape.is_fixed = true
	shape.disable_inactivate()
	shape_spawn.add_child(shape)

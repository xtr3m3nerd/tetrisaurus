extends Node

signal inact_shape
signal add_points

var inactive=[]
var inactive_blocks=[]
var points = 0
var speed = 0.1
const BLOCK_SIZE = 64
const MAP_WIDTH = BLOCK_SIZE * 10
const MAP_HEIGHT = BLOCK_SIZE * 20

func inactivate_shape():
	emit_signal("inact_shape")

func add_points():
	points += 100
	if points%100==0 and speed>0.1:
		speed -= 0.1
	emit_signal("add_points")

func restart_game():
	speed=1
	points=0
	inactive.clear()
	inactive_blocks.clear()
	get_tree().reload_current_scene()
	

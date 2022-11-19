extends Node

signal inact_shape
signal add_points

var inactive=[]
var inactive_blocks=[]
var points = 0
var min_speed = 0.5
var max_speed = 0.1
var max_speed_points = 4000
var speed = 0.5
const BLOCK_SIZE = 64
const MAP_WIDTH = BLOCK_SIZE * 10
const MAP_HEIGHT = BLOCK_SIZE * 20

func inactivate_shape():
	emit_signal("inact_shape")

func add_points(amnt):
	points += amnt
	if points < max_speed_points:
		speed = min_speed + (max_speed - min_speed) * (points / max_speed_points)
	else:
		speed = max_speed
	if points%100==0 and speed>0.1:
		speed -= 0.025
	emit_signal("add_points")

func restart_game():
	print("restart_game")
	speed = min_speed
	points = 0
	inactive.clear()
	inactive_blocks.clear()
	var err = get_tree().reload_current_scene()
	if err:
		print("Failed to restart scene: ", err)
	

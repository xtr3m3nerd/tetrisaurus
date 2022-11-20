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


var high_score_file: ConfigFile
var high_score = 0;

func _ready():
	load_highscore()

func inactivate_shape():
	emit_signal("inact_shape")

func add_points(amnt):
	var player = get_tree().get_nodes_in_group("player")[0]
	if player.dead:
		return
	points += amnt
	if points > high_score:
		set_high_score(points)
	if points < max_speed_points:
		speed = min_speed + (max_speed - min_speed) * (float(points) / float(max_speed_points))
	else:
		speed = max_speed
#	if points%100==0 and speed>0.1:
#		speed -= 0.025
	emit_signal("add_points")

func restart_game():
	print("restart_game")
	speed = min_speed
	points = 0
	inactive.clear()
	inactive_blocks.clear()
	save_high_score()
	var err = get_tree().reload_current_scene()
	if err:
		print("Failed to restart scene: ", err)

func load_highscore():
	high_score_file = ConfigFile.new()
	var err = high_score_file.load("user://highscore.cfg")
	if err == OK:
		_load_highscore()

func _load_highscore():
	high_score = high_score_file.get_value("User", "HighScore", high_score)
	set_high_score(high_score)

func save_high_score():
	var err = high_score_file.save("user://highscore.cfg")
	if err:
		print("Failed save highscore: ", err)

func set_high_score(score):
	high_score = score
	high_score_file.set_value("User", "HighScore", score)

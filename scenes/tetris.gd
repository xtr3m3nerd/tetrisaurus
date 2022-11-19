extends Node2D

onready var shape1 = preload("res://shapes/Shape1.tscn")
onready var shape2 = preload("res://shapes/Shape2.tscn")
onready var shape3 = preload("res://shapes/Shape3.tscn")
onready var shape4 = preload("res://shapes/Shape4.tscn")
onready var shape5 = preload("res://shapes/Shape5.tscn")
var shapes = []
var shape
var active_block=false
var rnd=RandomNumberGenerator.new()
var num: int = -1
var rot: int = -1
var next_num: int = 0
var next_rot: int = 0
var player = null
var can_control = false

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	shapes = [ shape1, shape2, shape3, shape4, shape5 ]
	rnd.randomize()

func _on_Timer_timeout():
	$Timer.wait_time=Globals.speed
	if not active_block:
		num = rnd.randi() % shapes.size() if num == -1 else next_num
		next_num = rnd.randi() % shapes.size()
		rot = rnd.randi() % 4 if rot == -1 else next_rot
		next_rot = rnd.randi() % 4
		#$NextShapePanel/VBoxContainer/Control/Sprite.frame=next_num
		shape = shapes[num].instance()
		shape.rotate_position = rot
		$ShapesArea.add_child(shape)
		var player_x = int(player.position.x) / Globals.BLOCK_SIZE * Globals.BLOCK_SIZE
		shape.position = Vector2(player_x, 0)
		shape.fix_x_position()
		active_block = true
	else:
		move_down()

func move_left():
	if active_block:
		shape.move_left()

func move_right():
	if active_block:
		shape.move_right()

func move_down():
	if active_block:
		shape.move_down()
		$Timer.start()

func _input(_event):
	if not can_control:
		return
	if shape:
		if Input.is_action_just_pressed("ui_right"):
			move_right()
		if Input.is_action_just_pressed("ui_left"):
			move_left()
		if Input.is_action_just_pressed("ui_down"):
			move_down()
		if Input.is_action_just_pressed("ui_up"):
			shape.rotate_it()

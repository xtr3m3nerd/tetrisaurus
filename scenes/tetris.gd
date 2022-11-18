extends Node2D

onready var shape1 = preload("res://shapes/Shape1.tscn")
onready var shape2 = preload("res://shapes/Shape2.tscn")
var shapes = []
var shape
var active_block=false
var rnd=RandomNumberGenerator.new()
var num: int = -1
var next_num: int = 0

func _ready():
	shapes = [ shape1, shape2 ]
	rnd.randomize()

func _on_Timer_timeout():
	$Timer.wait_time=Globals.speed
	if not active_block:
		num = rnd.randi() % shapes.size() if num == -1 else next_num
		next_num = rnd.randi() % shapes.size()
		#$NextShapePanel/VBoxContainer/Control/Sprite.frame=next_num
		shape = shapes[num].instance()
		$ShapesArea.add_child(shape)
		shape.position = Vector2(Globals.BLOCK_SIZE*4, Globals.BLOCK_SIZE)
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

func _input(event):
	if shape:
		if Input.is_action_just_pressed("ui_right"):
			move_right()
		if Input.is_action_just_pressed("ui_left"):
			move_left()
		if Input.is_action_just_pressed("ui_down"):
			move_down()
		if Input.is_action_just_pressed("ui_up"):
			shape.rotate_it()

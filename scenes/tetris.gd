extends Node2D

onready var shape1 = preload("res://shapes/Shape1.tscn")
onready var shape2 = preload("res://shapes/Shape2.tscn")
onready var shape3 = preload("res://shapes/Shape3.tscn")
onready var shape4 = preload("res://shapes/Shape4.tscn")
onready var shape5:PackedScene = preload("res://shapes/Shape5.tscn")

onready var next_shape_panel = $NextShapePanel
var shapes = []
var shape
var active_block=false
var rnd=RandomNumberGenerator.new()
var num: int = -1
var rot: int = -1
var next_num: int = 0
var next_rot: int = 0
var types = []
var next_types = []
var player = null
var can_control = false

var weights = {
	block.TYPE.ROCK: 5,
	block.TYPE.LAVA: 1,
	block.TYPE.SAND: 5,
}

var num_blocks = []

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	shapes = [ shape1, shape2, shape3, shape4, shape5 ]
	num_blocks = [ 1, 2, 3, 4, 4]
	next_shape_panel.set_shapes(shapes)
	rnd.randomize()

func _on_Timer_timeout():
	$Timer.wait_time=Globals.speed
	if not active_block:
		num = rnd.randi() % shapes.size() if num == -1 else next_num
		next_num = rnd.randi() % shapes.size()
		rot = rnd.randi() % 4 if rot == -1 else next_rot
		next_rot = rnd.randi() % 4
		types = gen_block_types(num_blocks[num]) if types == [] else next_types
		next_types = gen_block_types(num_blocks[next_num])
		next_shape_panel.set_shape(next_num, next_rot, next_types)
		shape = shapes[num].instance()
		shape.types = types
		shape.rotate_position = rot
		$ShapesArea.add_child(shape)
		var player_x = int(player.position.x) / Globals.BLOCK_SIZE * Globals.BLOCK_SIZE
		if player.dead:
			player_x = (randi() % (Globals.MAP_WIDTH/Globals.BLOCK_SIZE)) * Globals.BLOCK_SIZE
		shape.position = Vector2(player_x, 0)
		shape.fix_x_position()
		active_block = true
	else:
		move_down()

func gen_block_types(blocks):
	var results = []
	for n in blocks:
		results.append(gen_block_type())
	return results

func gen_block_type():
	var total = 0
	var keys = weights.keys()
	for key in keys:
		total += weights.get(key)
	var type_pick = randi() % total
	total = 0
	for key in keys:
		total += weights.get(key)
		if type_pick < total:
			return key
	return block.TYPE.ROCK

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
	if shape:
		if Input.is_action_pressed("ui_down"):
			move_down()
		if not can_control:
			return
		if Input.is_action_just_pressed("ui_right"):
			move_right()
		if Input.is_action_just_pressed("ui_left"):
			move_left()
		if Input.is_action_just_pressed("ui_up"):
			shape.rotate_it()


func _on_RestartButton_pressed():
	Globals.restart_game()


func _on_ReturnToMenuButton_pressed():
	Globals.restart_game()
	SceneManager.set_current_scene("res://menus/MainMenu.tscn")

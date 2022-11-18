extends Node2D
class_name Shape0

var rotate_position=0
var is_fixed=false

var rotation_matrix=[]
var create_position: Vector2 = Vector2.ZERO

func draw_shape():
	var ind=0
	for child in get_children():
		child.position=rotation_matrix[rotate_position][ind]
		ind+=1

func rotate_it():
	if not is_fixed:
		rotate_shape()

func rotate_shape():
	var can_rotate=true
	var child_pos=0
	for child in get_children():
		if not child.can_rotate(rotation_matrix[rotate_position][child_pos]):
			return
		child_pos+=1
	if can_rotate:
		var j=0
		for child in get_children():
			child.position=rotation_matrix[rotate_position][j]
			j+=1
		rotate_position=rotate_position+1 if rotate_position<3 else 0

func inactivate_it():
	if position == create_position:
		get_tree().reload_current_scene()
	for child in get_children():
		child.inactivate_it()

func move_left():
	if not is_fixed:
		for child in get_children():
			if not child.can_move_left():
				return
		position.x -= Globals.BLOCK_SIZE
		print(position)

func move_right():
	if not is_fixed:
		for child in get_children():
			if not child.can_move_right():
				return
		position.x += Globals.BLOCK_SIZE
		print(position)

func move_down():
	if not create_position: 
		create_position = position
	if not is_fixed:
		for child in get_children():
			if not child.can_move_down():
				print("create position: %s e position: %s"%[create_position, position])
				if create_position==position:
					Globals.restart_game()
				is_fixed=true
				return
		position.y += Globals.BLOCK_SIZE
		print(position)

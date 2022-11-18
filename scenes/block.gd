extends Node2D

var is_active=false

func _ready():
	is_active=true
	Globals.connect("inact_shape", self, "inactivate_it")

func inactivate_it():
	if is_active:
		get_parent().is_fixed=true
		is_active=false
		get_tree().root.get_node("Tetris").active_block=false
		Globals.inactive.append(get_parent().position+position)
		Globals.inactive_blocks.append(self)
		Globals.inactivate_shape()
		check_full_line()

func can_rotate(val) -> bool:
	var parent_pos = get_parent().position
	var new_pos = parent_pos+val
	return not (Globals.inactive.has(new_pos) or is_off_screen(new_pos))
	
func is_off_screen(vec) -> bool:
	var map_rect = get_parent().get_parent().get_rect()
	if vec.x < 0 or vec.x >= map_rect.size.x:
		return true
	if vec.y < 0 or vec.y >= map_rect.size.y:
		return true
	return false

func can_move_down() -> bool:
	var parent_pos = get_parent().position
	var down_pos = parent_pos + position + Vector2(0,Globals.BLOCK_SIZE)
	#if parent_pos.x + position.x == 0 or Globals.inactive.has(down_pos) or parent_pos.y + position.y == Globals.MAP_HEIGHT:
	if Globals.inactive.has(down_pos) or parent_pos.y + position.y == Globals.MAP_HEIGHT:
		inactivate_it()
		return false
	else:
		return true

func can_move_left() -> bool:
	var parent_pos = get_parent().position
	var left_pos = parent_pos + position + Vector2(-Globals.BLOCK_SIZE,0)
	return not (parent_pos.x + position.x == 0 or Globals.inactive.has(left_pos) or not is_active)
	
func can_move_right() -> bool:
	var parent_pos = get_parent().position
	var right_pos = parent_pos + position + Vector2(Globals.BLOCK_SIZE,0)
	return not (right_pos.x == Globals.MAP_WIDTH or Globals.inactive.has(right_pos) or not is_active)
	
func check_full_line():
	var index=0
	var count=0
	var positions_to_erase=[]
	var blocks_to_shift=[]
	
	for i in Globals.inactive:
		if i.y==get_parent().position.y+position.y:
			positions_to_erase.append(index)
			count+=1
		index+=1
	if count==10:
		destroy_line(positions_to_erase)
		index=0
		for i in Globals.inactive:
			if i.y<get_parent().position.y+position.y:
				blocks_to_shift.append(index)
			index+=1
		shift_blocks(blocks_to_shift)

func destroy_line(positions_to_erase):
	Globals.add_points()
	var line_vals = positions_to_erase
	for i in range(line_vals.size()-1,-1,-1):
		Globals.inactive.remove(line_vals[i])
		Globals.inactive_blocks[line_vals[i]].destroy_block()
		Globals.inactive_blocks.remove(line_vals[i])

func shift_blocks(blocks):
	for i in blocks:
		Globals.inactive[i].y += Globals.BLOCK_SIZE
		Globals.inactive_blocks[i].position.y += Globals.BLOCK_SIZE
		
func destroy_block():
	queue_free()
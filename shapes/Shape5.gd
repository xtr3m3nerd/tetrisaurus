extends Shape0
class_name Shape5

func _ready():
	rotation_matrix=[
		[Vector2(-Globals.BLOCK_SIZE,0), Vector2(0,0), Vector2(-Globals.BLOCK_SIZE,-Globals.BLOCK_SIZE), Vector2(0,-Globals.BLOCK_SIZE)],
		[Vector2(0,-Globals.BLOCK_SIZE), Vector2(-Globals.BLOCK_SIZE,0), Vector2(0,0), Vector2(-Globals.BLOCK_SIZE,-Globals.BLOCK_SIZE)],
		[Vector2(-Globals.BLOCK_SIZE,-Globals.BLOCK_SIZE), Vector2(0,-Globals.BLOCK_SIZE), Vector2(-Globals.BLOCK_SIZE,0), Vector2(0,0)],
		[Vector2(0,0), Vector2(-Globals.BLOCK_SIZE,-Globals.BLOCK_SIZE), Vector2(0,-Globals.BLOCK_SIZE), Vector2(-Globals.BLOCK_SIZE,0)],
	]
	draw_shape()
	rotate_position=1

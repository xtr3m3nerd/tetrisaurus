extends Shape0
class_name Shape2

func _ready():
	rotation_matrix=[
		[Vector2(0,0), Vector2(-Globals.BLOCK_SIZE,0)],
		[Vector2(0,-Globals.BLOCK_SIZE), Vector2(0,0)],
		[Vector2(0,0), Vector2(-Globals.BLOCK_SIZE,0)],
		[Vector2(0,-Globals.BLOCK_SIZE), Vector2(0,0)],
		#[Vector2(-Globals.BLOCK_SIZE,-Globals.BLOCK_SIZE), Vector2(-Globals.BLOCK_SIZE,0)],
		#[Vector2(0,-Globals.BLOCK_SIZE), Vector2(0,-Globals.BLOCK_SIZE)],
	]
	draw_shape()

extends Node2D

func _ready():
	add_points()
	var err = Globals.connect("add_points", self, "add_points")
	if err:
		print("Failed to restart scene: ", err)

func add_points():
	$RichTextLabel.bbcode_text = str(Globals.points).pad_zeros(6)

extends Node2D

func _ready():
	add_points()
	var err = Globals.connect("add_points", self, "add_points")
	if err:
		print("Failed to connect to add_points: ", err)

func add_points():
	$Label.text = str(Globals.speed)

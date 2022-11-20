extends Control


func _input(_event):
	if Input.is_action_pressed("restart"):
		Globals.restart_game()

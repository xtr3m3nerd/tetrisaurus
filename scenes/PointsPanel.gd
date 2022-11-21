extends Node2D

func _ready():
	add_points()
	var err = Globals.connect("add_points", self, "add_points")
	if err:
		print("Failed to connect to add_points: ", err)
	if SettingsManager.difficulty == SettingsManager.DIFFICULTY.EASY:
		$VBoxContainer/HighScoreLabel.text = "Highscore: (Easy)"
	if SettingsManager.difficulty == SettingsManager.DIFFICULTY.HARD:
		$VBoxContainer/HighScoreLabel.text = "Highscore: (Hard)"

func add_points():
	$VBoxContainer/Points.text = str(Globals.points).pad_zeros(6)
	$VBoxContainer/HighScore.text = str(Globals.high_score).pad_zeros(6)

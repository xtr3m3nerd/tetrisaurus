extends Control


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Buttons/StartButton.grab_focus()
	if OS.get_name() == "Web":
		$Buttons/QuitButton.hide()
	MusicManager.play_music(MusicManager.MUSIC.MENU)
	$DifficultyBox/EasyCheckbox.pressed = SettingsManager.difficulty == SettingsManager.DIFFICULTY.EASY
	$DifficultyBox/HardCheckbox.pressed = SettingsManager.difficulty == SettingsManager.DIFFICULTY.HARD


func _on_quit_button_pressed():
	GameManager.quit_game()


func _on_button_pressed():
	UiSoundManager.play_button()


func _on_EasyCheckbox_pressed():
	SettingsManager.set_difficulty(SettingsManager.DIFFICULTY.EASY)
	$DifficultyBox/HardCheckbox.pressed = false


func _on_HardCheckbox_pressed():
	SettingsManager.set_difficulty(SettingsManager.DIFFICULTY.HARD)
	$DifficultyBox/EasyCheckbox.pressed = false

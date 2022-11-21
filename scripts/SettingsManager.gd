extends Node

var config: ConfigFile

var volumes = {
	"Master": 1.0,
	"Music": 1.0,
	"Sfx": 1.0,
}

enum DIFFICULTY { EASY, HARD }
var difficulty = DIFFICULTY.EASY

var is_fullscreen: bool = false

func _ready():
	config = ConfigFile.new()
	
	var err = config.load("user://settings.cfg")
	
	if err == OK:
		_load_volumes()
		_load_screen_settings()
		_load_difficulty()

func save_settings():
	var err = config.save("user://settings.cfg")
	if err:
		print("Failed save settings: ", err)

func _load_volumes():
	for key in volumes.keys():
		volumes[key] = config.get_value("Settings", key + "Volume", volumes[key])
		AudioServer.set_bus_mute(AudioServer.get_bus_index(key), volumes[key] <= 0.0)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(key), linear2db(volumes[key]))

func _load_screen_settings():
	is_fullscreen = config.get_value("Settings", "FullScreen", is_fullscreen)
	OS.window_fullscreen = is_fullscreen and OS.get_name() != "Web"
	
func _load_difficulty():
	difficulty = config.get_value("Settings", "Difficulty", difficulty)

func set_bus_volume(bus_name: String, value: float):
	volumes[bus_name] = value
	config.set_value("Settings", bus_name + "Volume", value)
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_name), value <= 0.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear2db(value))

func set_fullscreen(_is_fullscreen):
	is_fullscreen = _is_fullscreen
	config.set_value("Settings", "FullScreen", is_fullscreen)
	OS.window_fullscreen = is_fullscreen and OS.get_name() != "Web"

func set_difficulty(_difficulty):
	difficulty = _difficulty
	config.set_value("Settings", "Difficulty", difficulty)
	Globals.get_highscore()

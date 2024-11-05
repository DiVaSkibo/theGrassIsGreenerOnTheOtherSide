extends Node

#		CONST
const OPT_PATH := "res://options.ini"
#		VAR
var con = ConfigFile.new()


#		FUNC
func _ready():
	if FileAccess.file_exists(OPT_PATH):
		con.load(OPT_PATH)
		DisplayServer.window_set_mode(con.get_value("VIDEO", "Screenmode"))
		DisplayServer.window_set_size(con.get_value("VIDEO", "Resolution"))
		GlobalWorldEnvironment.environment.adjustment_brightness = con.get_value("VIDEO", "Brightness")
		DisplayServer.window_set_vsync_mode(con.get_value("VIDEO", "Vsync"))
		for i in AudioServer.bus_count:
			AudioServer.set_bus_volume_db(i, con.get_value("AUDIO", AudioServer.get_bus_name(i)))
	else:
		con.set_value("VIDEO", "Screenmode", DisplayServer.window_get_mode())
		con.set_value("VIDEO", "Resolution", DisplayServer.window_get_size())
		con.set_value("VIDEO", "Brightness", GlobalWorldEnvironment.environment.adjustment_brightness)
		con.set_value("VIDEO", "Vsync", DisplayServer.window_get_vsync_mode())
		for i in AudioServer.bus_count:
			con.set_value("AUDIO", AudioServer.get_bus_name(i), AudioServer.get_bus_volume_db(i))
		con.save(OPT_PATH)

func load_value(section:String, key:String):
	return con.get_value(section, key)
func save_value(section:String, key:String, value):
	con.set_value(section, key, value)
	con.save(OPT_PATH)

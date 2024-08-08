extends Node2D

#		CONST
const SCREENMODES := [0, 3, 4]
const RESOLUTIONS := {
	"HD 1280x720": Vector2i(1280, 720),
	"HD+ 1600x900": Vector2i(1600, 900),
	"FHD 1920x1080": Vector2i(1920, 1080),
}

#		VAR
#	Video
@onready var scr_mod := $Video/VBoxContainer/Screenmode/scrmod
@onready var reso := $Video/VBoxContainer/Resolution/reso
@onready var bright := $Video/VBoxContainer/Brightness/bright
@onready var vsync := $Video/VBoxContainer/Vsync/vsync
#	Audio
@onready var mast_vol := $Audio/VBoxContainer/Master/mastvol
@onready var musi_vol := $Audio/VBoxContainer/Music/musivol
@onready var sfx_vol := $Audio/VBoxContainer/SFX/sfxvol


#		FUNC
func _ready():
	scr_mod.selected = SCREENMODES.find(Config.load_value("VIDEO", "Screenmode"))
	reso.selected = RESOLUTIONS.values().find(Config.load_value("VIDEO", "Resolution"))
	reso.disabled = scr_mod.selected
	bright.value = Config.load_value("VIDEO", "Brightness")
	vsync.button_pressed = Config.load_value("VIDEO", "Vsync")
	
	mast_vol.value = db_to_linear(Config.load_value("AUDIO", "Master"))
	musi_vol.value = db_to_linear(Config.load_value("AUDIO", "Music"))
	sfx_vol.value = db_to_linear(Config.load_value("AUDIO", "SFX"))


#		SIGNAL
#	Main
func _on_main_2_pressed():
	$AnimationPlayer.play("options_main")
func _on_options_pressed():
	$AnimationPlayer.play("main_options")
func _on_play_pressed():
	pass
func _on_exit_pressed():
	get_tree().quit()


#	Video
func _on_audio_pressed():
	$AnimationPlayer.play("video_audio")
func _on_scrmod_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	reso.disabled = index
	Config.save_value("VIDEO", "Screenmode", DisplayServer.window_get_mode())
func _on_reso_item_selected(index):
	DisplayServer.window_set_size(RESOLUTIONS[reso.get_item_text(index)])
	Config.save_value("VIDEO", "Resolution", DisplayServer.window_get_size())
func _on_bright_value_changed(value):
	GlobalWorldEnvironment.environment.adjustment_brightness = value
	Config.save_value("VIDEO", "Brightness", value)
func _on_vsync_pressed():
	DisplayServer.window_set_vsync_mode(abs(DisplayServer.window_get_vsync_mode() - 1))
	Config.save_value("VIDEO", "Vsync", DisplayServer.window_get_vsync_mode())

#	Audio
func _on_video_pressed():
	$AnimationPlayer.play("audio_video")
func _on_mastvol_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	Config.save_value("AUDIO", AudioServer.get_bus_name(0), AudioServer.get_bus_volume_db(0))
func _on_musivol_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	Config.save_value("AUDIO", AudioServer.get_bus_name(1), AudioServer.get_bus_volume_db(1))
func _on_sfxvol_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	Config.save_value("AUDIO", AudioServer.get_bus_name(2), AudioServer.get_bus_volume_db(2))


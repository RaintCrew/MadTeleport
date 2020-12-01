extends Node2D

onready var music_on_button = $MusicOn
onready var music_on_button_50_percentaje = $MusicOn50p
onready var music_off_button = $MusicOff
onready var music_menu = $Menu_Music
onready var music_level = $Level_Music
onready var music_level_select = $Level_Select_Music

func _ready() -> void:
	if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")) == 0:
		music_off_button.hide()
		music_on_button.show()
		music_on_button_50_percentaje.hide()
		
	elif AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")) == -15:
		music_on_button.hide()
		music_off_button.hide()
		music_on_button_50_percentaje.show()
	else:
		music_on_button.hide()
		music_off_button.show()
		music_on_button_50_percentaje.hide()
	play_scene_music(get_parent().name)

func _process(delta: float) -> void:
	pass

func play_scene_music(scene_name) -> void:
	if scene_name == "MainMenu":
		music_menu.play()
		music_level_select.stop()
		music_level.stop()
	elif scene_name == "LevelSelect" or scene_name == "LevelCredits":
		music_menu.stop()
		music_level_select.play()
		music_level.stop()
	else:
		music_menu.stop()
		music_level_select.stop()
		music_level.play()

func _on_MusicOn_pressed() -> void:
	Global.music = false
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -15)
	music_on_button.hide()
	music_off_button.hide()
	music_on_button_50_percentaje.show()

func _on_MusicOff_pressed() -> void:
	Global.music = true
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
	music_off_button.hide()
	music_on_button.show()
	music_on_button_50_percentaje.hide()


func _on_MusicOn50p_pressed() -> void:
	Global.music = false
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -60)
	music_on_button.hide()
	music_off_button.show()
	music_on_button_50_percentaje.hide()

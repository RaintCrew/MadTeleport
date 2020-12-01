extends Node2D

onready var music_on_button = $MusicOn
onready var music_off_button = $MusicOff
onready var music_menu = $Menu_Music
onready var music_level = $Level_Music
onready var music_level_select = $Level_Select_Music

func _ready() -> void:
	#print(get_parent().name)
	if Global.music:
		music_off_button.hide()
		music_on_button.show()
		play_scene_music(get_parent().name)
	else:
		music_on_button.hide()
		music_off_button.show()
	pass

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
	
	if get_parent().name == "MainMenu":
		music_menu.volume_db = -80
	elif get_parent().name == "LevelSelect" or get_parent().name == "LevelCredits":
		music_level_select.volume_db = -80
	else:
		music_menu.volume_db = -80
	
	music_on_button.hide()
	music_off_button.show()

func _on_MusicOff_pressed() -> void:
	Global.music = true
	
	if get_parent().name == "MainMenu":
		music_menu.volume_db = -5
	elif get_parent().name == "LevelSelect" or get_parent().name == "LevelCredits":
		music_level_select.volume_db = -5
	else:
		music_menu.volume_db = -5

	music_off_button.hide()
	music_on_button.show()

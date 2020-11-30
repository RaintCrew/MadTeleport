extends Node2D

onready var music_on_button = $MusicOn
onready var music_off_button = $MusicOff
onready var music_menu = $Menu_Music
onready var music_level = $Level_Music
onready var music_level_select = $Level_Select_Music

func _ready() -> void:
	print(get_parent().name)
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
	if scene_name == "LevelSelect":
		music_level_select.play()
	if scene_name == "StageOne" or scene_name == "Level2" or scene_name == "Level3":
		music_menu.play()
	pass

func _on_MusicOn_pressed() -> void:
	Global.music = false
	
	if get_parent().name == "MainMenu":
		music_menu.stop()
	if get_parent().name == "LevelSelect":
		music_level_select.stop()
	if get_parent().name == "StageOne" or get_parent().name == "Level2" or get_parent().name == "Level3":
		music_menu.stop()
	
	#music_menu.volume_db = -80
	#music_level_select.volume_db = -80
	#music_menu.volume_db = -80
	
	music_on_button.hide()
	music_off_button.show()

func _on_MusicOff_pressed() -> void:
	Global.music = true
	
	if get_parent().name == "MainMenu":
		music_menu.play()
	if get_parent().name == "LevelSelect":
		music_level_select.play()
	if get_parent().name == "StageOne" or get_parent().name == "Level2" or get_parent().name == "Level3":
		music_menu.play()
	
	#music_menu.volume_db = 0
	#music_level_select.volume_db = 0
	#music_menu.volume_db = 0
	
	music_off_button.hide()
	music_on_button.show()

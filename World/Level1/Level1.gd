extends Node2D

onready var currentScene = get_tree().get_current_scene().get_filename()

func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().change_scene(currentScene)
		get_tree().paused = false
		PlayerStats.health = PlayerStats.max_health
	
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()

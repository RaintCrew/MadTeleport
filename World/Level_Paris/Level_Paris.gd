extends Node2D

onready var currentScene = get_tree().get_current_scene().get_filename()
var is_restarting = false
func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		if not is_restarting:
			$Camera/AnimationPlayer.play("BlackScreenFadeIn")
			$Timer_to_Restart_Level.start() # The scene has to last for some moments for the fadeIn to be seen
			is_restarting = true

	if Input.is_action_just_pressed("esc"):
		get_tree().quit()


func _on_Timer_to_Restart_Level_timeout():
	get_tree().change_scene(currentScene)
	get_tree().paused = false
	PlayerStats.health = PlayerStats.max_health

extends Node2D

onready var currentScene = get_tree().get_current_scene().get_filename()
var is_restarting = false

# Player has to kill all enemies of the current phase
# for the next phase to start. This var keeps track of that
var num_of_phase_enemies_killed = 0
var enemies_to_kill_in_phase = [7]
# The phase of the level (starts at 0)
# The different waves and setups of enemies
var phase = 0

func _ready():
	set_phase()
	pass


func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		if not is_restarting:
			$Camera/AnimationPlayer.play("BlackScreenFadeIn")
			$Timer_to_Restart_Level1.start() # The scene has to last for some moments for the fadeIn to be seen
			is_restarting = true

	if Input.is_action_just_pressed("esc"):
		get_tree().quit()


func _on_Timer_to_Restart_Level1_timeout():
	get_tree().change_scene(currentScene)
	get_tree().paused = false
	PlayerStats.health = PlayerStats.max_health

func add_to_enemies_killed():
	num_of_phase_enemies_killed += 1

func set_phase():
	pass

extends Node2D

onready var currentScene = get_tree().get_current_scene().get_filename()
var is_restarting = false

# Player has to kill all enemies of the current phase
# for the next phase to start. This var keeps track of that
var num_of_phase_enemies_killed = 0
var enemies_to_kill_in_phase = [8,4]

# The phase of the level (starts at 0)
# The different waves and setups of enemies
# Its in export var so, in testing, I can skip to test a specific phase
var phase = 0 setget set_phase

# How many phases are there in this level
var total_phases = 5

func _ready():
	set_phase(phase)
	pass


func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		if not is_restarting:
			$Camera/AnimationPlayer.play("BlackScreenFadeIn")
			is_restarting = true
			yield($Camera/AnimationPlayer, "animation_finished")
			get_tree().change_scene(currentScene)
			get_tree().paused = false
			PlayerStats.health = PlayerStats.max_health

	if Input.is_action_just_pressed("esc"):
		get_tree().quit()

# Called everytime an enemy is killed
func add_to_enemies_killed():
	num_of_phase_enemies_killed += 1
	print("Enemies killed: ",num_of_phase_enemies_killed)
	if num_of_phase_enemies_killed == enemies_to_kill_in_phase[phase]:
		set_phase(phase+1)
		

# reset(_enemy_type, _spawn_delay, _spawn_offset, _enemies_limit, _spawning, _will_wait_for_death)
# "Drone" = 1; "Tower" = 2
func set_phase(value):
	phase = clamp(value,0,total_phases)
	print("Phase: ", phase)
	if phase == 1:
		$EnemySpawnerUL.reset(1, 1, 0, 2, true, true)
		$EnemySpawnerDR.reset(1, 1.5, 1, 2, true, true)
		$EnemySpawnerDL.spawning = false
		$EnemySpawnerUR.spawning = false
		$EnemySpawnerCenter.spawning = false
	

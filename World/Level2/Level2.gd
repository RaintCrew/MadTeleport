extends Node2D

onready var currentScene = get_tree().get_current_scene().get_filename()
var is_restarting = false

# Player has to kill all enemies of the current phase
# for the next phase to start. This var keeps track of that
var num_of_phase_enemies_killed = 0
var enemies_to_kill_in_phase = [4,12,25,20,19,100]

onready var c_enemy_spawner = $EnemySpawnerCenter
onready var ur_enemy_spawner = $EnemySpawnerUR
onready var drr_enemy_spawner = $EnemySpawnerDRR
onready var dr_enemy_spawner = $EnemySpawnerDR
onready var dl_enemy_spawner = $EnemySpawnerDL
onready var dll_enemy_spawner = $EnemySpawnerDLL
onready var ul_enemy_spawner = $EnemySpawnerUL

# The phase of the level (starts at 0)
# The different waves and setups of enemies
# Its in export var so, in testing, I can skip to test a specific phase
var phase = 0 setget set_phase

# How many phases are there in this level
var total_phases = 4

func _ready():
	set_phase(phase)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if Global.music:
		$bg_music.play()
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
	print("Enemies killed: ", num_of_phase_enemies_killed)
	# When the player has killed the required enemies to advance to the next phase
	if num_of_phase_enemies_killed == enemies_to_kill_in_phase[phase]:	
		set_phase(phase+1)
		
#############
## PHASE 0 ##
#############
# In this level, the only way to hit someone in the opposite side
# of the room is to teleport through the upper passageway
# The tightness of the room also makes it harder to teleport
# 2 towers, in opposite sides
###################################

#############
## PHASE 1 ##
#############
# Phase 0, but with two saw drones in UL and UR
#######################################

#############
## PHASE 2 ##
#############
# 5 fast-spawning saw drones. 
######################################

#############
## PHASE 3 ##
#############
# 4 fast-spawning saw drones
# 2 towers in DL and DR
# QUITE HARD.
######################################


# This is called when the Level transitions to another phase
# reset(_enemy_type, _spawn_delay, _spawn_offset, _enemies_limit, _spawning, _will_wait_for_death)
# "Drone" = 0; "Tower" = 1
func set_phase(value):
	phase = clamp(value,0,total_phases)
	num_of_phase_enemies_killed = 0
	print("Phase: ", phase)
	if phase == 1:
		disable_all_spawners()
		ur_enemy_spawner.reset(0, 1, 0, 4, true, true)
		dl_enemy_spawner.reset(1, 4, 0, 2, true, true)
		dr_enemy_spawner.reset(1, 4, 0, 2, true, true)
		ul_enemy_spawner.reset(0, 1, 0, 4, true, true)
	elif phase == 2:
		disable_all_spawners()
		c_enemy_spawner.reset(0, 1, 0, 5, true, true)
		ur_enemy_spawner.reset(0, 1, 2, 5, true, true)
		dl_enemy_spawner.reset(0, 1, 1, 5, true, true)
		dr_enemy_spawner.reset(0, 1, 1, 5, true, true)
		ul_enemy_spawner.reset(0, 1, 2, 5, true, true)
	elif phase == 3:
		disable_all_spawners()
		ur_enemy_spawner.reset(0, 3, 0, 4, true, true)
		drr_enemy_spawner.reset(1, 4, 0, 2, true, true)
		dr_enemy_spawner.reset(0, 4, 2, 4, true, true)
		dll_enemy_spawner.reset(1, 4, 0, 2, true, true)
		dl_enemy_spawner.reset(0, 5, 2, 4, true, true)
		ul_enemy_spawner.reset(0, 3, 0, 4, true, true)
	
	elif phase == total_phases:
		disable_all_spawners()
		clear_level()
	
func disable_all_spawners():
	for spawner in get_tree().get_nodes_in_group("all_enemy_spawners"):
		spawner.spawning = false
	
# Called when the player completes the level!
func clear_level():
	pass

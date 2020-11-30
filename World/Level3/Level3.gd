extends Node2D

onready var currentScene = get_tree().get_current_scene().get_filename()
var is_restarting = false

# Player has to kill all enemies of the current phase
# for the next phase to start. This var keeps track of that
var num_of_phase_enemies_killed = 0
var enemies_to_kill_in_phase = [11,17,25,20,19,100]

onready var c_enemy_spawner = $EnemySpawnerC
onready var ur_enemy_spawner = $EnemySpawnerUR
onready var drr_enemy_spawner = $EnemySpawnerDRR
onready var dr_enemy_spawner = $EnemySpawnerDR
onready var dl_enemy_spawner = $EnemySpawnerDL
onready var dll_enemy_spawner = $EnemySpawnerDLL
onready var ul_enemy_spawner = $EnemySpawnerUL
onready var ull_enemy_spawner = $EnemySpawnerULL
onready var urr_enemy_spawner = $EnemySpawnerURR

# The phase of the level (starts at 0)
# The different waves and setups of enemies
# Its in export var so, in testing, I can skip to test a specific phase
var phase = 0 setget set_phase

# How many phases are there in this level
var total_phases = 4

func _ready():
	set_phase(phase)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
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
# In this level, the player is faced with spawners
# that have the "will_wait_for_spawned_2die" desactived.
# In this phase, ULL, URR, DL and DR will spawn saw drones
###################################

#############
## PHASE 1 ##
#############
# We combine the problem the saw drones that don't wait
# with two towers in DL, DR
#######################################

#############
## PHASE 2 ##
#############
# 3 towers in ULL, URR and C 
######################################

#############
## PHASE 3 ##
#############
# 3 towers
# 2 saw drones
# 
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
		dr_enemy_spawner.reset(1, 3, 0, 1, true, true)
		dl_enemy_spawner.reset(1, 3, 0, 1, true, true)
		ull_enemy_spawner.reset(0, 3, 0, 5, true, false)
		urr_enemy_spawner.reset(0, 3, 0, 5, true, false)
		c_enemy_spawner.reset(0, 3, 0, 5, true, false)
		pass
	elif phase == 2:
		disable_all_spawners()
		urr_enemy_spawner.reset(1, 3, 0, 2, true, true)
		ull_enemy_spawner.reset(1, 3, 0, 2, true, true)
		c_enemy_spawner.reset(1, 3, 2, 2, true, true)
		pass
		
	elif phase == 3:
		disable_all_spawners()
		urr_enemy_spawner.reset(1, 3, 0, 2, true, true)
		ull_enemy_spawner.reset(1, 3, 0, 2, true, true)
		c_enemy_spawner.reset(1, 3, 0, 2, true, true)
		drr_enemy_spawner.reset(0, 3, 0, 5, true, false)
		dll_enemy_spawner.reset(0, 3, 0, 5, true, false)
		pass
	
	elif phase == total_phases:
		disable_all_spawners()
		clear_level()
	
func disable_all_spawners():
	for spawner in get_tree().get_nodes_in_group("all_enemy_spawners"):
		spawner.spawning = false
	
# Called when the player completes the level!
func clear_level():
	pass

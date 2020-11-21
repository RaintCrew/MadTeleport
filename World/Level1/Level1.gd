extends Node2D

onready var currentScene = get_tree().get_current_scene().get_filename()
var is_restarting = false

# Player has to kill all enemies of the current phase
# for the next phase to start. This var keeps track of that
var num_of_phase_enemies_killed = 0
var enemies_to_kill_in_phase = [8,2,16,100,100,100]

onready var ul_enemy_spawner = $EnemySpawnerUL
onready var ur_enemy_spawner = $EnemySpawnerUR
onready var dl_enemy_spawner = $EnemySpawnerDL
onready var dr_enemy_spawner = $EnemySpawnerDR
onready var c_enemy_spawner = $EnemySpawnerCenter

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
	print("Enemies killed: ", num_of_phase_enemies_killed)
	# When the player has killed the required enemies to advance to the next phase
	if num_of_phase_enemies_killed == enemies_to_kill_in_phase[phase]:	
		set_phase(phase+1)
		
#############
## PHASE 0 ##
#############
# A slow spawn of saw drones in all four corners in the room.
# All of them will wait for its spawned drones to die, giving more
# space for the player to take each of them one at a time
###################################

#############
## PHASE 1 ##
#############
# Introduction to the tower.
# A tower will spawn in Center
# The player here will get a sense of the bullet speed
# and HP of the tower for the rest of the game
#######################################

#############
## PHASE 2 ##
#############
# We mix few saw drones with few towers
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
		c_enemy_spawner.reset(1, 1, 0, 2, true, true)
	elif phase == 2:
		disable_all_spawners()
		dr_enemy_spawner.reset(0, 2, 6, 6, true, true)
		dl_enemy_spawner.reset(0, 3, 4, 6, true, true)
		ur_enemy_spawner.reset(0, 1, 0, 1, true, true)
		ul_enemy_spawner.reset(0, 2, 0, 1, true, true)
		c_enemy_spawner.reset(1, 4, 0, 2, true, true)
			
	
func disable_all_spawners():
	for spawner in get_tree().get_nodes_in_group("all_enemy_spawners"):
		spawner.spawning = false
	

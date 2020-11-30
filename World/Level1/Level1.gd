extends Node2D

onready var currentScene = get_tree().get_current_scene().get_filename()
var is_restarting = false
onready var camera_animation_player = $Camera/AnimationPlayer
onready var pause_popup = $PausePopup
# Player has to kill all enemies of the current phase
# for the next phase to start. This var keeps track of that
var num_of_phase_enemies_killed = 0
var enemies_to_kill_in_phase = [8,2,16,14,19,100]

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
	if Global.music:
		$bg_music.play()
	PlayerStats.health = PlayerStats.max_health
	PlayerStats.ammo = PlayerStats.max_ammo
	pass


func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		if not is_restarting:
			camera_animation_player.play("BlackScreenFadeIn")
			is_restarting = true
			yield(camera_animation_player, "animation_finished")
			get_tree().change_scene(currentScene)
			get_tree().paused = false
			PlayerStats.health = PlayerStats.max_health
			PlayerStats.ammo = PlayerStats.max_ammo

	if Input.is_action_just_pressed("esc"):
		if not is_restarting:
			get_tree().paused = true
			yield(get_tree().create_timer(0.1), "timeout")
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			pause_popup.show()

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
# A slow spawn of saw drones in two corners in the room.
# Both of them will wait for its spawned drones to die, giving more
# space for the player to take each of them one at a time
# All enemies in this level will do that
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
# We mix few saw drones (two spawning at a time)
# with one tower in the center
######################################

#############
## PHASE 3 ##
#############
# It's phase 2, but with two towers.
# The towers are in UL and UR
######################################

#############
## PHASE 4 ##
#############
# The end. It's phase 3, but with three saw drones spawning.
# The saw drones will spawn more frequently
# The towers will reappear after being destroyed once
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
		c_enemy_spawner.reset(1, 4, 0, 2, true, true)
		ur_enemy_spawner.reset(0, 1, 0, 1, true, true)
		dr_enemy_spawner.reset(0, 3, 6, 6, true, true)
		dl_enemy_spawner.reset(0, 3, 4, 6, true, true)
		ul_enemy_spawner.reset(0, 2, 0, 1, true, true)
		
	elif phase == 3:
		disable_all_spawners()
		ur_enemy_spawner.reset(1, 3, 0, 1, true, true)
		dr_enemy_spawner.reset(0, 3, 2, 6, true, true)
		dl_enemy_spawner.reset(0, 3, 2, 6, true, true)
		ul_enemy_spawner.reset(1, 3, 0, 1, true, true)
		
	elif phase == 4:
		disable_all_spawners()
		c_enemy_spawner.reset(0, 2, 3, 5, true, true)
		ur_enemy_spawner.reset(1, 1, 2, 2, true, true)
		dr_enemy_spawner.reset(0, 3, 2, 5, true, true)
		dl_enemy_spawner.reset(0, 2, 3, 5, true, true)
		ul_enemy_spawner.reset(1, 3, 2, 2, true, true)
	
	elif phase == 5:
		disable_all_spawners()
		clear_level()
	
func disable_all_spawners():
	for spawner in get_tree().get_nodes_in_group("all_enemy_spawners"):
		spawner.spawning = false
	
# Called when the player completes the level!
func clear_level():
	camera_animation_player.play("ShowLevelCleared")
	yield(get_tree().create_timer(3), "timeout")
	camera_animation_player.play("BlackScreenFadeIn")
	is_restarting = true
	yield(camera_animation_player, "animation_finished")
	PlayerStats.health = PlayerStats.max_health
	get_tree().change_scene("res://World/Level2/Level2.tscn")
	pass

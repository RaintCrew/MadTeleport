extends Position2D

var enemy_drone = preload("res://Enemies/Enemy_drone/EnemyDrone.tscn") # Reference EnemyDrone
var enemy_tower = preload("res://Enemies/Enemy_tower/EnemyTower.tscn") # Reference EnemyTower
export(int, "Drone", "Tower") var enemy_type
onready var animation_player = $AnimationPlayer

export var spawn_delay : = 2.0 				# Spawn speed
export var spawn_delay_offset : = 0.0
export var enemies_limit : = 5;
export var spawning = true
export var will_wait_for_spawned_enemy_to_die = false

var enemies_spawned = 0
var enemy_position = global_position 						# Enemy appears in this position
var enemy_spawned = null

func _ready() -> void:
	start_offset_to_spawn()

# The spawn_delay with its appropiate offset will start both when
# the node enters scene and when its reset by Level script	
func start_offset_to_spawn():
	yield(get_tree().create_timer(spawn_delay_offset), "timeout")
	wave_start()
		
func wave_start() -> void:
	$EnemySpawnTimer.start(spawn_delay)

func _on_EnemySpawnTimer_timeout() -> void:
	if Global.player and enemies_spawned < enemies_limit and spawning: 		# If the player is alive execute below code
		if will_wait_for_spawned_enemy_to_die == false:
			spawn_enemy()
		else:
			if enemy_spawned == null:
				spawn_enemy()


func spawn_enemy() -> void:
	if enemy_type == 0:
		animation_player.play("sawdrone_about_2spawn")
		enemy_spawned = enemy_drone.instance()
	elif enemy_type == 1:
		animation_player.play("tower_about_2spawn2")
		enemy_spawned = enemy_tower.instance()
	yield(animation_player,"animation_finished")
	enemy_spawned.position = enemy_position
	add_child(enemy_spawned)
	enemies_spawned += 1

# Used by the Level script to reconfigure the spawner
func reset(_enemy_type, _spawn_delay, _spawn_offset, _enemies_limit, _spawning, _will_wait_for_death):
	enemies_spawned = 0
	enemy_type = _enemy_type
	spawn_delay = _spawn_delay
	spawn_delay_offset = _spawn_offset
	enemies_limit = _enemies_limit
	spawning = _spawning
	will_wait_for_spawned_enemy_to_die = _will_wait_for_death
	$EnemySpawnTimer.stop()
	start_offset_to_spawn()


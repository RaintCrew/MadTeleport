extends Position2D

var enemy_drone = preload("res://Enemies/Enemy_drone/EnemyDrone.tscn") # Reference EnemyDrone
var enemy_tower = preload("res://Enemies/Enemy_tower/EnemyTower.tscn") # Reference EnemyTower
export(int, "Drone", "Tower") var enemy_type

export var spawn_delay : = 2.0 				# Spawn speed
export var spawn_delay_offset : = 0
export var enemies_limit : = 5;
export var spawning = true
export var will_wait_for_spawned_enemy_to_die = false

var enemies_spawned = 0
var enemy_position = global_position 						# Enemy appears in this position
var enemy_spawned = null

func _ready() -> void:
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
		enemy_spawned = enemy_drone.instance()
	elif enemy_type == 1:
		enemy_spawned = enemy_tower.instance()
	enemy_spawned.position = enemy_position
	add_child(enemy_spawned)
	enemies_spawned += 1

extends Position2D

var enemy_drone = preload("res://Enemies/Enemy_drone/EnemyDrone.tscn") # Reference EnemyDrone
var enemy_tower = preload("res://Enemies/Enemy_tower/EnemyTower.tscn") # Reference EnemyTower
export(String, "Drone", "Tower") var enemy_type

export var spawn_delay = 2 				# Spawn speed
export var enemies_limit = 5;
export var spawning = true

var enemies_spawned = 0

func _ready() -> void:
	get_node("EnemySpawnTimer").wait_time = spawn_delay 			# Set spawn speed to the timer
	print(enemy_type[0])
	pass

func _on_EnemySpawnTimer_timeout() -> void:
	if Global.player and enemies_spawned < enemies_limit and spawning: 		# If the player is alive execute below code
		enemies_spawned += 1
		var enemy_position = global_position 						# Drone appears in this position
		Global.instance_node(enemy_drone, enemy_position, self)

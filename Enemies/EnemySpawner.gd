extends Position2D

var enemy_drone = preload("res://Enemies/Enemy_drone/EnemyDrone.tscn") # Reference EnemyDrone
var enemy_tower = preload("res://Enemies/Enemy_tower/EnemyTower.tscn") # Reference EnemyTower
export(int, "Drone", "Tower") var enemy_type

export var spawn_delay : = 2.0 				# Spawn speed
export var spawn_delay_offset : = 0
export var enemies_limit : = 5;
export var spawning = true
export var enemy_spawned_still_alive = false

var enemies_spawned = 0
var enemy_position = global_position 						# Enemy appears in this position
var enemy_spawned = null

func _ready() -> void:
	get_node("EnemySpawnTimer").wait_time = spawn_delay 			# Set spawn speed to the timer
	# Create a timer node
	var timer_offset = Timer.new()
	# Set timer interval
	timer_offset.set_wait_time(spawn_delay_offset)
	# Set it as single count
	timer_offset.set_one_shot(true)
	# Connect its timeout signal to the function you want to repeat
	timer_offset.connect("timeout", self, "wave_start")
	# Add to the tree as child of the current node
	add_child(timer_offset)
	timer_offset.start()

func wave_start() -> void:
	$EnemySpawnTimer.start()

func _on_EnemySpawnTimer_timeout() -> void:
	if Global.player and enemies_spawned < enemies_limit and spawning: 		# If the player is alive execute below code
		if enemy_spawned_still_alive == false:
			spawn_enemy()
		else:
			if enemy_spawned == null:
				print()
				spawn_enemy()
		#if enemy_type == 0:
			#enemies_spawned += 1
			#spawn_enemy()
			#Global.instance_node(enemy_drone, enemy_position, self)
		#if enemy_type == 1 and enemy_spawned == null:
			#Global.instance_node(enemy_tower, enemy_position, self)
			#enemies_spawned += 1
			#spawn_tower()

func spawn_enemy() -> void:
	if enemy_type == 0:
		enemy_spawned = enemy_drone.instance()
	elif enemy_type == 1:
		enemy_spawned = enemy_tower.instance()
	enemy_spawned.position = enemy_position
	add_child(enemy_spawned)
	enemies_spawned += 1

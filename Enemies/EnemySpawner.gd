extends Position2D

var enemy_drone = preload("res://Enemies/Enemy_drone/EnemyDrone.tscn") # Reference EnemyDrone

export var spwan_speed = 2 				# Spawn speed

func _ready() -> void:
	get_node("EnemySpawnTimer").wait_time = spwan_speed 			# Set spawn speed to the timer
	pass

func _on_EnemySpawnTimer_timeout() -> void:

	if Global.player: 									# If the player is alive execute below code
		var enemy_position = global_position 			# Drone appears in this position
		Global.instance_node(enemy_drone, enemy_position, self)

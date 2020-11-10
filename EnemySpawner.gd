extends Position2D

var enemy_drone = preload("res://Enemies/EnemyDrone/EnemyDrone.tscn")

func _ready() -> void:
	##Global.node_creation_parent = self
	pass

func _on_EnemySpawnTimer_timeout() -> void:
	var enemy_position = Vector2(rand_range(-160,670),rand_range(-90,390))
	
	while enemy_position.x < 640 and enemy_position.x > -80 or enemy_position.y < 360 and enemy_position.y > -45:
		enemy_position = Vector2(rand_range(-160,670),rand_range(-90,390))
	
	Global.instance_node(enemy_drone, enemy_position, self)

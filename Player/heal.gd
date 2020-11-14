extends Node2D

var stats = PlayerStats
var timer = Timer.new()

func _ready():
	stats.health -= 3
	
func _process(delta):
	
	if Input.is_action_just_pressed("heal"):
		while stats.health < stats.max_health:
			stats.health += 1
			yield(get_tree().create_timer(0.4), "timeout")

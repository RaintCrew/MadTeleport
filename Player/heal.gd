extends Node2D

var stats = PlayerStats
var timer = Timer.new()
onready var label_heal_yourself = $HealYourself

func _ready():
	stats.health -= 3
	
func _process(delta):
	if stats.health == 1:
		label_heal_yourself.set_visible(true)
	if Input.is_action_just_pressed("heal"):
		label_heal_yourself.set_visible(false)
		while stats.health < stats.max_health:
			stats.health += 1
			yield(get_tree().create_timer(0.4), "timeout")

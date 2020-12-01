extends Control

var health = 3 setget set_health
var max_health = 4  setget set_max_health

onready var healthUIFull = $HealthUIFull
onready var healthUIEmpty = $HealthUIEmpty

func set_health(value):
	# clamp sets health that it can't be less than 0 nor greather than max_health.
	health = clamp(value, 0, max_health)
	# this will set the size of the rect with strecth of tile, to be the health times 
	# the size of each heart.
	if healthUIFull:
		healthUIFull.rect_size.x = health * 12
	
func set_max_health(value):
	# max = max_health value won't never be less than 1.
	max_health = max(value, 1)
	# same as above.
	self.health = min(health, max_health)
	if healthUIEmpty:
		healthUIEmpty.rect_size.x = max_health * 12
	
func _ready():
	self.max_health = PlayerStats.max_health
	self.health = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_health")
	PlayerStats.connect("max_health_changed", self, "set_max_health")

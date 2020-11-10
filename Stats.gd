#This will be autoloaded as a Singleton
extends Node

export var max_health = 1 setget set_max_health
#onready so that the value is the one set in the inspector. 
#every time the health changes, Godot will call set_health.
var health = max_health setget set_health

#We use a signal because it's the child who wants to tell something to the parent.
signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	# self so that it calls the setter
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)	

func set_health(value):
	health = value
	# when the health changes we emit a signal with the new value.
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
		
func _ready():
	self.health = max_health

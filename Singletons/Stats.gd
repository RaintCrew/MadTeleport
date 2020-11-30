#This will be autoloaded as a Singleton
extends Node

export var max_health = 5 setget set_max_health
export var max_ammo = 6 setget set_max_ammo
#onready so that the value is the one set in the inspector. 
#every time the health changes, Godot will call set_health.
var health = max_health setget set_health
var ammo = max_ammo setget set_ammo
var has_tp = true setget set_tp

#We use a signal because it's the child who wants to tell something to the parent.
signal no_health
signal health_changed(value)
signal max_health_changed(value)

signal no_ammo
signal ammo_changed(value)
signal max_ammo_changed(value)
signal player_is_dead()

signal has_tp_changed(value)

func _ready():
	self.health = max_health
	self.ammo = max_ammo

### Teleport Ball
func set_tp(value):
	has_tp = value
	emit_signal("has_tp_changed", has_tp)

### AMMUNITION
func set_max_ammo(value):
	max_ammo = value
	self.ammo = min(ammo,max_ammo)
	emit_signal("max_ammo_changed", max_ammo)

func set_ammo(value):
	if ammo < 1:
		emit_signal("no_ammo")
		
	ammo = value
	emit_signal("ammo_changed", ammo)

### HEALTH
func set_max_health(value):
	max_health = value
	# self so that it calls the setter
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)	

func set_health(value):
	if value < 1:
		emit_signal("player_is_dead")
	
	health = value
	# when the health changes we emit a signal with the new value.
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

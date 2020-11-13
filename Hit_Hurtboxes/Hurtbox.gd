extends Area2D

export var invincible = false setget set_invincible

onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _ready() -> void:
	pass # Replace with function body.

func _on_Timer_timeout() -> void:
	self.invincible = false

func _on_Hurtbox_invincibility_started() -> void:
	set_deferred("monitorable", false)

func _on_Hurtbox_invincibility_ended() -> void:
	monitorable = true

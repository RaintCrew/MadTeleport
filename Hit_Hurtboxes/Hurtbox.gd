extends Area2D

var invincible = false setget set_invincible 	# This help to set true or false a zone arround on object
												#Use setget for when every function change this variable this calls set_invincible function

onready var timer = $Timer				# This connect with the timer in the scene

signal invincibility_started			# A signal to say when really starts the invencibility
signal invincibility_ended				# A signal to say when really ended the invencibility

func set_invincible(value):
	invincible = value 				# set invincible to a new value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true 			# set the invencibility duration value
	timer.start(duration) 			# set the duration of the invencibility on timer 

func _ready() -> void:
	pass

func _on_Timer_timeout() -> void:
	self.invincible = false 		# when the timer duration end set invencibility to false.

func _on_Hurtbox_invincibility_started() -> void: 		# when the signal invincibility_started is launched, executed below
	set_deferred("monitorable", false) 			# if simple we use "monitorable=false" this cause a error, for this Godot recomend use instead "set_deferred"
												# but this is just set the monitorable value tu false to shot down the masks on the collaider
	

func _on_Hurtbox_invincibility_ended() -> void: 		# when the signal invincibility_ended is launched, executed below
	monitorable = true 			# this is set the monitorable true when te invencibility ended to see the mask again.

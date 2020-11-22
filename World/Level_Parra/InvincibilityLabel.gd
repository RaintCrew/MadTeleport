extends Node2D

var invincibility_on = false setget set_invincibility

onready var invincibility_label = $Invincibility


func _process(delta):
	if invincibility_on:
		invincibility_label.set_visible(true)
	else:
		invincibility_label.set_visible(false)
		
func set_invincibility(value):
	invincibility_on = value


func _on_Hurtbox_invincibility_started():
	self.invincibility_on = true


func _on_Hurtbox_invincibility_ended():
	self.invincibility_on = false

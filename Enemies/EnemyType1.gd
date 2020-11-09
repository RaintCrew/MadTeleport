extends KinematicBody2D

const SPEED = 50
#var animation = "Idle"
var life = 3

onready var target = get_parent().get_node("Player")

#func _process(delta):
#	animation_loop()


func _physics_process(delta):
	var velocity = global_position.direction_to(target.global_position)
	move_and_collide(velocity * SPEED * delta)


#func animation_loop():
#	get_node("AnimationPlayer").play(animation)

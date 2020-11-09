extends KinematicBody2D

const SPEED = 50
#var animation = "Idle"

onready var stats = $Stats #access to the Stats node
onready var target = get_parent().get_node("Player")

#func _process(delta):
#	animation_loop()
func _ready():
	print("max healh:", stats.max_health)
	

func _process(delta):
	animation_loop()


func _physics_process(delta):
	if target:
		var velocity = global_position.direction_to(target.global_position)
		move_and_collide(velocity * SPEED * delta)


#func animation_loop():
#	get_node("AnimationPlayer").play(animation)

#when detected that "something" entered this area, we're going to delete this enemy. 
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage


func _on_Stats_no_health():
	queue_free()

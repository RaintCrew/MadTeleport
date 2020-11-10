extends Area2D

var speed = 5					# Speed de la bala
var velocity = Vector2()        # Vector velocidad x/y
onready var destination = null

func _ready():
	destination = get_parent().get_node("Player").get_global_position()

func _physics_process(delta):
	velocity = destination - global_position
	velocity = velocity.normalized() * speed
	position = position + velocity

#func _on_EnemyBullet_body_entered(body):
#	queue_free() # Replace with function body.


#func _on_EnemyBullet_area_entered(area):
#	queue_free() # Replace with function body.


func _on_Hitbox_area_entered(area: Area2D) -> void:
	queue_free()


func _on_EnemyBullet_body_entered(body):
	queue_free()

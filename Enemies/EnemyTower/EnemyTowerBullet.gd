extends Area2D

var speed = 5					# Speed de la bala
var velocity = Vector2(0,0)        # Vector velocidad x/y
onready var destination = null

func _ready():
	destination = get_parent().get_node("Player").get_global_position()
	velocity = global_position.direction_to(destination)
	velocity *= speed

func _physics_process(delta):
	global_position = global_position + velocity


func _on_EnemyBullet_body_entered(body):
	queue_free()

func _on_EnemyBullet_area_entered(area: Area2D) -> void:
	queue_free()

extends Area2D

export var speed = 3						# Speed of the bullet
var velocity = Vector2()        	# Speed x/y
onready var destination = null
export var damage = 1

func _ready():
	#destination = get_parent().get_node("Player").get_global_position() 	# get the player last position
	destination = Global.player.get_global_position()
	velocity = global_position.direction_to(destination) 					# go to the player last position
	velocity *= speed

func _physics_process(delta):
	global_position = global_position + velocity 							# go to the speed value


func _on_EnemyBullet_body_entered(body):
	queue_free()

func _on_EnemyBullet_area_entered(area: Area2D) -> void:
	queue_free()


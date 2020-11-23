extends Area2D

export var speed = 3						# Speed of the bullet
var velocity = Vector2()        	# Speed x/y
onready var destination = null
export var damage = 1
export var can_cross_Walls = false
onready var tilemap = get_parent().get_parent().get_node("TileMap")

func _ready():
	#destination = get_parent().get_node("Player").get_global_position() 	# get the player last position
	destination = Global.player.get_global_position()
	velocity = global_position.direction_to(destination) 					# go to the player last position
	velocity *= speed
	print(tilemap)

func _physics_process(delta):
	global_position = global_position + velocity 							# go to the speed value


func _on_EnemyBullet_body_entered(body):
	if body == tilemap:
		if not can_cross_Walls:
			queue_free()
	else:
		queue_free()


# Deletes the bullet when it leaves the screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

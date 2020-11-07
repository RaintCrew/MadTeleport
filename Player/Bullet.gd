extends Area2D

var speed = 7					# Speed de la bala
var velocity = Vector2()		# Vector velocidad x/y
onready var destination = null	# Punto a donde va la bala (donde estaba la mira al disparar)


# Called when the node enters the scene tree for the first time.
func _ready():
	destination = get_local_mouse_position()

func _physics_process(delta):
	velocity = velocity.move_toward(destination, delta)
	velocity = velocity.normalized() * speed
	position = position + velocity
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends Area2D

var speed = 7					# Speed de la bala
var velocity = Vector2()		# Vector velocidad x/y
onready var destination = null	# Punto a donde va la bala (donde estaba la mira al disparar)
export var can_cross_walls = false

# Called when the node enters the scene tree for the first time.
func _ready():
	destination = get_local_mouse_position()	# La bala viaja hacia donde esta la mira

func _physics_process(delta):
	# Mover hacia destino
	velocity = velocity.move_toward(destination, delta)
	velocity = velocity.normalized() * speed
	position = position + velocity
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Si la bala sale de la pantalla, se borra de existencia
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# Si la bala colisiona con un objeto solido (muro, enemy...), se borra
func _on_Bullet_body_entered(body):
	if not can_cross_walls:
		queue_free()

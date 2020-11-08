extends Area2D

const GRAVITY = 0.13

var speed = 6					# Speed de la bala
var velocity = Vector2()		# Vector velocidad x/y

onready var destination = null	# Punto a donde va la bala (donde estaba la mira al disparar)


# Called when the node enters the scene tree for the first time.
func _ready():
	destination = get_local_mouse_position()	# La tp ball viaja hacia donde esta la mira

func _physics_process(delta):
	# Mover hacia destino
	velocity = velocity.move_toward(destination, delta)
	velocity = velocity.normalized() * speed
	
	# Para que sea afectado por gravedad
	#velocity.y += GRAVITY  
	position = position + velocity
	
	
	

# Si la teleport ball colisiona con un objeto solido (muro, enemy...), se borra
# Es necesario re-habilitar el lanzamiento de teleport ball para el jugador
func _on_TeleportBall_body_entered(body):
	get_parent().get_node("Player").regain_teleport_ball()
	queue_free()

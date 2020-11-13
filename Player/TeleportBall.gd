extends Area2D

export var MIN_DISTANCE_TO_TELEPORT = 500.0
var speed = 6					# Speed de la bala
var velocity = Vector2()		# Vector velocidad x/y
var traveled_distance = 0.0
var initial_position = Vector2()
var has_signaled_traveled_enough = false
onready var player = null
onready var destination = null	# Punto a donde va la bala (donde estaba la mira al disparar)
onready var particle_scene = preload("res://Player/TeleportParticles.tscn")	# Referencia a escena de particulas de teleport

# Called when the node enters the scene tree for the first time.
func _ready():
	destination = get_local_mouse_position()	# La tp ball viaja hacia donde esta la mira
	initial_position = global_position
	player = get_parent().get_node("Player")
	
func _physics_process(delta):
	# Mover hacia destino
	velocity = velocity.move_toward(destination, delta)
	velocity = velocity.normalized() * speed
	
	# Para que sea afectado por gravedad
	#velocity.y += GRAVITY  
	position = position + velocity
	
	traveled_distance = initial_position.distance_squared_to(global_position)
	
	if traveled_distance >= MIN_DISTANCE_TO_TELEPORT and not has_signaled_traveled_enough:
		player.tpball_traveled_enough()
		has_signaled_traveled_enough = true
		self.modulate = Color(1,1,1,1)	# Becomes fully colored to signal you can teleport to it
		OS.delay_msec(20)
		create_tp_particles()

# Si la teleport ball colisiona con un objeto solido (muro, enemy...), se borra
# Es necesario re-habilitar el lanzamiento de teleport ball para el jugador
func _on_TeleportBall_body_entered(body):
	player.regain_teleport_ball()
	queue_free()

func create_tp_particles():
	var tp_particles = particle_scene.instance()	
	tp_particles.global_position = Vector2(global_position.x, global_position.y)
	get_parent().add_child(tp_particles)

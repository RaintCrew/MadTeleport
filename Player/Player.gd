extends KinematicBody2D

const RUN_SPEED = 100 		# velocidad lateral de Player al caminar
const GRAVITY = 10 			# aceleracion vertical que disminuye la velocidad vertical del Player
const FLOOR = Vector2(0,-1) # vector normal que el physics engine usa para frenar con pisos y paredes
const MAX_FALL_SPEED = 200 	# lo mas rapido que puede caer el Player por gravedad

var velocity = Vector2() 			# Vector (x,y) donde x/y define cuanto se mueve horizontal/verticalmente en cada frame.
var bullets = 6 					# Numero de balas ende arma. Se recarga con Teleport
var can_throw_teleport_ball = true	# Puede arrojar la teleport ball, o esta en el aire y no puede lanzarla

onready var crosshair = get_node("Crosshair") 			# Referencia a la crosshair
onready var gun = get_node("Gun") 						# Referencia al arma de la que disparas
onready var floating_teleport_ball = get_node("Ball") 	# Referencia a teleport ball flotando al lado tuyo

onready var bullet_scene = preload("res://Player/Bullet.tscn") 				# Referencia a escena de bala
onready var teleport_ball_scene = preload("res://Player/TeleportBall.tscn") # Referencia a escena de teleport ball


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	# Controles tecla "A" y "D" para moverse lateralmente
	# Al no presionar ninguna tecla, el Player se detiene lateralmente
	if Input.is_key_pressed(KEY_D):
		velocity.x = RUN_SPEED
	elif Input.is_key_pressed(KEY_A):
		velocity.x = -RUN_SPEED
	else:
		velocity.x = 0
		
		
	# Limitar que el Player no caiga muy rapido
	if velocity.y < MAX_FALL_SPEED: 
		velocity.y += GRAVITY
	
	# Desplazar al Player de acuerdo al velocity,
	# evaluando por colisiones en el proceso
	velocity = move_and_slide(velocity, FLOOR)
	
	# Ubicar la mira donde este el mouse
	crosshair.global_position = get_global_mouse_position()
	# Rotar la pistola para que apunte a donde este la mira
	gun.look_at(get_global_mouse_position())
	
	# Hace desaparecer la teleport ball flotando al lado tuyo
	# si esta volando y por lo tanto, no puede ser arrojada
	floating_teleport_ball.visible = can_throw_teleport_ball

# Funcion para disparar arma
func fire():
	# Crear una instancia de bala, fijar su origen en el arma,
	# y despues crearla en el nivel con "add_child"
	var bullet = bullet_scene.instance()	
	bullet.position = gun.get_node("Gun_Tip").get_global_position()
	bullet.destination = crosshair.get_global_position()
	get_parent().add_child(bullet)

#Funcion para arrojar teleport ball
func throw_teleport_ball():
	can_throw_teleport_ball = false	# Ya no puedes arrojar la teleport ball
	var teleport_ball = teleport_ball_scene.instance()
	teleport_ball.position = gun.get_node("Gun_Tip").get_global_position()
	get_parent().add_child(teleport_ball)


	
# Esta funcion se llama cada vez que cualquier input se detecta
# "input" siendo una tecla presionada, mouse clickeada, etc.
func _input(event):
	if event is InputEventMouseButton:
		match event.button_index:
			BUTTON_LEFT:
				if event.is_pressed():
					fire()
			BUTTON_RIGHT:
				if event.is_pressed():
					throw_teleport_ball()
		

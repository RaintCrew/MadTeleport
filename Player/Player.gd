extends KinematicBody2D

const RUN_SPEED = 100 		# velocidad lateral de Player al caminar
const GRAVITY = 10 			# aceleracion vertical que disminuye la velocidad vertical del Player
const FLOOR = Vector2(0,-1) # vector normal que el physics engine usa para frenar con pisos y paredes
const MAX_FALL_SPEED = 200 	# lo mas rapido que puede caer el Player por gravedad

var velocity = Vector2() 	# Un vector (x,y) donde x/y define cuanto se mueve horizontal/verticalmente en cada frame.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	# Controles tecla "A" y "D" para moverse lateralmente
	# Al no presionar ninguna tecla, el Player se detiene horizontalmente
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

extends KinematicBody2D

const RUN_SPEED = 100 		# velocidad lateral de Player al caminar
const GRAVITY = 10 			# aceleracion vertical que disminuye la velocidad vertical del Player
const FLOOR = Vector2(0,-1) # vector normal que el physics engine usa para frenar con pisos y paredes
const MAX_FALL_SPEED = 200 	# lo mas rapido que puede caer el Player por gravedad

const JUMP_FORCE = 165 		# qué tan alto puede saltar el jugador


const PISTOL_AMMO = 6
var stats = PlayerStats				# Access to the Singleton with the stats.
var velocity = Vector2() 			# Vector (x,y) donde x/y define cuanto se mueve horizontal/verticalmente en cada frame.
var target_running_velocity = 0
var ammo = PISTOL_AMMO 				# Numero de balas en el arma. Se recarga con Teleport

var can_throw_teleport_ball = true	# Puede arrojar la teleport ball, o esta en el aire y no puede lanzarla
var has_landed = true				# Se usa para ejecutar code en el primer instante que aterriza en suelo

var will_camera_shake_on_gunfire = true

onready var crosshair = get_node("Crosshair") 			# Referencia a la crosshair
onready var gun = get_node("Gun") 						# Referencia al arma de la que disparas
onready var floating_teleport_ball = get_node("Ball") 	# Referencia a teleport ball flotando al lado tuyo
onready var teleport_ball = null						# Referencia a teleport ball lanzada a la cual te teleportas

onready var bullet_scene = preload("res://Player/Bullet.tscn") 				# Referencia a escena de bala
onready var teleport_ball_scene = preload("res://Player/TeleportBall.tscn") # Referencia a escena de teleport ball


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# no_health is the signal we're connecting to
	# self is this object (like "this" in any othe major programming language xd)
	# "queue_free" is the function that will be called.
	stats.connect("no_health",self,"queue_free")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	# Controles tecla "A" y "D" para moverse lateralmente
	# Al no presionar ninguna tecla, el Player se detiene lateralmente
	if Input.is_key_pressed(KEY_D):
		target_running_velocity = RUN_SPEED
		print(velocity.x)
	elif Input.is_key_pressed(KEY_A):
		target_running_velocity = -RUN_SPEED
	else:
		target_running_velocity = 0
	
	if target_running_velocity == 0:
		velocity.x += (target_running_velocity - velocity.x) * 0.7
	else:
		velocity.x += (target_running_velocity - velocity.x) * 0.4
	
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
	
	$Ammo_Label.text = str(ammo) # Mostrar en texto la municion del arma
	
	# El jugador y el arma se voltean hacia donde este la crosshair
	if crosshair.global_position.x < global_position.x:
		$PlayerSprite.flip_h = true
		gun.flip_v = true
	else:
		$PlayerSprite.flip_h = false
		gun.flip_v = false
	
	# Cuando el Player aterriza en suelo, su sprite se deforma
	# Este codigo es el que se encarga en cada frame de suavemente
	# acomodar la sprite de vuelta a su forma normal
	$PlayerSprite.scale.y += (1 - $PlayerSprite.scale.y) * 0.2
	$PlayerSprite.scale.x += (1 - $PlayerSprite.scale.x) * 0.2
	$PlayerSprite.position.y += (0 - $PlayerSprite.position.y) * 0.2
	
	$Gun.position.x += (0 - $Gun.position.x) * 0.2
	$Gun.position.y += (0 - $Gun.position.y) * 0.2
	
	# Ejecutar efectos en el primer instante que el Player aterriza en suelo
	if is_on_floor():
		if has_landed == false:
			$PlayerSprite.position.y += 2
			$PlayerSprite.scale.y = 0.7
			$PlayerSprite.scale.x = 1.3
			
			has_landed = true
	else: 
		has_landed = false
		

func jump():
	if is_on_floor():
		velocity.y = -JUMP_FORCE
		$PlayerSprite.scale.x = 0.7
		$PlayerSprite.scale.y = 1.3
		$PlayerSprite.position.y -= 2
		

# Funcion para disparar arma
func fire():
	if ammo > 0:	# Tienes que tener municion para disparar
		# Crear una instancia de bala, fijar su origen en el arma,
		# y despues crearla en el nivel con "add_child"
		var bullet = bullet_scene.instance()	
		bullet.position = gun.get_node("Gun_Tip").get_global_position()
		bullet.destination = crosshair.get_global_position()
		get_parent().add_child(bullet)
		
		ammo -= 1
		
		# Gun recoil vfx
		var recoil = $Gun.global_position.direction_to(crosshair.global_position)
		recoil *= 6
		$Gun.global_position -= recoil
		
		if will_camera_shake_on_gunfire:
			get_parent().get_node("Camera").shake = true


# Funcion para arrojar teleport ball
func throw_teleport_ball():
	can_throw_teleport_ball = false	# Ya no puedes arrojar la teleport ball
	
	# Crear una instancia de teleport ball, fijar su origen en el arma,
	# y despues crearla en el nivel con "add_child"
	teleport_ball = teleport_ball_scene.instance()
	teleport_ball.position = gun.get_node("Gun_Tip").get_global_position()
	get_parent().add_child(teleport_ball)

# Funcion de teleportarse hacia la teleport ball
func teleport():
	# Relocar al jugador donde este la teleport_ball
	self.global_position = teleport_ball.get_global_position()
	
	velocity.y = 0					# El momentum de caida no se mantiene al teleportarse
	regain_teleport_ball()	# Re-obtienes la teleport ball y puedes tirarla de nuevo
	teleport_ball.queue_free()		# Borrar la teleport ball que estaba viajando
	reload()	# Teleportarse es lo que recarga tus armas

# Funcion para recargar tu arma. Suele ejecutarse al teleportarse
# Si vamos a agregar mas armas, esta funcion se modifica para cada tipo de arma
func reload():
	ammo = PISTOL_AMMO

# Funcion para recuperar la teleport ball
# Esta en su opcion porque probablemente hagamos algunos vfx
# cuando ocurra. Esos se pondrian aqui.
func regain_teleport_ball():
	can_throw_teleport_ball = true

	
# Esta funcion se llama cada vez que cualquier input se detecta
# "input" siendo una tecla presionada, mouse clickeada, etc.
func _input(event):
	if event.is_action_pressed("jump"):
		jump()
	
	if event is InputEventMouseButton:
		match event.button_index:		# Esto es como el switch-case statements en C++/Python
			BUTTON_LEFT:				# Clic-izquierdo = disparar
				if event.is_pressed():	# Registrar solo el clic, y no su release o el dejarlo presionado
					fire()
			BUTTON_RIGHT:						# Clic-derecho = arrojar teleport ball/teleportarse
				if event.is_pressed():			
					if can_throw_teleport_ball:	# Depende de si la teleport ball esta disponible o no
												# O arrojas la teleport ball, o te teleportas a ella
						throw_teleport_ball()
					else:
						teleport()
		


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage

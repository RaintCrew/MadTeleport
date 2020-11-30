extends Area2D

var speed = 10					# Speed de la bala
var velocity = Vector2()		# Vector velocidad x/y
var destination = null	# Punto a donde va la bala (donde estaba la mira al disparar)
export var can_cross_walls = false
onready var sprite = $Sprite
onready var flash = $Flash

# Called when the node enters the scene tree for the first time.
func _ready():
	#destination = get_local_mouse_position()	# La bala viaja hacia donde esta la mira
	look_at(destination)
	flash.visible = true
	yield(get_tree().create_timer(0.04),"timeout")
	flash.visible = false

	
	velocity = global_position.direction_to(destination)
	velocity *= speed

func _physics_process(delta):
	# Mover hacia destino
	global_position += velocity
	

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


func _on_BallHitbox_area_entered(area):
	self.queue_free()
	pass # Replace with function body.

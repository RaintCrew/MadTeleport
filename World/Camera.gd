extends Camera2D

##################################
# Sadly, I don't quite understand this code. Just took it from a tutorial
# Any other object in the scene can make this camera shake by setting
# its "shake" variable to true.
#
# Play with amplitude and duration variables
# to power up or down the shake effect
#################################

onready var timer : Timer = $Shake_Timer

export var amplitude : = 1.6
export var duration : = 0.1
export(float, EASE) var DAMP_EASING : = 1.0
export var shake : = false setget set_shake
var fading_in = true
var enabled : = false


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	self.duration = duration
	$BlackScreen.visible = true	# If the black screen is set as visible in the editor
								# we can't edit the levels because it blocks sight.
	$AnimationPlayer.play("BlackScreenFadeOut")
	yield($AnimationPlayer, "animation_finished")
	fading_in = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shake:
		var damping : = ease(timer.time_left / timer.wait_time, DAMP_EASING)
		offset = Vector2(
			rand_range(amplitude, -amplitude) * damping,
			rand_range(amplitude, -amplitude) * damping)
	
	$Flash.modulate.a += (0 - $Flash.modulate.a) * 0.2



func _on_camera_shake_requested():
	if not enabled:
		return
	self.shake = true

func set_duration(value):
	duration = value
	timer.wait_time = duration

func set_shake(value):
	shake = value
	#set_process(shake)
	offset = Vector2()
	if shake:
		timer.start(duration)

	
func _on_Timer_timeout():
	self.shake = false

func flash():
	$Flash.modulate.a = 1

func activate_shake(given_amplitude, given_duration):
	amplitude = given_amplitude
	duration = given_duration
	self.shake = true

func display_gameover():
	$AnimationPlayer.play("GameOverFadeIn")
	

extends Node2D

onready var currentScene = get_tree().get_current_scene().get_filename()
var is_restarting = false
var level_cleared = false
onready var camera_animation_player = $Camera/AnimationPlayer
onready var pause_popup = $PausePopup
var next_level = String()

signal level_cleared

func _ready():
	PlayerStats.health = PlayerStats.max_health
	PlayerStats.ammo = PlayerStats.max_ammo
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("reset"):
		if not is_restarting:
			camera_animation_player.play("BlackScreenFadeIn")
			is_restarting = true
			yield(camera_animation_player, "animation_finished")
			get_tree().change_scene(currentScene)
			get_tree().paused = false
			PlayerStats.health = PlayerStats.max_health
			PlayerStats.ammo = PlayerStats.max_ammo

	if Input.is_action_just_pressed("esc"):
		if not is_restarting and !Global.player.player_dead:
			get_tree().paused = true
			yield(get_tree().create_timer(0.1), "timeout")
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			pause_popup.show()


func disable_all_spawners():
	for spawner in get_tree().get_nodes_in_group("all_enemy_spawners"):
		spawner.spawning = false

# Called when player clears level
func clear_level():
	level_cleared = true
	emit_signal("level_cleared")
	camera_animation_player.play("ShowLevelCleared")
	yield(get_tree().create_timer(3), "timeout")
	camera_animation_player.play("BlackScreenFadeIn")
	is_restarting = true
	yield(camera_animation_player, "animation_finished")
	PlayerStats.health = PlayerStats.max_health
	get_tree().change_scene(next_level)
	pass

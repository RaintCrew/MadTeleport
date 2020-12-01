extends CenterContainer

var has_tp = true setget set_tp

onready var TPBallFull = $TPBallFull

func set_tp(value):
	has_tp = value
	TPBallFull.set_visible(has_tp)
	
func _ready():
	PlayerStats.connect("has_tp_changed", self, "set_tp")

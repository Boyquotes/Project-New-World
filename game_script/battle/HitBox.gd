extends Area2D

class_name HitBox

onready var _collision : CollisionShape2D = $CollisionShape2D

var dmg : int = 0
var is_crit : bool = false

func init(is_party: bool) -> void:
	var layer = 2
	if is_party:
		layer = 1
	set_collision_layer_bit(layer, true)

func enable_collision() -> void:
	_collision.disabled = false

func disable_collision() -> void:
	_collision.disabled = true


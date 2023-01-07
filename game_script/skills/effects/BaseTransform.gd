extends Node2D

class_name CharacterTransform

signal end_transfrom()

onready var _aniPlayer : AnimationPlayer = $AnimationPlayer as AnimationPlayer
onready var _sprite : Sprite = $Sprite as Sprite
onready var _hitbox : HitBox = $HitBox as HitBox

var stats : CharacterStats
var is_party : bool

func _ready():
	visible = false
	_hitbox.disable_collision()
	_hitbox.init(is_party)
	init_transform()

func setter(is_party: bool, stats: CharacterStats) -> void:
	self.stats = stats
	self.is_party = is_party

func init_transform() -> void:
	pass
		
func activeTransform() -> void:
	visible = true
	_aniPlayer.play("transform")

func endTransform() -> void:
	visible = false
	_hitbox.disable_collision()
	emit_signal("end_transfrom")


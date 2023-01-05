extends Node2D

class_name CharacterTransform

signal end_transfrom()

onready var _aniPlayer : AnimationPlayer = $AnimationPlayer as AnimationPlayer
onready var _sprite : Sprite = $Sprite as Sprite
onready var _hitbox : HitBox = $HitBox as HitBox

func _ready():
	visible = false
	_hitbox.disable_collision()

func init_transform(is_party: bool, dmg: int, type: int) -> void:
	scale = Vector2(-1, 1)
	_hitbox.dmg = dmg
	_hitbox.is_crit = false
	_hitbox.type = type
	_hitbox.init(is_party)
		

func activeTransform() -> void:
	visible = true
	_aniPlayer.play("UB")

func endTransform() -> void:
	visible = false
	_hitbox.disable_collision()
	emit_signal("end_transfrom")


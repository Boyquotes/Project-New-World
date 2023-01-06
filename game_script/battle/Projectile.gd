extends Node2D

class_name Projectile

onready var _hitbox : HitBox = $HitBox
onready var _sprite : Sprite = $Sprite
onready var _aniPlayer : AnimationPlayer = $AnimationPlayer

var SPEED := 200
var dir := 1
var _texture : Texture

func _ready():
	_sprite.set_texture(_texture)
	_aniPlayer.play("Shoot")

func _physics_process(_delta: float):
	position.x += SPEED * dir * _delta

func get_class() -> String: return "Projectile"

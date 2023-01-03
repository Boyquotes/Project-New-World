extends KinematicBody2D

class_name Entity

signal hp_changed(new_hp, pos)
signal set_max_hp(max_hp, pos)

var txt_dmg_number = preload("res://components/battle/DamageNumber.tscn")

onready var stats : CharacterStats = $Stats as CharacterStats
onready var skill : CharacterSkill = $Skill as CharacterSkill
onready var battleSprite : Sprite = $InBattle as Sprite
onready var idleSprite : Sprite = $Idle as Sprite
onready var animationPlayer : AnimationPlayer = $AnimationPlayer as AnimationPlayer

export var c_name: String
export var is_party : bool = true

const max_dur = 12

var pos : int
var _velocity := Vector2.ZERO
var dir = -20
var isKnockBack = false
var knockback_duration = max_dur

func _ready() -> void:
	set_resource()
	battleSprite.set_flip_h(is_party)
	running()

func running() -> void:
	animationPlayer.play("running")

func set_resource() ->  void:
	if c_name == null : 
		queue_free()
	var spriteImg = load("res://assets/sprite/" + c_name +"/inbattle.png")
	var idleImg = load("res://assets/sprite/" + c_name +"/idle.png")
	var startStats = load("res://game_script/character_stats/" + c_name + ".tres")
	stats.init(startStats)
	dir *= stats.speed
	emit_signal("set_max_hp", stats.max_hp, pos)
	if is_party: 
		dir = -dir
	battleSprite.set_texture(spriteImg)
	idleSprite.set_texture(idleImg)

func isCrit() -> bool:
	var percent = randf()
	if percent > (1 - float(stats.crit_c) / 100):
		return true
	return false

func activeUB() -> void:
	print("UB")

func on_collide(target: Entity) -> void:
	isKnockBack = true
	knockback_duration = max_dur
	animationPlayer.play("attack")
	var is_crit = isCrit()
	var dmg = stats.physic
	if is_crit: 
		dmg = dmg * stats.crit_dmg / 100
	target.stats.take_dmg(dmg, is_crit)
	
func _physics_process(_delta: float) -> void:
	if isKnockBack:  
		if is_party : _velocity.x = -500
		else: _velocity.x = 500

		knockback_duration -= 1
		if knockback_duration <= 0 : 
			isKnockBack = false
			knockback_duration = max_dur
	else: 
		_velocity.x = dir

	_velocity = move_and_slide(_velocity)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if(collision.collider.get_class() == "Entity"):
			on_collide(collision.collider)

func showDamageNumber(amount: int, is_crit: bool) -> void:
	var text : DamageNumber = txt_dmg_number.instance()
	text.amount = amount
	text.isPartyMember = is_party
	text.is_crit = is_crit
	add_child(text)

func _on_Stats_hp_changed(_new_hp: int, amount: int, is_crit: bool):
	showDamageNumber(amount, is_crit)
	if(is_party):
		emit_signal("hp_changed", _new_hp, pos)

func get_class() -> String: return "Entity"

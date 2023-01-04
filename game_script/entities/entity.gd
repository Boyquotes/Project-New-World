extends KinematicBody2D

class_name Entity

enum SideEffect { NONE, BUFF, TRANSFORM }

signal hp_changed(new_hp, pos)
signal set_max_hp(max_hp, pos)
signal actived_ub(index, _position, is_party)

var txt_dmg_number = preload("res://components/battle/DamageNumber.tscn")

onready var stats : CharacterStats = $Stats as CharacterStats
onready var skill : CharacterSkill = $Skill as CharacterSkill
onready var hurtBox : HurtBox = $HurtBox as HurtBox
onready var battleSprite : Sprite = $InBattle as Sprite
onready var idleSprite : Sprite = $Idle as Sprite
onready var animationPlayer : AnimationPlayer = $AnimationPlayer as AnimationPlayer

export var c_name: String
export var is_party : bool = true

#gameplay section
const max_dur = 10

var pos : int
var _velocity := Vector2.ZERO
var dir = -15
var isKnockBack = false
var knockback_duration = max_dur

#skill section
var ts : CharacterTransform
var ub : LayerUB

func _ready() -> void:
	set_resource()
	battleSprite.set_flip_h(is_party)
	hurtBox.init(is_party)
	running()

func running() -> void:
	animationPlayer.play("running")

func set_resource() ->  void:
	if c_name == null : 
		queue_free()
	var spriteImg = load("res://assets/sprite/" + c_name +"/inbattle.png")
	var idleImg = load("res://assets/sprite/" + c_name +"/idle.png")
	var startStats = load("res://game_script/character_stats/resources/" + c_name + ".tres")
	var baseSkill = load("res://game_script/skills/resources/" + c_name + ".tres")

	ub = load("res://components/UB/" + c_name + "/UB.tscn").instance()
	ub.is_party = is_party
	ub.connect("finish", self, "_on_UB_animation_finish")
	add_child(ub)

	stats.init(startStats)
	dir *= stats.speed
	emit_signal("set_max_hp", stats.max_hp, pos)

	skill.init(baseSkill)
	if skill.effect == SideEffect.TRANSFORM:
		ts = load("res://components/UB/" + c_name + "/ts.tscn").instance()
		ts.connect('end_transfrom', self, '_on_end_Transform')
		add_child(ts)
		ts.init_transform(is_party, 5)
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
	battleSprite.visible = false
	ub.runAnimation(position)
	emit_signal("actived_ub", pos, position, is_party)
	get_tree().paused = true

func _on_UB_animation_finish():
	battleSprite.visible = true
	if skill.effect == SideEffect.TRANSFORM:
		ts.activeTransform()

func normal_hit_enemy(target: Entity) -> void:
	animationPlayer.play("attack")
	var is_crit = isCrit()
	var dmg = stats.physic
	if is_crit: 
		dmg = dmg * stats.crit_dmg / 100
	target.take_damage(dmg, is_crit)
	
func take_damage(amount: int, is_crit: bool) -> void:
	if amount == 0: 
		return
	stats.take_dmg(amount, is_crit)

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

func showDamageNumber(amount: int, is_crit: bool) -> void:
	var text : DamageNumber = txt_dmg_number.instance()
	text.amount = amount
	text.isPartyMember = is_party
	text.is_crit = is_crit
	add_child(text)

func _on_Stats_hp_changed(_new_hp: int, amount: int, is_crit: bool):
	isKnockBack = true
	knockback_duration = max_dur
	showDamageNumber(amount, is_crit)
	if(is_party):
		emit_signal("hp_changed", _new_hp, pos)

func get_class() -> String: return "Entity"

#side effect skill
func _on_end_Transform() -> void:
	battleSprite.visible = true

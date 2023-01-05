extends KinematicBody2D

class_name Entity

enum SideEffect { NONE, BUFF, TRANSFORM }
enum DamameType { PHYSIC, MAGIC, TRUE, PIERCE }
enum BaseClass { FIGHTER, DEFENDER, PALADIN, ARCHER, MAGICAN, HEALER }

signal hp_changed(new_hp, pos)
signal set_max_hp(max_hp, pos)
signal tp_changed(new_tp, pos)
signal actived_ub(index, _position, is_party)

var txt_dmg_number = preload("res://components/battle/DamageNumber.tscn")
var node_aa_range = preload("res://components/battle/AttackRange.tscn")

onready var stats : CharacterStats = $Stats as CharacterStats
onready var skill : CharacterSkill = $Skill as CharacterSkill
onready var hurtBox : HurtBox = $HurtBox as HurtBox
onready var battleSprite : Sprite = $InBattle as Sprite
onready var idleSprite : Sprite = $Idle as Sprite
onready var animationPlayer : AnimationPlayer = $AnimationPlayer as AnimationPlayer

export var c_name: String
export var is_party : bool = true
export var level : int

var attack_range : AttackRange

#?gameplay section
var wait_time = 80
var can_move := true
const max_dur = 10

var pos : int
var _velocity := Vector2.ZERO
var dir = -1
var isKnockBack = false
var knockback_duration = max_dur

#?skill section
var ts : CharacterTransform
var ub : LayerUB

func _ready() -> void:
	set_resource()
	hurtBox.init(is_party)
	animationPlayer.play("Idle")

func set_resource() ->  void:
	if c_name == null : 
		queue_free()
	var spriteImg = load("res://assets/sprite/" + c_name +"/inbattle.png")
	var idleImg = load("res://assets/sprite/" + c_name +"/idle.png")
	var startStats = load("res://game_script/character_stats/resources/" + c_name + ".tres")
	var baseSkill = load("res://game_script/skills/resources/" + c_name + ".tres")

	stats.init(startStats, level)
	dir *= stats.speed
	emit_signal("set_max_hp", stats.max_hp, pos)

	if stats.is_ranged:
		attack_range = node_aa_range.instance()
		attack_range.init(stats.c_range, is_party)
		# warning-ignore:return_value_discarded
		attack_range.connect("toggle_movement", self, "_on_Movement_toggle")
		add_child(attack_range)

	skill.init(baseSkill, level)
	if skill.effect == SideEffect.TRANSFORM:
		ts = load("res://components/UB/" + c_name + "/ts.tscn").instance()
		# warning-ignore:return_value_discarded
		ts.connect('end_transfrom', self, '_on_end_Transform')
		add_child(ts)
		ts.init_transform(is_party, 5, skill.type)

	if is_party:
		scale = Vector2(-1, 1)
		dir = -dir

	ub = load("res://components/UB/" + c_name + "/UB.tscn").instance()
	ub.init(skill, is_party)
	# warning-ignore:return_value_discarded
	ub.connect("finish", self, "_on_UB_animation_finish")
	add_child(ub)

	battleSprite.set_texture(spriteImg)
	idleSprite.set_texture(idleImg)

#* Battle Gameplay Mechanic
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
	if skill.effect == SideEffect.TRANSFORM:
		ts.activeTransform()
	else:
		battleSprite.visible = true

func normal_hit_enemy(target: Entity) -> void:
	animationPlayer.play("Attack")
	var is_crit = isCrit()
	var dmg = stats.physic
	if is_crit: 
		dmg = dmg * stats.crit_dmg / 100
	target.take_damage(dmg, is_crit, DamameType.PHYSIC)

func fire_projectile() -> void:
	pass
	
func take_damage(amount: int, is_crit: bool, type: int) -> void:
	if amount == 0: 
		return
	skill.addTP(100)
	stats.take_dmg(amount, is_crit, type)

#* Process each frame
func running() -> void:
	animationPlayer.play("Running")

func _physics_process(_delta: float) -> void:
	if wait_time > 0:
		wait_time -= 1
		if wait_time == 0:
			idleSprite.visible = false
			battleSprite.visible = true
			running()
		return
	if !can_move:
		_velocity = Vector2.ZERO
	else:
		if isKnockBack:
			if is_party: _velocity.x = -400
			else: _velocity.x = 400
				
			knockback_duration -= 1
			if knockback_duration <= 0 : 
				isKnockBack = false
				knockback_duration = max_dur
		else: 
			_velocity.x = dir

	_velocity = move_and_slide(_velocity)

func _on_Movement_toggle(move: bool) -> void:
	can_move = move

#* Signal Management
func showDamageNumber(amount: int, is_crit: bool, type: int) -> void:
	var text : DamageNumber = txt_dmg_number.instance()
	text.amount = amount
	text.isPartyMember = is_party
	text.is_crit = is_crit
	text.type = type
	add_child(text)

func _on_Stats_hp_changed(_new_hp: int, amount: int, is_crit: bool, type: int):
	showDamageNumber(amount, is_crit, type)
	if is_party:
		emit_signal("hp_changed", _new_hp, pos)

func _on_Skill_add_tp(newTP: int):
	if is_party:
		emit_signal("tp_changed", newTP, pos)

func get_class() -> String: return "Entity"

#* Skill Side Effect
func _on_end_Transform() -> void:
	battleSprite.visible = true

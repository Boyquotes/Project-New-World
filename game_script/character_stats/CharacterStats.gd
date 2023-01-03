extends Node

class_name CharacterStats

signal hp_changed(new_hp)
signal hp_depleted()

var max_hp : int
var current_hp : int
var physic : int
var p_defense : int
var m_armor : int
var crit_c : int
var crit_dmg: int
var speed : int
var current_ub : int = 0

export var level: int = 10

func init(stats: StartingStats) -> void:
	max_hp = stats.max_hp
	current_hp = stats.max_hp
	physic = stats.physic
	p_defense = stats.p_defense
	m_armor = stats.m_armor
	crit_c = stats.crit_c
	crit_dmg = stats.crit_dmg
	speed = stats.speed

func take_dmg(amount: int, is_crit: bool) -> void:
	current_hp -= amount
	current_hp = max(0, current_hp)
	emit_signal("hp_changed", current_hp, amount, is_crit)
	if current_hp == 0:
		emit_signal("hp_depleted")

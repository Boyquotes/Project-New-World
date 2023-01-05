extends Node

class_name CharacterSkill

signal add_tp(newTP)

const fullUB = 1000

var current_tp : int = 0

var dmg : int
var type : int
var skill_name : String
var skill_description : String
var effect : int

func init(skill: BaseSkill, lvl: int) -> void:
	skill_name = skill.skill_name
	skill_description = skill.skill_description
	dmg = skill.base_dmg
	type = skill.type
	effect = skill.side_effect

func addTP(amount: int) -> void:
	if current_tp == fullUB:
		return
	current_tp += amount
	current_tp = max(0, current_tp)
	emit_signal("add_tp", current_tp)

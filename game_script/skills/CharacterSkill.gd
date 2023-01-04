extends Node

class_name CharacterSkill

signal add_tp()

const fullUB = 1000

var currentBar : int = 0

var dmg : int
var type : int
var skill_name : String
var skill_description : String
var effect : int

func init(skill: BaseSkill) -> void:
	skill_name = skill.skill_name
	skill_description = skill.skill_description
	dmg = skill.base_dmg
	type = skill.type
	effect = skill.side_effect

func addTP() -> void:
	emit_signal("add_tp")

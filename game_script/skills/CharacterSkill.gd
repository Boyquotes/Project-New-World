extends Node

class_name CharacterSkill

var dmg : int
var type : int
var skill_name : String
var effect : int

func init(skill: BaseSkill) -> void:
	skill_name = skill.skill_name
	dmg = skill.base_dmg
	type = skill.type
	effect = skill.side_effect

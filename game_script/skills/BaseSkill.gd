extends Resource

class_name BaseSkill

enum DamameType { PHYSIC, MAGIC, TRUE, PIERCE }
enum SideEffect { NONE, BUFF, TRANSFORM }

export var skill_name : String = 'skill_name'
export var skill_description : String = ''

export var base_dmg : int

export (DamameType) var type
export (SideEffect) var side_effect 

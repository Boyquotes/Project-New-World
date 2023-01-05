extends Resource

class_name StartingStats

enum BaseClass { FIGHTER, DEFENDER, PALADIN, ARCHER, MAGE, HEALER }

export var base_name : String = 'char_name'

export var max_hp : int = 100
export var physic : int = 10
export var magic : int = 0
export var p_defense : int = 10
export var m_armor : int = 10
export var crit_c : int = 10
export var crit_dmg: int = 150
export var speed : int = 140
export var attack_range : int = 0

export (BaseClass) var base_class

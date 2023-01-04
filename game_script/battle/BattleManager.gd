extends Node2D

class_name BattleManager

var entityInstance = preload("res://components/battle/character.tscn")

onready var battleScene : Node2D = $Battle as Node2D
onready var party_formation : Formation = $Battle/PartyFormation as Formation
onready var ui : BattleUI = $UIBattle as BattleUI

var enemy_formation : Formation

func _ready():
	var ally = [{ "name": "mezuna_ryuji" }, { "name": "thanh_dung" }]
	var enemy = [{ "name": "thanh_dung" }]
	
	ui.initButton(ally)
	initEnemiesFormation()
	field_characters(ally, enemy)

func initEnemiesFormation() -> void:
	enemy_formation = load("res://components/battle/formation/5EnemiesFormation.tscn").instance()
	battleScene.add_child(enemy_formation)

func field_characters(party_member: Array, enemies: Array) -> void: 
	for i in len(party_member):
		var init_position = party_formation.get_child(i)
		var newEntity : Entity = entityInstance.instance()
		newEntity.c_name = party_member[i]["name"]
		newEntity.is_party = true
		newEntity.position = init_position.position
		newEntity.pos = i 
		newEntity.connect("actived_ub", self, "_on_Actived_UB")
		newEntity.connect("hp_changed", self, "_on_Char_hp_changed")
		newEntity.connect("set_max_hp", self, "_on_set_MAX_HP")
		newEntity.set_collision_layer_bit(1, true)
		newEntity.set_collision_mask_bit(2, true)
		init_position.replace_by(newEntity)

	for i in len(enemies):
		var init_position = enemy_formation.get_child(i)
		var newEntity : Entity = entityInstance.instance()
		newEntity.c_name = enemies[i]["name"]
		newEntity.is_party = false
		newEntity.pos = i
		newEntity.position = init_position.position
		newEntity.set_collision_layer_bit(2, true)
		newEntity.set_collision_mask_bit(1, true)
		init_position.replace_by(newEntity)

func _on_Char_hp_changed(_new_hp: int, pos: int) -> void:
	ui.change_ui_hp(_new_hp, pos)

func _on_set_MAX_HP(_max_hp: int, pos: int) -> void:
	ui.set_ui_maxHP(_max_hp, pos)

func _active_UB(i: int) -> void:
	party_formation.get_child(i).activeUB()

func _on_Actived_UB(_index, _position, _is_party) -> void:
	pass

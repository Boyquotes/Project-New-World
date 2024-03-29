extends Node2D

class_name BattleManager

var entityInstance = preload("res://components/battle/character.tscn")

onready var battleScene : Node2D = $Battle as Node2D
onready var party_formation : Formation = $Battle/PartyFormation as Formation
onready var ui : BattleUI = $UIBattle as BattleUI
onready var ubLayer : UBLayer = $UBLayer

var enemy_formation : Formation
var count_allies : int = 0
var count_enemies : int = 0
var team_death := 0
var enemy_death := 0

func _ready():
	var ally = [
		{ 
			"name": "hoa_lan", 
		"skill_icon": 1
			
		}
		,
		{ 
			"name": "mezuna_ryuji",
			"skill_icon": 2
		}
		]
	var enemy = [{ 
		"name": "thanh_dung", "skill_icon": 1
	}]
	
	ui.initButton(ally)
	initEnemiesFormation()
	ubLayer.setter(ally, enemy)
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
		newEntity.connect("set_max_hp", self, "_on_set_MAX_HP")
		newEntity.connect("hp_depleted", self, "_on_Char_hp_depleted")
		newEntity.connect("hp_changed", self, "_on_Char_hp_changed")
		newEntity.connect("tp_changed", self, "_on_Char_tp_changed")
		newEntity.set_collision_layer_bit(1, true)
		newEntity.set_collision_mask_bit(2, true)
		init_position.replace_by(newEntity)
		count_allies += 1

	for i in len(enemies):
		var init_position = enemy_formation.get_child(i)
		var newEntity : Entity = entityInstance.instance()
		newEntity.c_name = enemies[i]["name"]
		newEntity.is_party = false
		newEntity.position = init_position.position
		newEntity.pos = i
		newEntity.connect("hp_depleted", self, "_on_Char_hp_depleted")
		newEntity.set_collision_layer_bit(2, true)
		newEntity.set_collision_mask_bit(1, true)
		init_position.replace_by(newEntity)
		count_enemies += 1

#* Manage UB
func _active_UB(is_party: bool, pos: int) -> void:
	var character : Entity
	if is_party:
		character = party_formation.get_child(pos)
	else:
		character = enemy_formation.get_child(pos)
	var _position = character.activeUB()
	if _position != null:
		ubLayer.visible = true
		ubLayer.run_ub_ani(is_party, pos, _position)

func _on_UB_animation_finished(is_party: bool, pos: int) -> void:
	get_tree().paused = false
	var character : Entity
	if is_party:
		character = party_formation.get_child(pos)
	else:
		character = enemy_formation.get_child(pos)
	ubLayer.visible = false
	character.UB_animation_finish()

#* Show Stat
func _on_Char_hp_changed(_new_hp: int, pos: int) -> void:
	ui.change_ui_hp(_new_hp, pos)

func _on_Char_hp_depleted(is_party: bool) -> void:
	if is_party:
		team_death += 1
		if team_death == count_allies:
			print("lose")
	else:
		enemy_death += 1
		if enemy_death == count_enemies:
			print("win")

func _on_Char_tp_changed(_new_hp: int, pos: int) -> void:
	ui.change_ui_tp(_new_hp, pos)

func _on_set_MAX_HP(_max_hp: int, pos: int) -> void:
	ui.set_ui_maxHP(_max_hp, pos)

func _input(event: InputEvent):
	if event.is_action_pressed("ub_pos_1"):
		if count_allies > 0:
			_active_UB(true, 0)
	if event.is_action_pressed("ub_pos_2"):
		if count_allies > 1:
			_active_UB(true, 1)
	if event.is_action_pressed("ub_pos_3"):
		if count_allies > 2:
			_active_UB(true, 2)
	if event.is_action_pressed("ub_pos_4"):
		if count_allies > 3:
			_active_UB(true, 3)
	if event.is_action_pressed("ub_pos_5"):
		if count_allies > 4:
			_active_UB(true, 4)

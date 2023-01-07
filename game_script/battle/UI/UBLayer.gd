extends CanvasLayer

class_name UBLayer

onready var allies = $Ally
onready var enemies = $Enemy

func setter(party: Array, opponent: Array) -> void:
	for i in len(party):
		var ani : NodeUB = load("res://components/UB/" + party[i]["name"] + "/ub_ani.tscn").instance()
		ani.scale = Vector2(-1, 1)
		ani.pos = i
		ani.is_party = true
		ani.connect("finish_ub", get_parent(), "_on_UB_animation_finished")
		allies.add_child(ani)
	for i in len(opponent):
		var ani : NodeUB = load("res://components/UB/" + opponent[i]["name"] + "/ub_ani.tscn").instance()
		ani.pos = i
		ani.is_party = false
		ani.connect("finish_ub", get_parent(), "_on_UB_animation_finished")
		enemies.add_child(ani)

func run_ub_ani(is_party: bool, pos: int, _position: Vector2) -> void:
	if is_party:
		allies.get_child(pos).start_ub_ani(_position)
	else:
		enemies.get_child(pos).start_ub_ani(_position)
	get_tree().paused = true

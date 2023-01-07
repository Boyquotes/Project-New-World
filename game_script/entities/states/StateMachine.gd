extends Node2D

class_name State

enum { RUNNING, KNOCKBACKED, LOAD_AA, SHOOT, DEATH }

var s_name
var change_state
var ani_player
var _body
var kb_dur := 0

func _physics_process(_delta) -> void:
	# warning-ignore:return_value_discarded
	_body.move_and_slide(_body.velocity)

	if s_name == KNOCKBACKED:
		kb_dur -= 1
		if kb_dur == 0:
			_body.change_state(RUNNING)
	if !_body.can_move && s_name == RUNNING:
		_body.change_state(LOAD_AA)

func setup(change_state, ani_player, _body) -> void:
	self.change_state = change_state
	self.ani_player = ani_player
	self._body = _body

extends State

class_name KnockBackState

var max_duration = 10

func _ready():
    kb_dur = max_duration
    if _body.is_party:
        _body.velocity.x = -500
    else:
        _body.velocity.x = 500

extends State

class_name RunningState

func _ready():
    _body.velocity.x = _body.dir

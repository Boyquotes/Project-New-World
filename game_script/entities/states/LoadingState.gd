extends State

class_name LoadingState

func _ready():
    ani_player.play("loading")
    _body.velocity.x = 0
extends State

class_name DeathState

func _ready():
    ani_player.play("dying")
    _body.velocity.x = 0
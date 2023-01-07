extends State

class_name ShootState

func _ready():
    _body.velocity.x = 0
    ani_player.play("attack")
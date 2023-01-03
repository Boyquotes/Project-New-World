extends Control

class_name ButtonUB

signal active_ub(i)

onready var textureImg : TextureRect = $UImain/Panel/TextureRect as TextureRect
onready var hpBar : ProgressBar = $HPBar
onready var ubBar : ProgressBar = $UBBAr

var pos : int
var c_name : String

func _ready() -> void:
	var spriteImg = load("res://assets/sprite/" + c_name +"/illustration.png")
	textureImg.set_texture(spriteImg)

func set_max_hp(value: int, _pos: int) -> void:
	hpBar.max_value = value
	pos = _pos

func set_current_hp(value: int) -> void:
	hpBar.value = value


func _on_Button_pressed():
	emit_signal("active_ub", pos)

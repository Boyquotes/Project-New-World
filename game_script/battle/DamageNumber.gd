extends Position2D

class_name DamageNumber

enum DamameType { PHYSIC, MAGIC, TRUE, PIERCE }

onready var label: Label = $Label as Label
onready var tween: Tween = $Tween as Tween

var amount = 0
var isPartyMember : bool
var is_crit : bool = false
var type : int

var _velocity = Vector2(0, 25)

func _ready() -> void:
	if isPartyMember : 
		label.rect_position = Vector2(-80, -55)
	#Physic
	if is_crit:
		label.add_color_override("font_color", Color(255/255.0, 90/255.0, 3/255.0))
	#Magic
	if type == DamameType.MAGIC:
		if is_crit:
			label.add_color_override("font_color", Color(210/255.0, 55/255.0, 255/255.0))
		else:
			label.add_color_override("font_color", Color(224/255.0, 135/255.0, 255/255.0))

	label.set_text("-" + str(amount))
	
	tween.interpolate_property(self, 'scale', scale, Vector2(1, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.7)
	tween.start()

func _on_Tween_tween_all_completed():
	self.queue_free()

func _process(_delta) -> void:
	position -= _velocity * _delta

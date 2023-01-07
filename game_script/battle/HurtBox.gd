extends Area2D

class_name HurtBox

func _ready() -> void:
	# warning-ignore:return_value_discarded
	connect("area_entered", self, "_on_Area_enter")
	# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_Body_enter")

func init(is_party: bool) -> void:
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(1, false)
	var mask  = 1
	if is_party:
		mask = 2
	set_collision_mask_bit(mask, true)

func _on_Area_enter(box: HitBox) -> void:
	if box == null:
		return
	if owner.get_class() == "Entity":
		owner.take_damage(box.dmg, box.is_crit, box.type)
		if box.is_kb:
			owner.change_state(1)

func _on_Body_enter(body) -> void:
	if body.get_class() != "Entity":
		return
	if owner.get_class() == "Entity":
		body.normal_hit_enemy(owner)
		owner.change_state(1)

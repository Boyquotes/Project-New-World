extends Area2D

class_name HurtBox

func _ready() -> void:
	# warning-ignore:return_value_discarded
	connect("area_entered", self, "_on_Area_enter")
	# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_Body_enter")

func init(is_party: bool) -> void:
	var mask  = 1
	if is_party:
		mask = 2
	set_collision_mask_bit(mask, true)

func _on_Area_enter(box: HitBox) -> void:
	if box == null:
		return
	if owner.get_class() == "Entity":
		owner.take_damage(box.dmg, box.is_crit, box.type)
		owner.isKnockBack = box.is_kb
		owner.knockback_duration = box.kb_dur

func _on_Body_enter(body) -> void:
	if body.get_class() != "Entity":
		return
	if owner.get_class() == "Entity":
		body.normal_hit_enemy(owner)
		owner.isKnockBack = true
		owner.knockback_duration = owner.max_dur

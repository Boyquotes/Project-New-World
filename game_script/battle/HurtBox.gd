extends Area2D

class_name HurtBox

signal get_hit(amount)

func _ready() -> void:
	connect("area_entered", self, "_on_Area_enter")
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

func _on_Body_enter(body) -> void:
	if body.get_class() != "Entity":
		return
	if owner.get_class() == "Entity":
		body.normal_hit_enemy(owner)
		body.isKnockBack = true
		body.knockback_duration = body.max_dur

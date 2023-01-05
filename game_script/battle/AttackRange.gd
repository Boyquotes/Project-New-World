extends Area2D

class_name AttackRange

signal toggle_movement(move)

onready var _colli : CollisionShape2D = $CollisionShape2D as CollisionShape2D

var enemy_count := 0

func init(extent: int, is_party: bool) -> void:
	var mask  = 1
	if is_party:
		mask = 2
	set_collision_mask_bit(mask, true)
	_colli.shape.extents = extent
	_colli.position = Vector2(-extent, 0)

func _on_AttackRange_body_entered(body):
	if body.get_class() != "Entity":
		return
	if enemy_count == 0:
		emit_signal("toggle_movement", false)
	enemy_count += 1

func _on_AttackRange_body_exited(body):
	if body.get_class() != "Entity":
		return
	enemy_count -= 1
	if enemy_count == 0:
		emit_signal("toggle_movement", true)

extends CharacterTransform

func init_transform() -> void:
	_hitbox.dmg = 0.5 * stats.magic
	_hitbox.type = 1
	_hitbox.is_crit = false

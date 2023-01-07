extends Node2D

func isCrit(crit_c: float) -> bool:
	var thresh = randf()
	if thresh > 1 - crit_c:
		return true
	return false

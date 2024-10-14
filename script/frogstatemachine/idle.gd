extends "res://script/frogstatemachine/frog_state.gd"
var allowed_change : bool
func enter():
	FROG.animatedsprite.play("idle")
	await get_tree().create_timer(0.5).timeout
	allowed_change = true
	
func update(delta):
	if !FROG.is_chasing and allowed_change:
		allowed_change = false
		return STATE.ROAMING
	return null

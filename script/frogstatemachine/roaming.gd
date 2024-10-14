extends "res://script/frogstatemachine/frog_state.gd"

var allowed_change

func enter():
	FROG.animatedsprite.play("run")

func update(delta):
	if !FROG.is_chasing and allowed_change:
		allowed_change = false
		return STATE.IDLE
	#return STATE.CHASING
	return null

func physics_update(delta):
	FROG.velocity.x += delta* FROG.dir * FROG.speed

func chose(array):
	return array.shuffle()

func _on_randomdirtimer_timeout() -> void:
	$randomdirtimer.wait_time = chose([1,1.5,2])
	FROG.dir = chose([Vector2.LEFT,Vector2.RIGHT])
	allowed_change = true
	FROG.velocity = 0 

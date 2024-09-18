extends "res://script/Toxic Frog FSM/state_frog.gd"


func enter():
	Frog.animatedsprite.play("run")


func update(delta):
	chase()
	frog_movement()
	if Frog.velocity.x == 0:
		return STATE.IDLE
	if !Frog.dead and Frog.is_chasing and !Frog.is_taking_damage:
		return STATE.RUN
	return null
	



func _on_timer_timeout() -> void:
	%Timer.wait_time = chose([2,1,1.5])
	Frog.dir = chose([Vector2.RIGHT,Vector2.LEFT])
	Frog.velocity.x = 0

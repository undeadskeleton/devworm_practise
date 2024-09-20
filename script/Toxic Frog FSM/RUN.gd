extends "res://script/Toxic Frog FSM/state_frog.gd"


func enter():
	Frog.animatedsprite.play("run")


func update(delta):
	print("is chasing :" , Frog.is_chasing)
	frog_movement()
	if !Frog.dead and Frog.is_taking_damage:
		return STATE.DAMAGED
	if !Frog.dead and !Frog.is_chasing:
		return STATE.ROAMING
	return null

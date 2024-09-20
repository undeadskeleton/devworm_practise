extends "res://script/Toxic Frog FSM/state_frog.gd"


func enter():
	print("playing idle animation")
	Frog.animatedsprite.play("ideal")


func update(delta):
	print("is chasing :" , Frog.is_chasing)
	if !Frog.dead and !Frog.is_chasing:
		return STATE.ROAMING
	if !Frog.dead and Frog.is_chasing and !Frog.is_taking_damage:
		return STATE.RUN
	return null
	

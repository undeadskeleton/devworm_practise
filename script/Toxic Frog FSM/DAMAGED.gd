extends "res://script/Toxic Frog FSM/state_frog.gd"


func enter():
	Frog.animatedsprite.play("hurt")


func update(delta):
	print("is taking damage :" , Frog.is_taking_damage)
	if !Frog.dead and Frog.is_chasing and !Frog.is_taking_damage:
		return STATE.RUN
	return null

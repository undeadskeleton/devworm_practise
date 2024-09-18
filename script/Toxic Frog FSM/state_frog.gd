extends Node

var STATE = null
var Frog = null
#var player = null

func enter():
	pass


func update(delta):
	pass


func exit():
	pass
	
func chase():
	if Global.playerAlive:
		Frog.is_chasing = true
	elif !Global.playerAlive:
		Frog.is_chasing = false

func chose(array):
	array.shuffle()
	return array.front()

func frog_movement():
	if !Frog.dead :
		Frog.is_roaming = true
		if !Frog.is_chasing:
			Frog.velocity += Frog.speed  * Frog.dir
		elif Frog.is_attacking:
			Frog.velocity.x = 0
		elif Frog.is_chasing and !Frog.is_taking_damage:
			var chase_dir = Frog.position.direction_to(Frog.player.position) * Frog.speed
			Frog.velocity.x = chase_dir.x
			Frog.dir = abs(Frog.velocity)/Frog.velocity
		elif Frog.is_taking_damage:
			var knockback = Frog.position.direction_to(Frog.player.position) * -60
			Frog.velocity.x = knockback.x
	elif Frog.dead:
		Frog.velocity.x = 0

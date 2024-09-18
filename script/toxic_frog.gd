extends CharacterBody2D

class_name FrogEnemy

@onready var animatedsprite = $AnimatedSprite2D

var dir : Vector2
var gravity_value : int = 900
var speed : int = 20
var dead : bool

var is_chasing : bool
var player = CharacterBody2D
var is_roaming : bool
var is_taking_damage : bool

var damage : int 
var allowed_to_take_damage : bool
 
var health : int = 50
var min_health : int = 0
var max_health : int = 50
var damage_deal : int = 50

var is_attacking : bool
var frog_damage_zone : Area2D 
var frog_damage_collision : Area2D

var points_for_kill : int = 250

#states
var previous_state
var current_state

#reference variables
@onready var state_machine = $State_Machine

func _ready() -> void:
	dead = false
	is_taking_damage = false
	player = Global.playerBody
	allowed_to_take_damage = true
	Global.frogDamage = damage_deal
	is_attacking = false
	frog_damage_zone = $frogDamageZone
	frog_damage_collision = $frogDamageCollision
	Global.frogDamageZone = frog_damage_zone
	
	#getting access of states in state_machine
	for state in state_machine.get_children():
		state.STATE = state_machine
		state.Frog = self
		#states.player = Global.playerBody
	previous_state = state_machine.IDLE
	current_state = state_machine.IDLE
	
func _process(delta: float) -> void:
	gravity(delta)    
	change_state(current_state.update(delta))
	$current_state.text = str(current_state.get_name())
	move_and_slide()
	


func gravity(delta):
	if !is_on_floor():
		velocity.y += gravity_value * delta

func change_state(input_state):
	if input_state != null:
		previous_state.exit()
		current_state.enter


func move(delta):
	if !dead :
		is_roaming = true
		if !is_chasing:
			velocity += speed * delta * dir
		elif is_attacking:
			velocity.x = 0
		elif is_chasing and !is_taking_damage:
			var chase_dir = position.direction_to(player.position) * speed
			velocity.x = chase_dir.x
			dir = abs(velocity)/velocity
		elif is_taking_damage:
			var knockback = position.direction_to(player.position) * -60
			velocity.x = knockback.x
		move_and_slide()
	elif dead:
		velocity.x = 0



func handle_animation():
	if !dead and !is_roaming and !is_attacking and !is_taking_damage:
		print("now playing ideal frog")
		animatedsprite.play("ideal")
		velocity.x = 0
	elif !dead and !is_taking_damage and !is_attacking:
		animatedsprite.play("run")
		if dir.x == 1:
			animatedsprite.flip_h = false
			frog_damage_collision.scale.x = 1
		elif dir.x == -1:
			animatedsprite.flip_h = true
			frog_damage_collision.scale.x = -1
	elif !dead and is_taking_damage:
		print("now playing damage frog")
		animatedsprite.play("hurt")
		await get_tree().create_timer(0.4).timeout
		is_taking_damage = false
	elif !dead and is_attacking:
		velocity.x = 0
		velocity.y = 0 
		animatedsprite.play("attack")
		await get_tree().create_timer(1.0).timeout
		is_attacking = false
		toggle_damage_zone(0.2)
	elif dead and is_roaming:
		print("now playing dead frog")
		is_roaming = false
		animatedsprite.play('death')
		await get_tree().create_timer(2).timeout
		handle_death()

func handle_death():
	Global.current_score += points_for_kill
	self.queue_free()

func toggle_damage_zone(wait_time):
	var damage_zone = frog_damage_collision.get_node("frogDamageCollision")
	damage_zone.disabled = false
	await get_tree().create_timer(wait_time).timeout
	damage_zone.disabled = true

func chose(array):
	array.shuffle()
	return array.front()

func _on_timer_timeout() -> void:
	$Timer.wait_time = chose([1,1.5,2])
	dir = chose([Vector2.RIGHT,Vector2.LEFT])
	velocity.x = 0

func _on_frog_hit_box_area_entered(area: Area2D) -> void:
	if area == Global.playerDamageZone:
		damage = Global.playerDamageDone
		
		if allowed_to_take_damage:
			take_damage(damage)

func take_damage(dmg):
	if !dead :
		health -= dmg
		is_taking_damage = true
		print("current health frog :",health)
		if health <= 0:
			health = 0
			dead = true
		damage_cooldown()

func damage_cooldown():
	allowed_to_take_damage = false
	await get_tree().create_timer(0.5).timeout
	allowed_to_take_damage = true
	is_taking_damage = false

func _on_frog_damage_zone_area_entered(area: Area2D) -> void:
	if area == Global.playerHitZone:
		is_attacking = true
		velocity.x = 0


func _on_frog_damage_zone_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

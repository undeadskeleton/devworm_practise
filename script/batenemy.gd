extends CharacterBody2D

class_name batEnemy

@onready var animated_sprite = $AnimatedSprite2D

var  speed = 20
var is_bat_chase : bool
var dir:Vector2

var player : CharacterBody2D

var health = 60
var max_health = 60
var min_health = 0

var dead = false

var is_roaming : bool
var is_talking_damage = false 
var damage_to_deal : int = 20

var points_for_kill : int = 100

func _ready():
	Global.batAlive = true

func _process(delta):
	if Global.playerAlive:
		is_bat_chase = true
	elif !Global.playerAlive:
		is_bat_chase = false
		
	if is_on_floor() and dead:
		await get_tree().create_timer(2.0).timeout
		Global.current_score += points_for_kill
		self.queue_free()
		
		
	Global.batDamage = damage_to_deal
	move(delta)
	handle_animation()

func move(delta):
	player = Global.playerBody
	if !dead:
		is_roaming = true
		if is_bat_chase and Global.playerAlive:
			if !is_talking_damage:
				velocity = position.direction_to(player.position) * speed
				dir.x = abs(velocity.x)/velocity.x
			elif is_talking_damage:
				velocity = position.direction_to(player.position) * -50
		elif !is_bat_chase:
			velocity += dir * speed * delta
	elif dead:
		velocity.y += delta * 20
		velocity.x = 0
	move_and_slide()


func handle_animation():
	if !dead and !is_talking_damage:
		animated_sprite.play("fly")
		if dir.x == 1:
			animated_sprite.flip_h = false
		elif dir.x == -1:
			animated_sprite.flip_h = true
	elif !dead and is_talking_damage:
		animated_sprite.play("hurt")
		await get_tree().create_timer(0.8).timeout
		is_talking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		animated_sprite.play("dead")
		set_collision_layer_value(1,true)
		set_collision_layer_value(2,false)
		set_collision_mask_value(1,true)
		set_collision_mask_value(2,false)

func _on_timer_timeout():
	$Timer.wait_time = chose([1.0,0.5,0.2])
	if !is_bat_chase:
		dir = chose([Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT])
		
func chose(array):
	array.shuffle()
	return array.front()

func _on_area_2d_area_entered(area):
	if area == Global.playerDamageZone:
		var damage = Global.playerDamageDone
		take_damage(damage)

func take_damage(damage):
	health -= damage
	is_talking_damage = true
	if health <=0:
		health = 0
		Global.batAlive = false
		dead = true
	

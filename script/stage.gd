extends Node2D

@onready var player_camera = $player/Camera2D
@onready var sceneTransitionAnim = $SceneTransitionAnimation/AnimationPlayer

var current_wave : int 

@export var bat_scene : PackedScene
@export var frog_scene : PackedScene

var current_node : int 
var starting_node : int 
var wave_spawn_ended
# Called when the node enters the scene tree for the first time.
func _ready():
	sceneTransitionAnim.get_parent().get_node("ColorRect").color.a = 255
	sceneTransitionAnim.play("fade_out")
	player_camera.enabled = true
	Global.playerWeaponEquip = true
	current_wave = 0
	starting_node = get_child_count()
	current_node = get_child_count()
	proceed_to_next_wave()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.

func proceed_to_next_wave():
	if current_node == starting_node:
		current_wave += 1
		Global.current_wave = current_wave
		wave_spawn_ended = false
		sceneTransitionAnim.play("in_between")
		await get_tree().create_timer(1).timeout
		prepare_spawn("bat",4.0,4.0)
		prepare_spawn("frog",2.0,2.0)


func prepare_spawn(type,multiplier,mob_spawn):
	var mob_amount = float(current_wave) * multiplier
	print(type," mob amount :",mob_amount)
	var mob_wait_time = 4.0
	var mob_spawn_round = mob_amount/mob_spawn
	print(type," mob spawn round :",mob_spawn_round)
	spawn_type(type,mob_wait_time,mob_spawn_round)


func spawn_type(type,mob_wait_time,mob_spawn_round):
	if type == "bat":
		var batspawn1 = $batspawnpoint
		var batspawn2 = $batspawnpoint2
		var batspawn3 = $batspawnpoint3
		var batspawn4 = $batspawnpoint4
		if mob_spawn_round >= 1:
			for i in mob_spawn_round:
				var bat1 = bat_scene.instantiate()
				bat1.global_position = batspawn1.global_position
				var bat2 = bat_scene.instantiate()
				bat2.global_position = batspawn2.global_position
				var bat3 = bat_scene.instantiate()
				bat3.global_position = batspawn3.global_position
				var bat4 = bat_scene.instantiate()
				bat4.global_position = batspawn4.global_position
				add_child(bat1)
				add_child(bat2)
				add_child(bat3)
				add_child(bat4)
				mob_spawn_round -=1
				await get_tree().create_timer(3.5).timeout
	elif type == "frog":
		var frogspawnpoint1 = $frogspawnpoint
		var frogspawnpoint2 = $frogspawnpoint2
		if mob_spawn_round >=1:
			for i in mob_spawn_round:
				print("frog :",i)
				
				var frog1 = frog_scene.instantiate()
				frog1.global_position = frogspawnpoint1.global_position
				var frog2 = frog_scene.instantiate()
				frog2.global_position = frogspawnpoint2.global_position
				add_child(frog1)
				add_child(frog2)
				mob_spawn_round -=1
				await get_tree().create_timer(4.5).timeout
	wave_spawn_ended = true

func update_score():
	Global.previous_score = Global.current_score
	if Global.current_score > Global.high_score:
		Global.high_score = Global.current_score
	Global.current_score = 0

func _process(delta):
	if !Global.playerAlive:
		sceneTransitionAnim.play("fade_in")
		await get_tree().create_timer(1).timeout
		update_score()
		get_tree().change_scene_to_file("res://scene/lobby.tscn")
	current_node = get_child_count()
	if wave_spawn_ended:
		proceed_to_next_wave()

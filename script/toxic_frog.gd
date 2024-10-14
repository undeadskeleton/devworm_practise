extends CharacterBody2D

class_name FrogEnemy

@onready var animatedsprite = $AnimatedSprite2D

var current_state = null
var previous_state = null

@export var initial_state : FrogState

@onready var state_machine = $State_Machine
#movement
var is_chasing : bool 
var dir : Vector2
var speed : int 
#gravity
var gravity_value : int = 800
func _ready() -> void:
	is_chasing = false
	for states in state_machine.get_children():
		states.STATE = state_machine
		states.FROG = self
	current_state = state_machine.IDLE
	previous_state = state_machine.IDLE
	print("enter _ready ")

func _process(delta: float) -> void:
	change_state(current_state.update(delta))
	$current_state.text = str(current_state.get_name())
	move_and_slide()
	if not is_on_floor():
		velocity.y += gravity_value * delta
		
func change_state(input_state):
	if input_state != null:
		previous_state = current_state
		current_state = input_state
		
		previous_state.exit()
		current_state.enter()
	

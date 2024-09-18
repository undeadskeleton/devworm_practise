extends State

@export var fall_state: State
@export var jump_state: State
@export var run_state: State

func enter() -> void:
	super()
	parent.velocity.x = 0
	
func process_input(event: InputEvent)-> State:
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		return run_state
	return null

func process_physics(delta:float)-> State:
	parent.velocity.y += gravity*delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null

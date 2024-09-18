extends Node2D

@onready var player_camera= $player/Camera2D
@onready var sceneTransitionAnim = $SceneTransitionAnimation/AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	sceneTransitionAnim.get_parent().get_node("ColorRect").color.a = 255
	sceneTransitionAnim.play("fade_out")
	player_camera.enabled = false
	Global.playerWeaponEquip = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_enter_combact_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		sceneTransitionAnim.play("fade_in")
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://scene/stage.tscn")

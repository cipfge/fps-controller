class_name JumpingState

extends State

@export var Player: CharacterBody3D
@export var PlayerAnimations: AnimationPlayer

var double_jump: bool = false

func enter() -> void:
	PlayerAnimations.pause()

func exit() -> void:
	PlayerAnimations.speed_scale = 1.0

func update(_delta) -> void:
	if Player.is_on_floor():
		double_jump = false
		transition.emit("WalkingState")
	if Input.is_action_just_pressed("jump") and not double_jump:
		Player.velocity.y += Player.JumpVelocity
		double_jump = true

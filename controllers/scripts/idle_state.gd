class_name IdleState extends State

@export var Player: CharacterBody3D
@export var PlayerAnimations: AnimationPlayer

func enter() -> void:
	PlayerAnimations.pause()

func exit() -> void:
	PlayerAnimations.speed_scale = 1.0

func update(_delta) -> void:
	if Player.is_on_floor() == false:
		transition.emit("JumpingState")
	if Input.is_action_pressed("crouch") and Player.is_on_floor():
		transition.emit("CrouchingState")
	if Player.velocity.length() > 0.0 and Player.is_on_floor():
		transition.emit("WalkingState")

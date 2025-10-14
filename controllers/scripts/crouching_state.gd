class_name CrouchingState extends State

@export var Player: CharacterBody3D
@export var PlayerAnimations: AnimationPlayer
@export var AnimationSpeed: float = 5.0
@export var CrouchShapeCast: ShapeCast3D

func enter() -> void:
	PlayerAnimations.play("crouch", -1, AnimationSpeed, false)
	Player.speed = Player.CrouchingSpeed

func exit() -> void:
	PlayerAnimations.speed_scale = 1.0

func update(_delta) -> void:
	if Input.is_action_just_released("crouch"):
		uncrouch()

func uncrouch() -> void:
	if CrouchShapeCast.is_colliding() == false and Input.is_action_pressed("crouch") == false:
		PlayerAnimations.play("crouch", -1, -AnimationSpeed, true)
		if PlayerAnimations.is_playing():
			await PlayerAnimations.animation_finished
		transition.emit("IdleState")
	elif CrouchShapeCast.is_colliding():
		await get_tree().create_timer(0.1).timeout
		uncrouch()

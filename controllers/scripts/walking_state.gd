class_name WalkingState extends State

@export var Player: CharacterBody3D
@export var PlayerAnimations: AnimationPlayer
@export var AnimationSpeed: float = 2.2

func enter() -> void:
	PlayerAnimations.play("walking", -1.0, 1.0)
	Player.speed = Player.WalkingSpeed
	
func exit() -> void:
	PlayerAnimations.speed_scale = 1.0

func update(_delta) -> void:
	set_animation_speed(Player.velocity.length())
	if Player.velocity.length() == 0.0 and Player.is_on_floor():
		transition.emit("IdleState")

func set_animation_speed(speed: float) -> void:
	var alpha = remap(speed, 0.0, Player.WalkingSpeed, 0.0, 1.0)
	PlayerAnimations.speed_scale = lerp(0.0, AnimationSpeed, alpha)

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("crouch") and Player.is_on_floor():
		transition.emit("CrouchingState")

	if event.is_action_pressed("sprint") and Player.is_on_floor():
		transition.emit("SprintingState")

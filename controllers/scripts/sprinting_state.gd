class_name SprintingState extends State

@export var Player: CharacterBody3D
@export var PlayerAnimations: AnimationPlayer
@export var AnimationSpeed: float = 2.2

func enter() -> void:
	PlayerAnimations.play("sprinting", 0.5, 1.0)
	Player.speed = Player.SprintingSpeed

func exit() -> void:
	PlayerAnimations.speed_scale = 1.0

func update(_delta) -> void:
	set_animation_speed(Player.velocity.length())

func set_animation_speed(speed: float) -> void:
	var alpha = remap(speed, 0.0, Player.SprintingSpeed, 0.0, 1.0)
	PlayerAnimations.speed_scale = lerp(0.0, AnimationSpeed, alpha)

func _input(event: InputEvent) -> void:
	if event.is_action_released("sprint") and Player.is_on_floor():
		transition.emit("WalkingState")

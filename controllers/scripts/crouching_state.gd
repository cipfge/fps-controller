class_name CrouchingState

extends State

@export var Player: CharacterBody3D
@export var PlayerAnimations: AnimationPlayer
@export var AnimationSpeed: float = 5.0

func enter() -> void:
    PlayerAnimations.play("crouch", -1, AnimationSpeed, false)
    Player.speed = Player.CrouchingSpeed
    
func exit() -> void:
    PlayerAnimations.play("crouch", -1, -AnimationSpeed, true)

func update(_delta) -> void:
    pass

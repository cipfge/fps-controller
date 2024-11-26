class_name IdleState

extends State

@export var Player: CharacterBody3D
@export var PlayerAnimations: AnimationPlayer

func enter() -> void:
    PlayerAnimations.pause()

func update(_delta) -> void:
    if Player.velocity.length() > 0.0 and Player.is_on_floor():
        transition.emit("WalkingState")

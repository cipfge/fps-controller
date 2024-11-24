extends CharacterBody3D

@export var WalkSpeed: float = 5.0
@export var CrouchSpeed: float = 3.0
@export var SprintSpeed: float = 9.0
@export var LerpSpeed: float = 10.0
@export var JumpVelocity: float = 5.0
@export var MouseSensitivity: float = 0.3

# Camera Up/Down limits
const TiltLowerLimit: float = deg_to_rad(-90.0)
const TiltUpperLimit: float = deg_to_rad(90.0)

@onready var camera_controller: Node3D = $CameraController as Node3D

var input_rotation := Vector2.ZERO
var controller_rotation := Vector2.ZERO
var move_direction := Vector3.ZERO

func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("exit_game"):
        get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        input_rotation = Vector2(-event.relative.y * MouseSensitivity, -event.relative.x * MouseSensitivity)

func update_rotation(delta) -> void:
    controller_rotation.x += input_rotation.x * delta
    controller_rotation.x = clamp(controller_rotation.x, TiltLowerLimit, TiltUpperLimit)
    controller_rotation.y += input_rotation.y * delta
    
    var player_rotation: Vector3 = Vector3(0.0, controller_rotation.y, 0.0)
    var camera_rotation: Vector3 = Vector3(controller_rotation.x, 0.0, 0.0)

    camera_controller.transform.basis = Basis.from_euler(camera_rotation)
    camera_controller.rotation.z = 0.0
    global_transform.basis = Basis.from_euler(player_rotation)

    input_rotation = Vector2(0.0, 0.0)

func _physics_process(delta: float) -> void:
    update_rotation(delta)

    if not is_on_floor():
        velocity += get_gravity() * delta

    if Input.is_action_just_pressed("jump") and is_on_floor():
       velocity.y = JumpVelocity
    
    var speed := WalkSpeed
    if Input.is_action_pressed("crouch"):
        speed = CrouchSpeed
    elif Input.is_action_pressed("sprint"):
        speed = SprintSpeed

    var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    move_direction = lerp(move_direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * LerpSpeed)

    if move_direction:
        velocity.x = move_direction.x * speed
        velocity.z = move_direction.z * speed
    else:
        velocity.x = move_toward(velocity.x, 0, speed)
        velocity.z = move_toward(velocity.z, 0, speed)

    move_and_slide()

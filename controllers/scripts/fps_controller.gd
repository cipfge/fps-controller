extends CharacterBody3D

@export_category("Movement")
@export var WalkingSpeed: float = 4.5
@export var CrouchingSpeed: float = 2.5
@export var SprintingSpeed: float = 9.5
@export var Acceleration: float = 0.1
@export var Deceleration: float = 0.25
@export var JumpVelocity: float = 5.0

@export_category("Controller")
@export var MouseSensitivity: float = 0.3

# Camera Up/Down limits
const TiltLowerLimit: float = deg_to_rad(-90.0)
const TiltUpperLimit: float = deg_to_rad(90.0)

@onready var camera_controller: Node3D = $CameraController as Node3D
@onready var crouch_shape_cast: ShapeCast3D = $CrouchShapeCast as ShapeCast3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer

var input_rotation := Vector2.ZERO
var controller_rotation := Vector2.ZERO
var move_direction := Vector3.ZERO
var speed: float = WalkingSpeed
var crouching: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	crouch_shape_cast.add_exception($".")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_game"):
		get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		input_rotation = Vector2(-event.relative.y * MouseSensitivity, -event.relative.x * MouseSensitivity)

func _physics_process(delta: float) -> void:
	update_rotation(delta)

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JumpVelocity

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	move_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if move_direction:
		velocity.x = lerp(velocity.x, move_direction.x * speed, Acceleration)
		velocity.z = lerp(velocity.z, move_direction.z * speed, Acceleration)
	else:
		var old_velocity = Vector2(velocity.x, velocity.z)
		var tmp = move_toward(Vector2(velocity.x, velocity.z).length(), 0.0, Deceleration)
		velocity.x = old_velocity.normalized().x * tmp
		velocity.z = old_velocity.normalized().y * tmp
		
	Global.DebugPanel.add_debug_info("Speed", speed)
	move_and_slide()

func update_rotation(delta) -> void:
	controller_rotation.x += input_rotation.x * delta
	controller_rotation.x = clamp(controller_rotation.x, TiltLowerLimit, TiltUpperLimit)
	controller_rotation.y += input_rotation.y * delta
	
	var player_rotation: Vector3 = Vector3(0.0, controller_rotation.y, 0.0)
	var camera_rotation: Vector3 = Vector3(controller_rotation.x, 0.0, 0.0)

	camera_controller.transform.basis = Basis.from_euler(camera_rotation)
	camera_controller.rotation.z = 0.0
	global_transform.basis = Basis.from_euler(player_rotation)

	input_rotation = Vector2.ZERO

extends CenterContainer

@export var DotRadius: float = 1.0
@export var DotColor: Color = Color.WHITE
@export var CrosshairSpeed: float = 0.25
@export var CrosshairDistance: float = 2.0

@export var fps_controller: CharacterBody3D

@onready var crosshair_top_line: Line2D = $TopLine as Line2D
@onready var crosshair_right_line: Line2D = $RightLine as Line2D
@onready var crosshair_left_line: Line2D = $LeftLine as Line2D
@onready var crosshair_bottom_line: Line2D = $BottomLine as Line2D

func _process(_delta: float) -> void:
    update_crosshair_lines()

func _draw() -> void:
    draw_circle(Vector2.ZERO, DotRadius, DotColor)

func update_crosshair_lines():
    # Get player velocity and calculate movement speed by calculating the distance from origin point to velocity
    var velocity = fps_controller.get_real_velocity()
    var origin = Vector3.ZERO
    var speed = origin.distance_to(velocity)

    # Update crosshair lines position
    crosshair_top_line.position = lerp(crosshair_top_line.position, Vector2(0, -speed * CrosshairDistance), CrosshairSpeed)
    crosshair_right_line.position = lerp(crosshair_right_line.position, Vector2(speed * CrosshairDistance, 0), CrosshairSpeed)
    crosshair_left_line.position = lerp(crosshair_left_line.position, Vector2(-speed * CrosshairDistance, 0), CrosshairSpeed)
    crosshair_bottom_line.position = lerp(crosshair_bottom_line.position, Vector2(0, speed * CrosshairDistance), CrosshairSpeed)

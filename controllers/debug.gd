extends PanelContainer

@onready var debug_container: VBoxContainer = $MarginContainer/VBoxContainer

var fps_label: Label

func _ready() -> void:
    visible = false
    add_debug_info("FPS")

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("show_debug"):
        visible = !visible

func _process(delta: float) -> void:
    if visible == true:
        var fps_value = "%.2f" % (1.0/delta) # Engine.get_frames_per_second()
        fps_label.text = fps_label.name + ": " + fps_value

func add_debug_info(title: String) -> void:
    fps_label = Label.new()
    debug_container.add_child(fps_label)
    fps_label.name = title

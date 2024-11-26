extends PanelContainer

@onready var debug_container: VBoxContainer = $MarginContainer/VBoxContainer

func _ready() -> void:
    Global.DebugPanel = self
    visible = false

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("show_debug"):
        visible = !visible

func _process(delta: float) -> void:
    if visible == true:
        var fps_value = "%.2f" % (1.0/delta) # Engine.get_frames_per_second()
        add_debug_info("FPS", fps_value)

func add_debug_info(title: String, value) -> void:
    var info_label = debug_container.find_child(title, true, false)
    if !info_label:
        info_label = Label.new()
        debug_container.add_child(info_label)
        info_label.name = title
        info_label.text = info_label.name + ": " + str(value)
    elif visible:
        info_label.text = info_label.name + ": " + str(value)

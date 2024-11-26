class_name StateMachine

extends Node

@export var CurrentState: State

var states: Dictionary = {}

func _ready() -> void:
    # Add all child states to states disctionary
    for child in get_children():
        if child is State:
            states[child.name] = child
            child.transition.connect(on_child_transition)
        else:
            push_warning("State %s is an incompatible child node" % child.name)

    # Enter current state
    CurrentState.enter()

func _process(delta: float) -> void:
    Global.DebugPanel.add_debug_info("Player state", CurrentState.name)
    CurrentState.update(delta)

func _physics_process(delta: float) -> void:
    CurrentState.physics_update(delta)

func on_child_transition(new_state_name: StringName) -> void:
    var new_state = states.get(new_state_name)
    if new_state != null and new_state != CurrentState:
        CurrentState.exit()
        CurrentState = new_state;
        CurrentState.enter()
    else:
        push_warning("State %s is does not exist in the state list" % new_state_name)

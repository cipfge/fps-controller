class_name StateMachine extends Node

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
	CurrentState.enter()

func _process(delta: float) -> void:
	Global.DebugPanel.add_debug_info("Player state", CurrentState.name)
	CurrentState.update(delta)

func _physics_process(delta: float) -> void:
	CurrentState.physics_update(delta)

func on_child_transition(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)
	if new_state == null:
		push_warning("State %s does not exist in the state list" % new_state_name)
		return

	if  new_state != CurrentState:
		print("Transition: %s -> %s" % [CurrentState.name, new_state.name])
		CurrentState.exit()
		CurrentState = new_state;
		CurrentState.enter()

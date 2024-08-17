extends Node

@export var initial_state := "RED"

var current_state = null

func _ready():
	set_initial_state()

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
		check_state_transitions()

func set_initial_state():
	current_state = get_node_or_null(initial_state)
	if current_state:
		current_state.on_enter()
	else:
		push_error("Initial state not found: " + initial_state)

func check_state_transitions():
	for state in get_children():
		if state != current_state:
			if state.enter_condition():
				if current_state.exit_condition():
					current_state.on_exit()
					current_state = state
					current_state.on_enter()
					break

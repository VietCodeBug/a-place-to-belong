extends StoryInteractable

var action: Callable

func set_available(enabled: bool) -> void:
	if enabled and not is_in_group("interactables"):
		add_to_group("interactables")
	elif not enabled and is_in_group("interactables"):
		remove_from_group("interactables")

func interact() -> void:
	if is_in_group("interactables") and action.is_valid():
		action.call()

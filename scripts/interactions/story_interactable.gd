class_name StoryInteractable
extends Node3D
## Lightweight contextual interactable node using the canonical 'interactables' group contract.

signal activated(title: String, message: String)

@export var interaction_name := "Inspect"
@export var interaction_radius := 2.0
@export var category := "WOODLAND NOTE"
@export var title := "Forest Post Café"
@export_multiline var message := ""

func _ready() -> void:
	add_to_group("interactables")

func interact() -> void:
	activated.emit(title, message)

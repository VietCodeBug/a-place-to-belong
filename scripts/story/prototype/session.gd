extends RefCounted
## Keeps runtime facts keyed by authored identifiers, across both physics worlds.

var flags: Dictionary = {}
var residents: Dictionary = {}
var objects: Dictionary = {}
var activities: Dictionary = {}

func memory(id: String) -> Dictionary:
	if not residents.has(id):
		residents[id] = {"met":false,"heard":{},"next_line":{},"visits":0,"return_visit":false,"activity_done":false}
	return residents[id]

func flag(id: String) -> void:
	flags[id] = true

func object_state(id: String, value: String) -> void:
	objects[id] = value

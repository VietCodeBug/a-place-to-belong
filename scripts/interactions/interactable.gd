extends Node3D
signal activated(title: String, message: String)
@export var interaction_name := "Read mailbox"
@export var interaction_radius := 2.3
@export var title := "Welcome to Forest Post Café!"
@export_multiline var message := "This is where your delivery journey begins."

func _ready() -> void:
	ForestShapes.box(self, Vector3(0,0.65,0), Vector3(0.18,1.3,0.18), "B88254", true)
	ForestShapes.box(self, Vector3(0,1.4,0), Vector3(0.85,0.65,0.65), "B88254", true)
	ForestShapes.box(self, Vector3(0,1.45,0.335), Vector3(0.62,0.06,0.02), "343C38")
	ForestShapes.box(self, Vector3(0,1.77,0), Vector3(1,0.12,0.8), "496B59")
	ForestShapes.box(self, Vector3(0.49,1.65,0), Vector3(0.08,0.35,0.28), "C85E55")

func interact() -> void:
	activated.emit(title, message)

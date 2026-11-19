class_name ForestReviewCameras
extends RefCounted
const PRESETS := {
	"lodge": {"eye":Vector3(17,10,21),"focus":Vector3(-0.5,3.3,-2),"fov":40.0},
	"detail": {"eye":Vector3(8,5.4,11),"focus":Vector3(-0.7,2.4,0.2),"fov":40.0},
	"forest": {"eye":Vector3(15,8,19),"focus":Vector3(-9,4,1),"fov":48.0},
	"wide": {"eye":Vector3(26,20,29),"focus":Vector3(-1,2,1),"fov":44.0},
}
static func apply(camera: Camera3D, preset: String) -> void:
	var p: Dictionary = PRESETS[preset]
	camera.set_process(false)
	camera.position = p.eye
	camera.fov = p.fov
	camera.look_at(p.focus)

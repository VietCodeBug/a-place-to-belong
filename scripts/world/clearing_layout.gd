class_name ClearingLayout
extends RefCounted
## Shared sightline and path data keeps road/verges/vegetation in agreement.
static func path_center(z: float) -> float:
	var t := clampf((z-2.4)/21.6,0.0,1.0)
	return sin(t*PI*1.5)*2.6-t*3.0

static func path_half_width(z: float) -> float:
	return lerpf(0.95,2.7,clampf((z-2.4)/21.6,0.0,1.0))

static func on_path(p: Vector3, margin := 0.0) -> bool:
	return p.z >= 2.0 and absf(p.x-path_center(p.z)) < path_half_width(p.z)+margin

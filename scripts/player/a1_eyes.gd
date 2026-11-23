extends RefCounted
## One look state shared by the exterior and interior camera.

const AVATAR_LAYER := 1 << 18
const EYE_HEIGHT := 1.55
const RANGE := 2.85
var yaw := PI * .5
var pitch := 0.0
var sensitivity := 1.0
var head_bob := true
var fov := 68.0
var stride := 0.0
var bob := 0.0

func turn(pixels: Vector2) -> void:
	yaw = wrapf(yaw-pixels.x*.0022*sensitivity,-PI,PI)
	pitch = clampf(pitch-pixels.y*.0022*sensitivity,-1.52,1.52)

func aim(direction: Vector3) -> void:
	var d := direction.normalized()
	if d.length_squared()>.5:
		yaw = atan2(-d.x,-d.z)
		pitch = asin(clampf(d.y,-.998,.998))

func place(camera: Camera3D, player: CharacterBody3D, delta: float, instant := false) -> void:
	var speed := Vector2(player.velocity.x,player.velocity.z).length()
	var moving: bool = head_bob and player.is_on_floor() and speed>.2 and not player.blocked
	stride += delta*speed*3.2
	bob = lerpf(bob,sin(stride)*.016 if moving else 0.0,1.0-exp(-17.0*delta))
	var height := .98 if player.state=="swimming" else EYE_HEIGHT
	var eye := player.global_position+Vector3.UP*(height+bob)
	# Follow steps immediately. The short vertical filter is only for crossing the waterline.
	if player.state=="swimming" and not instant and absf(camera.global_position.y-eye.y)<.60:
		eye.y = lerpf(camera.global_position.y,eye.y,1.0-exp(-20.0*delta))
	camera.global_position = eye
	camera.global_rotation = Vector3(pitch,yaw,0)
	camera.near = .045
	camera.fov = fov
	camera.cull_mask &= ~AVATAR_LAYER

func select(camera: Camera3D, player: CharacterBody3D) -> Node3D:
	var origin := camera.global_position
	var direction := -camera.global_basis.z
	var query := PhysicsRayQueryParameters3D.create(origin,origin+direction*RANGE,1,[player.get_rid()])
	var wall := player.get_world_3d().direct_space_state.intersect_ray(query)
	var max_depth := RANGE if wall.is_empty() else origin.distance_to(wall.position)+.24
	var best_score := INF
	var best: Node3D
	for item in player.get_tree().get_nodes_in_group("interactables"):
		if item.get_viewport()!=player.get_viewport():
			continue
		var reach := minf(RANGE,maxf(item.interaction_radius,1.15)+.42)
		var focus: Vector3 = item.get_meta("focus_at",Vector3.UP*.95)
		var radius: float = item.get_meta("focus_radius",.30)
		var displacement: Vector3 = item.to_global(focus)-origin
		var depth := displacement.dot(direction)
		if depth<.05 or depth>reach or depth>max_depth:
			continue
		var miss := (displacement-direction*depth).length()
		var score := miss/radius+depth*.07
		if miss<=radius and score<best_score:
			best = item
			best_score = score
	return best

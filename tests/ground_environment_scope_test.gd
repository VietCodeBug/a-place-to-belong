extends SceneTree
var failures:=0
func _initialize() -> void: call_deferred("run")
func check(ok: bool,label: String) -> void:
	print("PASS: " if ok else "FAIL: ",label)
	if not ok: failures+=1
func run() -> void:
	var hub=load("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	await process_frame
	var cover: Node3D=hub.get_node("CuratedGroundCover")
	check(physics_count(cover)==0,"new floor decorations add no physics bodies")
	var count:=0
	for value in cover.instance_counts.values(): count+=value
	check(count>5000 and count<25000,"floor population stays inside the declared instance budget")
	for asset in ["short_blades","soft_fan","meadow_sweep","tall_sedge","fern_rosette","fallen_leaf","twig"]:
		check(cover.instance_counts.get(asset,0)>0,"floor includes "+asset)
	var multimeshes:=0
	for child in cover.get_children():
		if child is MultiMeshInstance3D: multimeshes+=1
	check(multimeshes>7 and multimeshes<250,"ground cover is spatially chunked into bounded MultiMeshes")
	check(hub.player.get_meta("character_id")=="samatha","current player remains Samatha")
	check(hub.mailbox.position.is_equal_approx(Vector3(3.6,.4,3.5)),"mailbox position remains exact")
	print("GROUND SCOPE COMPLETE; failures=",failures)
	quit(1 if failures else 0)
func physics_count(node: Node) -> int:
	var count:=1 if node is PhysicsBody3D else 0
	for child in node.get_children(): count+=physics_count(child)
	return count

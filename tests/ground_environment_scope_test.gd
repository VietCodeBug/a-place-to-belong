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
	check(count>18000 and count<45000,"floor population stays inside the declared instance budget")
	for asset in ["grass_carpet","grass_main","grass_accent","flowers_white","flowers_purple","fern_rosette","fallen_leaf","twig"]:
		check(cover.instance_counts.get(asset,0)>0,"floor includes "+asset)
	var multimeshes:=batch_count(cover)
	check(multimeshes>30 and multimeshes<1000,"ground cover uses bounded chunked MultiMeshes")
	var details=cover.get_node("MeadowDetails")
	check(details.mushroom_count>0 and details.mushroom_count<=40,"small mushroom groups stay within budget")
	check(details.pebble_count>0 and details.pebble_count<=20,"small stone groups stay within budget")
	check(hub.player.get_meta("character_id")=="samatha","current player remains Samatha")
	check(hub.mailbox.position.is_equal_approx(Vector3(3.6,.4,3.5)),"mailbox position remains exact")
	print("GROUND SCOPE COMPLETE; failures=",failures)
	quit(1 if failures else 0)
func physics_count(node: Node) -> int:
	var count:=1 if node is PhysicsBody3D else 0
	for child in node.get_children(): count+=physics_count(child)
	return count

func batch_count(node: Node) -> int:
	var count:=1 if node is MultiMeshInstance3D else 0
	for child in node.get_children():count+=batch_count(child)
	return count

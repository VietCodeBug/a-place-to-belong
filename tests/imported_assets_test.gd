extends SceneTree
var failures := 0
func _initialize() -> void:
	call_deferred("run")
func check(ok: bool, description: String) -> void:
	if ok:
		print("PASS: ",description)
	else:
		push_error(description)
		failures += 1
func run() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("This integration test requires a rendering display for MultiMesh GPU readback; use smoke_test.gd for headless gameplay.")
		quit(1)
		return
	var imported := 0
	for pack in ["kenney","quaternius"]:
		var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/vendor/"+pack+"/manifest.json"))
		for file in manifest.files:
			if file.path.ends_with(".glb") and load("res://assets/vendor/"+pack+"/"+file.path) is PackedScene:
				imported += 1
	check(imported == 58,"all 58 admitted GLBs import as PackedScene")
	var hub = load("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	await process_frame
	var cafe: Node3D = hub.get_node("Cafe")
	var door := cafe.find_child("door",true,false) as MeshInstance3D
	check(door != null,"imported door mesh exists")
	if door != null:
		var box: AABB = door.global_transform*door.get_aabb()
		print("Measured door: ",box.size)
		check(box.size.y >= 2.1 and box.size.y <= 2.3,"door height is human-usable (2.1–2.3 m)")
	var roof: Node3D = cafe.get_node("MainHallRoof")
	var roof_box := FieldAssets.bounds(roof)
	check(absf(roof_box.end.y-7.0)<0.01,"main hall roof ridge reaches 7 m above the lodge datum")
	var porch: MeshInstance3D = cafe.get_node("PorchDeck")
	check(porch.mesh.size.x >= 15 and porch.mesh.size.z >= 4,"porch is at least 15 x 4 m")
	var player_box := FieldAssets.bounds(hub.player)
	check(player_box.size.y >= 1.6 and player_box.size.y <= 1.9,"player provides a roughly 1.8 m scale reference")
	for i in range(3):
		await process_frame
	await RenderingServer.frame_post_draw
	var tallest := 0.0
	for n in hub.get_node("LicensedWoodland").get_children():
		if n is MultiMeshInstance3D:
			for i in range(n.multimesh.instance_count):
				var instance_box: AABB = n.multimesh.get_instance_transform(i)*n.multimesh.mesh.get_aabb()
				var origin: Vector3 = n.multimesh.get_instance_transform(i).origin
				tallest = maxf(tallest,instance_box.end.y-ForestLandscape.height_at(origin.x,origin.z))
	print("Measured top above local ground: ",tallest)
	check(tallest >= 14 and tallest < 23,"forest has hero trees at least twice the roof height")
	print("ASSET INTEGRATION COMPLETE; failures=",failures)
	quit(1 if failures else 0)

extends SceneTree
## Run with godot --headless --path . --script res://tests/village_a_test.gd.
const PLAN = preload("res://scripts/world/village_a_layout.gd")
const BOTANY = preload("res://scripts/world/a1_botany.gd")
const LAND = preload("res://scripts/world/landscape.gd")
const MOVEMENT := ["move_left", "move_right", "move_up", "move_down"]
var failed := false

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, message: String) -> void:
	if not condition:
		push_error(message)
		failed = true

func walk(player: CharacterBody3D, target: Vector2) -> bool:
	for frame in range(420):
		var direction := target - Vector2(player.position.x, player.position.z)
		if direction.length() < .22:
			return true
		var input := direction.normalized().rotated(PI / 4.0)
		for action in MOVEMENT:
			Input.action_release(action)
		Input.action_press("move_left" if input.x < 0 else "move_right", absf(input.x))
		Input.action_press("move_up" if input.y < 0 else "move_down", absf(input.y))
		await physics_frame
	return false

func test_tree_lod(host: Node3D) -> void:
	var tree := BOTANY.place_tree(host,"MapleTree_2",Vector3.ZERO,8.1,.44)
	var cohort: Array[Node3D] = [tree]
	var detail := tree.get_node("Near") as Node3D
	var far := tree.get_node("Far") as Node3D
	var meshes := detail.find_children("*","MeshInstance3D",true,false)
	check(meshes.size() == 2, "Species must have separate seasonal bark and foliage.")
	var canopy := detail.find_child("MapleTree_Leaves",true,false) as MeshInstance3D
	check(canopy != null, "Seasonal foliage was not separated at import.")
	BOTANY.update_lod(cohort,Vector3(0,2,40))
	check(detail.visible and not far.visible,"Near detail should be exclusive.")
	BOTANY.update_lod(cohort,Vector3(0,2,90))
	check(not detail.visible and far.visible,"Old model should appear at distance.")
	BOTANY.update_lod(cohort,Vector3(0,2,73))
	check(far.visible,"LOD should not flip inside the hysteresis band.")
	BOTANY.update_lod(cohort,Vector3(0,2,60))
	check(detail.visible and not far.visible,"Near detail should reappear after returning.")
	BOTANY.season_tree(tree,3)
	BOTANY.update_lod(cohort,Vector3(0,2,90))
	check(detail.visible and not far.visible and canopy != null and not canopy.visible,
		"Deciduous trees should keep the original bare branches at distance in winter.")
	tree.queue_free()

func run() -> void:
	var hub := preload("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	var valley := hub.get_node("A1RiverValley")
	var village := valley.get_node("VillageA")
	var planting := valley.get_node("SeasonalPlanting")
	var meadow := hub.get_node("CuratedGroundCover/DenseMeadow") as Node3D
	test_tree_lod(hub)
	var player: CharacterBody3D = hub.player
	var families := {}
	for lot in PLAN.BUILDINGS:
		families[lot[1]] = true
		var structure := village.get_node_or_null(NodePath(lot[0]))
		check(structure != null and structure.find_children("*", "CollisionShape3D", true, false).size() == 1,
			"Exterior shell collision is missing for %s." % lot[0])
	check(PLAN.BUILDINGS.size() == 21 and families.size() == 13, "Review layout should have 21 buildings in thirteen families.")
	check(village.get_node("A06").get_meta("landmark","") == "chapel","The central plaza needs the chapel landmark.")
	check(ForestFloorDesign.reserved(Vector2(6.9,14.9)),"House A path must exclude meadow clumps.")
	for spot: Vector4 in LAND.POTHOLES:
		var left := LAND.height_at(spot.x-2.0,spot.y)
		var right := LAND.height_at(spot.x+2.0,spot.y)
		check(LAND.height_at(spot.x,spot.y) < (left+right)*.5-.045,"Road hollow must depress the collision surface.")

	check(hub.has_node("ForestHouseA") and PLAN.HOUSE_A.distance_to(PLAN.COMMON) > 200.0, "House A should precede the village.")
	for season in range(4):
		valley.set_season_palette(season)
		check(meadow.visible == (season != 3), "The original meadow must follow winter visibility.")
		for i in range(4):
			check(village.seasonal[i].visible == (i == season), "Exactly one seasonal group should be visible.")
			check(planting.seasons[i].visible == (i == season),"Exactly one planting season should be visible.")
	check(planting.has_node("Summer/VegetableBeds/Tomato_4"),"Summer tomato row did not import.")
	check(planting.has_node("Autumn/VegetableBeds/Pumpkin_4"),"Autumn pumpkin vines did not import.")
	check(not planting.has_node("Winter/VegetableBeds/Tomato_4"),"Winter beds must exclude summer crops.")
	valley.set_season_palette(0)

	var walk_start: Vector2 = PLAN.HOUSE_APPROACH[0]
	player.position = hub.ground(walk_start.x, walk_start.y, .12)
	player.velocity = Vector3.ZERO
	for frame in range(8):
		await physics_frame
	for mound: Vector4 in LAND.RELIEF:
		var point := Vector2(mound.x,mound.y)
		var h := LAND.height_at(point.x,point.y)
		var query := PhysicsRayQueryParameters3D.create(Vector3(point.x,h+.22,point.y),
			Vector3(point.x,h-.22,point.y))
		var hit := player.get_world_3d().direct_space_state.intersect_ray(query)
		check(not hit.is_empty() and absf(hit.position.y-h)<.02, "Relief mesh/collision mismatch at %s." % point)
	var destinations: Array[Vector2] = []
	destinations.assign(PLAN.HOUSE_APPROACH.slice(1))
	destinations.append_array(PLAN.THOMAS_APPROACH.slice(1))
	var spur_return := PLAN.THOMAS_APPROACH.slice(0,-1)
	spur_return.reverse()
	destinations.append_array(spur_return)
	for z in range(19,25):
		destinations.append(Vector2(ClearingLayout.path_center(z), z))
	for z in range(25,181,4):
		destinations.append(Vector2(LAND.valley_path(z), z))
	destinations.append(Vector2(LAND.valley_path(180), 180))
	for destination in destinations:
		if not await walk(player, destination):
			check(false,"Main trail blocked near %s at %s." % [destination, player.position])
			break
		check(player.position.y > LAND.height_at(destination.x,destination.y)-.25 or destination.y in range(69,82),
			"Player below the terrain near %s." % destination)
	print("Main walk ended at ", player.position)
	destinations.reverse()
	destinations.append(walk_start)
	for destination in destinations.slice(1):
		if not await walk(player, destination):
			check(false,"Return to House A blocked near %s at %s." % [destination,player.position])
			break
	print("Return ended at ",player.position)
	for lane in PLAN.LANES:
		var start: Vector2 = lane[0]
		player.position = hub.ground(start.x,start.y,.12)
		player.velocity = Vector3.ZERO
		for frame in range(8):
			await physics_frame
		for destination in lane:
			if not await walk(player, destination):
				check(false,"Village lane blocked near %s at %s." % [destination, player.position])
				break
		print("Lane ended at ", player.position)
	for action in MOVEMENT:
		Input.action_release(action)
	quit(1 if failed else 0)

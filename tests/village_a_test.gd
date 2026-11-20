extends SceneTree
## Run with godot --headless --path . --script res://tests/village_a_test.gd.
const PLAN = preload("res://scripts/world/village_a_layout.gd")
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

func run() -> void:
	var hub := preload("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	var valley := hub.get_node("A1RiverValley")
	var village := valley.get_node("VillageA")
	var player: CharacterBody3D = hub.player
	var families := {}
	for lot in PLAN.BUILDINGS:
		families[lot[1]] = true
		var structure := village.get_node_or_null(NodePath(lot[0]))
		check(structure != null and structure.find_children("*", "CollisionShape3D", true, false).size() == 1,
			"Exterior shell collision is missing for %s." % lot[0])
	check(PLAN.BUILDINGS.size() == 11 and families.size() == 6, "Review layout should have 11 buildings in six families.")
	check(hub.has_node("ForestHouseA") and PLAN.HOUSE_A.distance_to(PLAN.COMMON) > 100.0, "House A should precede the village.")
	for season in range(4):
		valley.set_season_palette(season)
		for i in range(4):
			check(village.seasonal[i].visible == (i == season), "Exactly one seasonal group should be visible.")
	valley.set_season_palette(0)

	var walk_start: Vector2 = PLAN.HOUSE_APPROACH[0]
	player.position = hub.ground(walk_start.x, walk_start.y, .12)
	player.velocity = Vector3.ZERO
	for frame in range(8):
		await physics_frame
	var destinations: Array[Vector2] = []
	destinations.assign(PLAN.HOUSE_APPROACH.slice(1))
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

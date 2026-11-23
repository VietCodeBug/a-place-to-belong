extends Control

const L = preload("res://scripts/world/landscape.gd")
const MAPS = preload("res://scripts/story/map_flow.gd")
const VILLAGE = preload("res://scripts/world/village_a_layout.gd")
const MAP_CENTER_Z := (L.VALLEY_END + L.WOODLAND_START) * .5
const PLACES := [
	[VILLAGE.HOUSE_A, "House A", "Nhà A"],
	[Vector2(0, -3), "Forest clearing", "Khoảng rừng"],
	[VILLAGE.THOMAS, "Thomas", "Thomas"],
	[Vector2(-22.5, 50), "Valley overlook", "Điểm ngắm thung lũng"],
	[Vector2(0, 74), "River bridge", "Cầu qua sông"],
	[VILLAGE.COMMON, "Village A", "Làng A"],
	[VILLAGE.EXIT, "Forest path", "Đường ra rừng"],
]
const INK := Color("3e5145")
var player: Node3D
var visited: Dictionary = {}
var zoom := 1.0
var pan := Vector2.ZERO

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	hide()

func _process(_delta: float) -> void:
	var at := Vector2(player.position.x, player.position.z)
	for place in PLACES:
		if at.distance_to(place[0]) < 10.0:
			visited[place[0]] = true
	if visible:
		queue_redraw()

func point(at: Vector2) -> Vector2:
	return size * 0.5 + pan + Vector2(at.x, MAP_CENTER_Z - at.y) * map_scale()

func map_scale() -> float:
	return minf(size.x / 150.0, maxf(1.0, size.y - 142.0) / (L.VALLEY_END - L.WOODLAND_START)) * zoom

func center_on_player() -> void:
	pan = -Vector2(player.position.x, MAP_CENTER_Z - player.position.z) * map_scale()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and (event.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
		pan += event.relative
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN]:
			var old := zoom
			zoom = clampf(zoom + (0.18 if event.button_index == MOUSE_BUTTON_WHEEL_UP else -0.18), 0.65, 3.2)
			var from_center: Vector2 = event.position - size * 0.5
			pan = from_center + (pan - from_center) * (zoom / old)
		elif event.button_index == MOUSE_BUTTON_LEFT and Rect2(size.x - 191, 20, 164, 39).has_point(event.position):
			center_on_player()

func _draw() -> void:
	var paper := Color("e6d7ad")
	draw_rect(Rect2(Vector2.ZERO, size), paper)
	for z in range(L.WOODLAND_START, L.VALLEY_END, 4):
		var span := 24 if z < 24 else L.VALLEY_HALF_WIDTH
		for x in range(-span, span, 4):
			var elevation := L.height_at(x + 2.0, z + 2.0)
			var color := Color("b9bc8c").lerp(Color("899b77"), clampf(elevation / 15.0, 0, 1))
			draw_rect(Rect2(point(Vector2(x, z + 4)), Vector2.ONE * (4.0 * map_scale() + 0.5)), color)
	var river := PackedVector2Array()
	for x in range(-40, 41, 2):
		river.append(point(Vector2(x, L.river_center(x))))
	draw_polyline(river, Color("729d9c"), 8.0 * map_scale(), true)
	var trail := PackedVector2Array()
	for z in range(5, L.VALLEY_END, 2):
		trail.append(point(Vector2(L.valley_path(z) if z > 24 else ClearingLayout.path_center(z), z)))
	draw_polyline(trail, Color("f0d7a8"), 2.2 * map_scale(), true)
	draw_line(point(Vector2(0, 67)), point(Vector2(0, 81)), Color("795d45"), 3.5 * map_scale(), true)
	if visited.has(VILLAGE.HOUSE_A):
		var house_trail := PackedVector2Array()
		for waypoint in VILLAGE.HOUSE_APPROACH:
			house_trail.append(point(waypoint))
		draw_polyline(house_trail, Color("ead0a3"), 1.5 * map_scale(), true)
	if visited.has(VILLAGE.THOMAS):
		var forest_spur := PackedVector2Array()
		for waypoint in VILLAGE.THOMAS_APPROACH:
			forest_spur.append(point(waypoint))
		draw_polyline(forest_spur,Color("ead0a3"),1.3*map_scale(),true)
	if visited.has(VILLAGE.COMMON):
		for lane in VILLAGE.LANES:
			var mapped := PackedVector2Array()
			for waypoint in lane:
				mapped.append(point(waypoint))
			draw_polyline(mapped, Color("ead0a3"), 1.5 * map_scale(), true)
		for lot in VILLAGE.BUILDINGS:
			var center := point(Vector2(lot[2], lot[3]))
			var extent := Vector2(4.6, 3.8) * map_scale()
			draw_rect(Rect2(center - extent*.5, extent), Color("88694f"))
	var font := get_theme_default_font()
	for place in PLACES:
		var at := point(place[0])
		var known := visited.has(place[0])
		draw_circle(at, 5.0, INK if known else Color("8f9374"))
		if known:
			draw_string(font, at + Vector2(10, 5), MAPS.text(place[1], place[2]), HORIZONTAL_ALIGNMENT_LEFT, -1, 15, INK)
	var self_at := point(Vector2(player.position.x, player.position.z))
	var facing: Vector3 = -player.get_node("Model").global_basis.z
	var heading := Vector2(facing.x, -facing.z).normalized()
	draw_circle(self_at, 7.7, Color("9b4d3c"))
	draw_line(self_at, self_at + heading * 16.0, Color("9b4d3c"), 4.0, true)
	draw_rect(Rect2(Vector2.ZERO, Vector2(size.x, 72)), paper)
	draw_rect(Rect2(Vector2(0, size.y - 48), Vector2(size.x, 48)), paper)
	draw_string(font, Vector2(27, 43), MAPS.text("A1  ·  River valley", "A1  ·  Thung lũng ven sông"),
		HORIZONTAL_ALIGNMENT_LEFT, -1, 25, INK)
	draw_rect(Rect2(size.x - 191, 20, 164, 39), Color("c8bc96"))
	draw_string(font, Vector2(size.x - 176, 44), MAPS.text("Find me  ·  Home", "Về vị trí  ·  Home"),
		HORIZONTAL_ALIGNMENT_LEFT, -1, 15, INK)
	draw_string(font, Vector2(27, size.y - 18), MAPS.text("Drag  ·  Scroll to zoom  ·  M / Esc to close",
		"Kéo để di chuyển  ·  Cuộn để thu phóng  ·  M / Esc để đóng"), HORIZONTAL_ALIGNMENT_LEFT, -1, 15, INK)

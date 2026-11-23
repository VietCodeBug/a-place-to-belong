extends Control
## North-up view sampled from the playable terrain and authored route plan.

const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
const PLAN = preload("res://scripts/world/village_a_layout.gd")
const LAND = preload("res://scripts/world/landscape.gd")
const FLOW = preload("res://scripts/story/map_flow.gd")
const T = preload("res://scripts/ui/storybook_theme.gd")
const WEATHER_ICON = preload("res://scripts/ui/postal_weather_icon.gd")
const INK := Color("243C36")
const CREAM := Color("F3E2BA")
const BRASS := Color("CEA477")
const CENTER := Vector2(75,75)
const RADIUS := 61.0
const METRES := 53.0
const TILE_METRES := 154.0
const TILE_PIXELS := 56
const NORTH := Vector2(0,-1)
const FORECAST := {"clear":["Clear","Trời quang"],"partly_cloudy":["Passing clouds","Mây rải rác"],
	"overcast":["Overcast","Nhiều mây"],"light_rain":["Light rain","Mưa nhẹ"],"heavy_rain":["Heavy rain","Mưa lớn"]}

var player: CharacterBody3D
var world: Node3D
var valley: Node3D
var field: FIELD
var pin := Vector2.ZERO
var heading := NORTH
var footways: Array = []
var footbridges: Array = []
var grove: PackedVector2Array
var map_tile: ImageTexture
var map_bounds := Rect2()
var pending: Image
var pending_bounds := Rect2()
var tile_season := -1
var row := 0
var redraw_wait := 0.0
var badge: StyleBoxFlat
var glyph: Control
var readout := ""
var conditions := ""

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	offset_left = 16
	offset_right = 298
	offset_top = -162
	offset_bottom = -12
	field = world.field
	var connected := PLAN.HOUSE_APPROACH.duplicate()
	for z in range(18,185,2):
		connected.append(Vector2(LAND.valley_path(z) if z>24 else ClearingLayout.path_center(z),z))
	footways = FIELD.TRAILS + [connected] + PLAN.LANES
	footbridges = [Vector2(0,LAND.BRIDGE_Z)]
	var village := valley.get_node("VillageA")
	for tree: Node3D in village.trees+valley.habitat_trees:
		grove.append(Vector2(tree.global_position.x,tree.global_position.z))
	badge = T.paper(Color("263E36"))
	badge.border_color = BRASS
	badge.set_corner_radius_all(13)
	badge.shadow_size = 5
	badge.shadow_offset = Vector2(0,3)
	glyph = WEATHER_ICON.new("sun",Vector2(24,24))
	glyph.position = Vector2(153,68)
	glyph.size = Vector2(24,24)
	add_child(glyph)

func set_readout(hour: String, forecast: String, icon: String) -> void:
	readout = hour
	var labels: Array = FORECAST.get(forecast,["Calm","Trời dịu"])
	conditions = FLOW.text(labels[0],labels[1])
	if glyph.icon_kind!=icon:
		glyph.icon_kind = icon

func _process(delta: float) -> void:
	if not visible:
		return
	var at := player.global_position
	pin = Vector2(at.x,at.z)
	if player.eyes!=null:
		heading = NORTH.rotated(-player.eyes.yaw)
	elif get_viewport().get_camera_3d()!=null:
		var view := -get_viewport().get_camera_3d().global_basis.z
		heading = Vector2(view.x,view.z).normalized()
	if pending==null and (map_tile==null or pin.distance_to(map_bounds.get_center())>20.0 or tile_season!=valley.current_season):
		pending = Image.create(TILE_PIXELS,TILE_PIXELS,false,Image.FORMAT_RGB8)
		pending_bounds = Rect2(pin-Vector2.ONE*TILE_METRES*.5,Vector2.ONE*TILE_METRES)
		tile_season = valley.current_season
		row = 0
	if pending!=null:
		fill_tile_rows()
	redraw_wait -= delta
	if redraw_wait<=0.0:
		redraw_wait = 1.0/30.0
		queue_redraw()

func fill_tile_rows() -> void:
	var sample_width := TILE_METRES/TILE_PIXELS
	var end := mini(row+4,TILE_PIXELS)
	for depth in range(row,end):
		for column in TILE_PIXELS:
			var sample := pending_bounds.position+Vector2(column+.5,depth+.5)*sample_width
			var height := field.height(sample)
			var tone := field.map_color(sample,height)
			var river := absf(sample.x)<40.0 and absf(sample.y-LAND.river_center(sample.x))<4.6
			var water := river or field.lake_ratio(sample)<1.0
			if water:
				tone = Color("6D9D9A") if river else tone.lerp(Color("83BBB2"),.24)
			else:
				tone = tone.lerp(Color("A7A77A"),.62)
				if tile_season==3:
					tone = tone.lerp(Color("E1E8DE"),.65)
				var contour := absf(fposmod(height,5.0)-2.5)
				tone = tone.darkened(smoothstep(2.12,2.40,contour)*.12)
			pending.set_pixel(column,depth,tone)
	row = end
	if row==TILE_PIXELS:
		map_tile = ImageTexture.create_from_image(pending)
		map_bounds = pending_bounds
		pending = null

func plot(at: Vector2) -> Vector2:
	return CENTER+(at-pin)*(RADIUS/METRES)

func world_patch() -> void:
	var polys := PackedVector2Array()
	var uv := PackedVector2Array()
	for i in 72:
		var normal := NORTH.rotated(i*TAU/72.0)
		polys.append(CENTER+normal*RADIUS)
		uv.append(((pin+normal*METRES-map_bounds.position)/map_bounds.size).clamp(Vector2.ZERO,Vector2.ONE))
	draw_polygon(polys,PackedColorArray([Color.WHITE]),uv,map_tile)

func line_in_map(a: Vector2,b: Vector2,width: float) -> void:
	var first := plot(a)-CENTER
	var last := plot(b)-CENTER
	var direction := last-first
	var distance_sq := direction.length_squared()
	if distance_sq<.001:
		return
	var t := -first.dot(direction)/distance_sq
	var mid := first+direction*t
	var radius := RADIUS-3.0
	var room := radius*radius-mid.length_squared()
	if room<=0.0:
		return
	var half := sqrt(room/distance_sq)
	var lo := maxf(0.0,t-half)
	var hi := minf(1.0,t+half)
	if hi>lo:
		var from := CENTER+first+direction*lo
		var to := CENTER+first+direction*hi
		draw_line(from,to,Color("796A50"),width+1.25,true)
		draw_line(from,to,Color("E2CB91"),width,true)

func tree_marks() -> void:
	for tree: Vector2 in grove:
		var p := plot(tree)
		if p.distance_squared_to(CENTER)>(RADIUS-6.0)**2:
			continue
		draw_circle(p+Vector2(.9,1.2),2.65,Color("536B52"),true,-1,true)
		draw_circle(p,2.45,Color("668260"),true,-1,true)

func lots() -> void:
	for lot in PLAN.BUILDINGS:
		var p := plot(Vector2(lot[2],lot[3]))
		if p.distance_squared_to(CENTER)>(RADIUS-6.0)**2:
			continue
		var scale_in_map := 1.35 if lot[1]=="chapel" else 1.0
		draw_set_transform(p,-float(lot[4]),Vector2.ONE*scale_in_map)
		draw_rect(Rect2(-3.3,-2.35,6.6,4.7),Color("725749"))
		draw_rect(Rect2(-2.7,-1.75,5.4,3.5),Color("C4986D"))
		draw_line(Vector2(0,-1.7),Vector2(0,1.7),Color("E2BA8D"),1.0)
		draw_set_transform(Vector2.ZERO)
	var house := plot(PLAN.HOUSE_A)
	if house.distance_to(CENTER)<RADIUS-7.0:
		draw_circle(house,4.4,INK,true,-1,true)
		draw_colored_polygon(PackedVector2Array([house+Vector2(0,-3.8),house+Vector2(3.3,0),
			house+Vector2(2.4,0),house+Vector2(2.4,2.8),house+Vector2(-2.4,2.8),house+Vector2(-2.4,0),
			house+Vector2(-3.3,0)]),CREAM)
	for bridge in footbridges:
		var p := plot(bridge)
		if p.distance_to(CENTER)<RADIUS-6.0:
			draw_rect(Rect2(p-Vector2(2,5),Vector2(4,10)),Color("B38656"))

func section_name() -> String:
	if absf(pin.x)<35.0 and pin.y>=97.0 and pin.y<=171.0:
		return FLOW.text("Village A","Làng A")
	if absf(pin.x)<40.0 and absf(pin.y-LAND.BRIDGE_Z)<16.0:
		return FLOW.text("River valley","Thung lũng sông")
	if pin.distance_to(PLAN.HOUSE_A)<37.0:
		return FLOW.text("House A woods","Rừng Nhà A")
	if field.lake_ratio(pin)<1.17:
		return FLOW.text("Great lake","Hồ lớn")
	return "A1"

func _draw() -> void:
	if badge==null:
		return
	draw_style_box(badge,Rect2(106,28,171,108))
	draw_rect(Rect2(150,95,115,1),Color("52665A"))
	draw_circle(Vector2(165,80),14.5,CREAM,true,-1,true)
	draw_string(T.SANS,Vector2(150,50),section_name(),HORIZONTAL_ALIGNMENT_LEFT,-1,14,CREAM)
	draw_string(T.SANS,Vector2(186,89),readout,HORIZONTAL_ALIGNMENT_LEFT,-1,24,Color("FCF1D7"))
	draw_string(T.SANS,Vector2(150,113),conditions,HORIZONTAL_ALIGNMENT_LEFT,-1,12,Color("E4D6B8"))
	draw_string(T.SANS,Vector2(150,129),FLOW.text("[M]  World map","[M]  Bản đồ lớn"),HORIZONTAL_ALIGNMENT_LEFT,-1,11,Color("ACC4AA"))
	draw_circle(CENTER+Vector2(1,4),RADIUS+9.0,Color(.07,.14,.12,.40),true,-1,true)
	draw_circle(CENTER,RADIUS+8.0,INK,true,-1,true)
	draw_circle(CENTER,RADIUS+5.0,BRASS,true,-1,true)
	draw_circle(CENTER,RADIUS+2.5,Color("6D7F59"),true,-1,true)
	if map_tile!=null:
		world_patch()
	tree_marks()
	for route in footways:
		for i in range(route.size()-1):
			line_in_map(route[i],route[i+1],2.3)
	lots()
	var tail := heading.rotated(PI*.5)*5.7
	var arrow := PackedVector2Array([CENTER+heading*11.0,CENTER-heading*5.8+tail,
		CENTER-heading*2.1,CENTER-heading*5.8-tail])
	draw_colored_polygon(arrow,Color("F3D29C"))
	arrow.append(arrow[0])
	draw_polyline(arrow,INK,1.8,true)
	draw_circle(CENTER+Vector2(0,-RADIUS-2),9.5,INK,true,-1,true)
	draw_string(T.SANS,CENTER+Vector2(-4.2,-RADIUS+2.3),"N",HORIZONTAL_ALIGNMENT_LEFT,-1,11,CREAM)
	for tick in [Vector2.LEFT,Vector2.RIGHT,Vector2.DOWN]:
		draw_line(CENTER+tick*(RADIUS+1.7),CENTER+tick*(RADIUS+5.0),INK,1.8,true)

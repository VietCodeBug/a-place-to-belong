extends Control

const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
const PLAN = preload("res://scripts/world/village_a_layout.gd")
const FLOW = preload("res://scripts/story/map_flow.gd")
const INK := Color("334A41")
const PAPER := Color("EEE2C2")
const MAP_SIZE := 352
const MARKERS := [
	[PLAN.HOUSE_A,"House A","Nhà A"],
	[FIELD.SHORE,"West shore","Bờ tây"],
	[FIELD.LAKE,"Lake","Hồ lớn"]
]
var player: Node3D
var world: Node3D
var field: FIELD
var texture: ImageTexture
var center := Vector2.ZERO
var explored: Dictionary = {}
var zoom := 1.0
var atlas := false
var show_chunks := false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	field = world.field
	center = field.bounds.get_center()
	hide()

func _process(_delta: float) -> void:
	explored[field.tile(Vector2(player.position.x,player.position.z))] = true
	if visible:
		if texture == null:
			generate_overview()
		queue_redraw()

func generate_overview() -> void:
	var image := Image.create(MAP_SIZE,MAP_SIZE,false,Image.FORMAT_RGBA8)
	var metres := field.bounds.size.x / MAP_SIZE
	var elevations := PackedFloat32Array()
	elevations.resize(MAP_SIZE*MAP_SIZE)
	for row in MAP_SIZE:
		for col in MAP_SIZE:
			var p := field.bounds.position+Vector2(col+.5,row+.5)*metres
			elevations[row*MAP_SIZE+col] = field.height(p)
	for row in MAP_SIZE:
		for col in MAP_SIZE:
			var p := field.bounds.position+Vector2(col+.5,row+.5)*metres
			var h := elevations[row*MAP_SIZE+col]
			var c := field.map_color(p,h)
			var upper := maxi(0,row-2)*MAP_SIZE+mini(MAP_SIZE-1,col+2)
			var slope := elevations[upper]-h
			var shade := clampf(.96-slope*.024,.68,1.15)
			image.set_pixel(col,row,Color(c.r*shade,c.g*shade,c.b*shade,1))
	texture = ImageTexture.create_from_image(image)

func map_rect() -> Rect2:
	var width := minf(size.x*.76,size.y-116.0)
	return Rect2(Vector2((size.x-width)*.5,(size.y-width)*.5),Vector2.ONE*width)

func world_view() -> Rect2:
	var span := field.bounds.size/zoom
	var origin := (center-span*.5).clamp(field.bounds.position,field.bounds.end-span)
	return Rect2(origin,span)

func center_on_player() -> void:
	center = Vector2(player.position.x,player.position.z)

func toggle_atlas() -> void:
	atlas = not atlas
	queue_redraw()

func toggle_chunks() -> void:
	show_chunks = not show_chunks
	queue_redraw()

func _gui_input(event: InputEvent) -> void:
	if atlas:
		return
	var scale_m := world_view().size.x/map_rect().size.x
	if event is InputEventMouseMotion and (event.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
		center = world_view().get_center()-event.relative*scale_m
		accept_event()
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index in [MOUSE_BUTTON_WHEEL_UP,MOUSE_BUTTON_WHEEL_DOWN]:
			var mouse_uv: Vector2 = (event.position-map_rect().get_center())/map_rect().size
			var view := world_view()
			zoom = clampf(zoom*(1.23 if event.button_index==MOUSE_BUTTON_WHEEL_UP else 1.0/1.23),1.0,30.0)
			center = view.get_center() + mouse_uv*(view.size-field.bounds.size/zoom)
			accept_event()

func point(p: Vector2, target: Rect2, view: Rect2) -> Vector2:
	return target.position+(p-view.position)/view.size*target.size

func _draw() -> void:
	if texture == null:
		return
	var font := get_theme_default_font()
	draw_rect(Rect2(Vector2.ZERO,size),PAPER)
	if atlas:
		draw_atlas(font)
		return
	var rect := map_rect()
	var view := world_view()
	var source := Rect2((view.position-field.bounds.position)/field.bounds.size*MAP_SIZE,
		view.size/field.bounds.size*MAP_SIZE)
	draw_texture_rect_region(texture,rect,source)
	var metres_per_pixel := view.size.x/rect.size.x
	var tile_pixels := field.chunk_size/metres_per_pixel
	for id: Vector2i in explored:
		var origin := point(Vector2(id)*field.chunk_size,rect,view)
		draw_rect(Rect2(origin,Vector2.ONE*tile_pixels).intersection(rect),Color(.96,.84,.51,.37))
	if show_chunks:
		for id: Vector2i in world.streamer.chunks:
			var origin := point(Vector2(id)*field.chunk_size,rect,view)
			var outline := Color("2E6054") if world.streamer.solid.has(id) else Color(.2,.32,.27,.39)
			draw_rect(Rect2(origin,Vector2.ONE*tile_pixels).intersection(rect),outline,false,1.0)
		var corner := point(FIELD.CORE.position,rect,view)
		var core_rect := Rect2(corner,FIELD.CORE.size/metres_per_pixel)
		draw_rect(core_rect.intersection(rect),Color("654737"),false,2.0)
	for route in FIELD.TRAILS + [PLAN.HOUSE_APPROACH]:
		for i in range(route.size()-1):
			var a := point(route[i],rect,view)
			var b := point(route[i+1],rect,view)
			var clipped := clip_segment(a,b,rect)
			if clipped.size()==2:
				draw_line(clipped[0],clipped[1],Color("F2D298"),2.0,true)
	var markers := MARKERS.duplicate()
	for biome in FIELD.BIOMES:
		markers.append([biome[1],biome[2],biome[3]])
	for marker in markers:
		var pin := point(marker[0],rect,view)
		if not rect.has_point(pin) or (marker[0]==FIELD.ARCH and zoom<3.0):
			continue
		draw_circle(pin,4.0,Color("F3DB9C"))
		var offset := Vector2(8,-5)
		# The authored corridor is only 128 m wide, so separate labels on the full map.
		if marker[0]==Vector2(0,74):
			offset = Vector2(-84,3)
		elif marker[0]==Vector2(5,-320) and zoom<4.0:
			offset = Vector2(-92,12)
		elif marker[0]==FIELD.ARCH:
			offset = Vector2(8,17)
		draw_string_outline(font,pin+offset,FLOW.text(marker[1],marker[2]),HORIZONTAL_ALIGNMENT_LEFT,-1,14,2,Color("F3E9C9"))
		draw_string(font,pin+offset,FLOW.text(marker[1],marker[2]),HORIZONTAL_ALIGNMENT_LEFT,-1,14,INK)
	var p := point(Vector2(player.position.x,player.position.z),rect,view)
	if rect.has_point(p):
		draw_circle(p,7.0,Color("F3E5BA"))
		draw_circle(p,4.5,Color("9C4A35"))
	draw_rect(rect,INK,false,2)
	draw_string(font,Vector2(25,37),"A1   ·   %.3f × %.3f km" % [field.bounds.size.x*.001,field.bounds.size.y*.001],
		HORIZONTAL_ALIGNMENT_LEFT,-1,24,INK)
	var scale_bar := 500.0 if zoom<3.0 else 100.0 if zoom<12.0 else 25.0
	var ruler := Vector2(rect.end.x-scale_bar/metres_per_pixel,rect.end.y+15)
	draw_line(ruler,ruler+Vector2(scale_bar/metres_per_pixel,0),INK,2.0)
	draw_string(font,ruler+Vector2(0,18),"%d m" % scale_bar,HORIZONTAL_ALIGNMENT_LEFT,-1,14,INK)
	draw_string(font,Vector2(25,size.y-23),FLOW.text("Drag / scroll · Home center · Tab regions · F7 tiles · M return",
		"Kéo / cuộn · Home định tâm · Tab các vùng · F7 ô terrain · M quay lại"),HORIZONTAL_ALIGNMENT_LEFT,-1,15,INK)
	if show_chunks:
		draw_string(font,Vector2(25,66),FLOW.text("%d mesh / %d physical tiles" ,"%d ô mesh / %d ô có collision")
			% [world.streamer.chunks.size(),world.streamer.solid.size()],HORIZONTAL_ALIGNMENT_LEFT,-1,14,INK)

func clip_segment(a: Vector2, b: Vector2, rect: Rect2) -> PackedVector2Array:
	var result := PackedVector2Array()
	if rect.has_point(a):
		result.append(a)
	if rect.has_point(b):
		result.append(b)
	var corners := PackedVector2Array([rect.position,Vector2(rect.end.x,rect.position.y),rect.end,Vector2(rect.position.x,rect.end.y)])
	for i in 4:
		if result.size()==2:
			break
		var hit = Geometry2D.segment_intersects_segment(a,b,corners[i],corners[(i+1)%4])
		if hit != null and not result.has(hit):
			result.append(hit)
	return result

func draw_atlas(font: Font) -> void:
	draw_string(font,Vector2(25,37),FLOW.text("World regions","Các vùng thế giới"),HORIZONTAL_ALIGNMENT_LEFT,-1,25,INK)
	var cell := minf(164.0,(size.y-145.0)/3.0)
	var top := (size-3.0*Vector2.ONE*cell)*.5
	for i in field.regions.size():
		var region: Dictionary = field.regions[i]
		var p := top+Vector2(i%3,floori(i/3.0))*cell
		draw_rect(Rect2(p,Vector2.ONE*(cell-8.0)),Color("AEC09A") if region.playable else Color("D7CBB0"))
		draw_string(font,p+Vector2(15,34),region.id,HORIZONTAL_ALIGNMENT_LEFT,-1,24,INK)
		var label := FLOW.text("Prototype","Chơi thử") if region.playable else FLOW.text("Reserved","Dự trữ")
		draw_string(font,p+Vector2(15,60),label,HORIZONTAL_ALIGNMENT_LEFT,-1,15,INK)
	draw_string(font,Vector2(25,size.y-23),FLOW.text("Tab A1 map · M return","Tab về bản đồ A1 · M quay lại"),
		HORIZONTAL_ALIGNMENT_LEFT,-1,15,INK)

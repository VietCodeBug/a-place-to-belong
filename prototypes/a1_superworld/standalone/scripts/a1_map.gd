class_name A1MapOverlay
extends Control
## Live generated overview based on the same height field as streamed terrain.
const G = preload("res://scripts/world_gen.gd")
var gen:A1WorldGen
var player:Node3D
var texture:ImageTexture
var map_open:=false
var atlas_mode:=false
var zoom:=1.0
var pan:=Vector2.ZERO
var drag:=false
var visited:Dictionary={}
var points: Array = [
	["Nhà A",Vector2(-115,15)], ["Thomas · lối rừng",Vector2(-35,125)],
	["Cầu gỗ",Vector2(0,240)], ["Làng A",Vector2(50,455)],
	["Bến câu cá",Vector2(360,-530)], ["Hồ Ánh Sao",Vector2(780,-530)],
	["Vườn đá dưới hồ",Vector2(795,-535)], ["Đồng cỏ hoa",Vector2(-600,950)],
	["Rừng cổ thụ",Vector2(-1000,-1050)], ["Đỉnh ngắm cảnh",Vector2(-1200,710)],
	["Thung lũng phía đông",Vector2(1380,660)]
]

func setup(generator:A1WorldGen,p:Node3D) -> void:
	gen=generator
	player=p
	mouse_filter=Control.MOUSE_FILTER_STOP
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hide()
	build_map_texture()

func build_map_texture() -> void:
	var resolution:=384
	var image:=Image.create(resolution,resolution,false,Image.FORMAT_RGBA8)
	for py in range(resolution):
		for px in range(resolution):
			var x:float=(float(px)/float(resolution-1)-.5)*G.SIZE
			var z:float=(float(py)/float(resolution-1)-.5)*G.SIZE
			var c:=gen.surface_color(x,z)
			var h:=gen.terrain_height(x,z)
			var n:float=gen.terrain_height(x+18,z)-h
			var shade:=clampf(.87-n*.012,.65,1.1)
			c=Color(c.r*shade,c.g*shade,c.b*shade,1.0)
			image.set_pixel(px,py,c)
	texture=ImageTexture.create_from_image(image)

func toggle() -> void:
	map_open=not map_open
	visible=map_open
	if map_open:
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
		queue_redraw()
	else:
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _process(_delta:float) -> void:
	if player==null:return
	var key:=Vector2i(floori(player.global_position.x/128.0),floori(player.global_position.z/128.0))
	visited[key]=true
	if map_open:queue_redraw()

func _gui_input(event:InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom=clampf(zoom*1.18,1.0,7.0)
			accept_event()
		if event.button_index==MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom=clampf(zoom/1.18,1.0,7.0)
			accept_event()
		if event.button_index==MOUSE_BUTTON_LEFT:
			drag=event.pressed
	if event is InputEventMouseMotion and drag:
		pan-=event.relative*512.0/(minf(size.y*.77,size.x*.68)*zoom)
		pan.x=clampf(pan.x,-230,230)
		pan.y=clampf(pan.y,-230,230)
		accept_event()

func _unhandled_input(event:InputEvent) -> void:
	if not map_open:return
	if event.is_action_pressed("atlas"):
		atlas_mode=not atlas_mode
		queue_redraw()
	elif event.is_action_pressed("map_center"):
		pan=world_to_source(Vector2(player.global_position.x,player.global_position.z))-Vector2(192,192)
		queue_redraw()

func world_to_source(p:Vector2) -> Vector2:
	return (p+Vector2(G.HALF,G.HALF))/G.SIZE*384.0

func _draw() -> void:
	if not map_open or texture==null:return
	var font:=get_theme_default_font()
	var title_color:=Color("e9e0c7")
	draw_rect(Rect2(Vector2.ZERO,size),Color(0.055,0.095,0.10,.97))
	draw_string(font,Vector2(35,47),"A PLACE TO BELONG  /  SUPERWORLD ATLAS",HORIZONTAL_ALIGNMENT_LEFT,-1,26,title_color)
	if atlas_mode:
		_draw_atlas(font)
		return
	var length:=minf(size.y*.77,size.x*.71)
	var rect:=Rect2(Vector2((size.x-length)*.5,(size.y-length)*.5+15),Vector2(length,length))
	var source_size:=384.0/zoom
	var src:=Rect2(Vector2(192,192)+pan-Vector2.ONE*source_size*.5,Vector2.ONE*source_size)
	# Keep source rect within the texture to avoid wrapping past the real region.
	src.position.x=clampf(src.position.x,0.0,384.0-source_size)
	src.position.y=clampf(src.position.y,0.0,384.0-source_size)
	draw_texture_rect_region(texture,rect,src)
	draw_rect(rect,Color("f2dfba"),false,3.0)
	for item in points:
		var pt:Vector2=rect.position+(world_to_source(item[1])-src.position)/src.size*rect.size
		if rect.has_point(pt):
			draw_circle(pt,5.0,Color("f9e7b9"))
			draw_string(font,pt+Vector2(10,-7),item[0],HORIZONTAL_ALIGNMENT_LEFT,-1,14,Color("e9f3de"))
	var player_uv:=world_to_source(Vector2(player.global_position.x,player.global_position.z))
	var pp:=rect.position+(player_uv-src.position)/src.size*rect.size
	if rect.has_point(pp):
		draw_circle(pp,9,Color("e9a45f"))
		draw_circle(pp,4,Color("263d37"))
	draw_string(font,Vector2(45,size.y-47),"A1  ·  4,096 × 4,096 m   |   cuộn chuột: zoom   ·   kéo: pan   ·   C: định tâm   ·   TAB: siêu bản đồ   ·   M: đóng",HORIZONTAL_ALIGNMENT_LEFT,-1,16,title_color)

func _draw_atlas(font:Font) -> void:
	var labels:=["B","C","D","E","A1","F","G","H","I"]
	var center:=size*.5
	var cell:=minf(size.y*.23,size.x*.19)
	for i in range(9):
		var row:=i/3
		var col:=i%3
		var pos:=center+Vector2((float(col)-1.5)*cell,(float(row)-1.5)*cell)+Vector2(10,20)
		var r:=Rect2(pos,Vector2(cell-9,cell-9))
		var main:=i==4
		draw_rect(r,Color("577d65") if main else Color("233f42"))
		draw_rect(r,Color("eadfbe") if main else Color("567373"),false,2)
		draw_string(font,pos+Vector2(15,38),labels[i],HORIZONTAL_ALIGNMENT_LEFT,-1,25,Color("f3e8ca"))
		draw_string(font,pos+Vector2(15,64),"PROTOTYPE" if main else "DỰ TRỮ",HORIZONTAL_ALIGNMENT_LEFT,-1,12,Color("f3e8ca"))
	draw_string(font,Vector2(48,size.y-45),"A1 là vùng đã dựng. B–I chỉ là vùng quy hoạch để mở rộng, chưa có terrain/gameplay. TAB quay lại bản đồ A1.",HORIZONTAL_ALIGNMENT_LEFT,-1,17,Color("e3dac3"))

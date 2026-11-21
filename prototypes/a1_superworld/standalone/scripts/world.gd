extends Node3D
## A1 is ONE open-world region. Additional regions B, C, D, E... are reserved.
const GEN = preload("res://scripts/world_gen.gd")
const STREAM = preload("res://scripts/world_chunks.gd")
const PROPS = preload("res://scripts/world_props.gd")
const PLAYER = preload("res://scripts/player.gd")
const MAP = preload("res://scripts/a1_map.gd")
var generator:A1WorldGen
var explorer:A1Explorer
var streamer:A1WorldChunks
var map_overlay:A1MapOverlay
var environment:Environment
var sunlight:DirectionalLight3D
var hud:Label
var bottom:Label
var info:Label
var water_tint:ColorRect
var season:=1
var afternoon:=true
var warning_time:=0.0
var warning_message:=""

func _ready() -> void:
	setup_inputs()
	generator=GEN.new()
	setup_sky()
	streamer=STREAM.new()
	streamer.name="ChunkStreamer"
	add_child(streamer)
	explorer=PLAYER.new()
	explorer.name="Explorer"
	explorer.setup(generator)
	var start: Vector2 = GEN.HOUSE+Vector2(0,-14)
	explorer.position=Vector3(start.x,generator.terrain_height(start.x,start.y)+1.0,start.y)
	add_child(explorer)
	streamer.setup(generator,explorer)
	streamer.ensure_spawn()
	var props:=PROPS.new()
	props.name="LandmarksAndLake"
	add_child(props)
	props.setup(generator)
	setup_interface()
	show_notice("A1 đã mở! Ấn M để xem bản đồ · 3 để đến hồ lớn",6.0)

func bind_key(action:String,keycode:Key) -> void:
	if not InputMap.has_action(action): InputMap.add_action(action)
	var e:=InputEventKey.new()
	e.physical_keycode=keycode
	InputMap.action_add_event(action,e)

func setup_inputs() -> void:
	bind_key("forward",KEY_W)
	bind_key("back",KEY_S)
	bind_key("left",KEY_A)
	bind_key("right",KEY_D)
	bind_key("jump",KEY_SPACE)
	bind_key("dive",KEY_CTRL)
	bind_key("sprint",KEY_SHIFT)
	bind_key("map",KEY_M)
	bind_key("atlas",KEY_TAB)
	bind_key("map_center",KEY_C)
	bind_key("toggle_camera",KEY_V)
	bind_key("interact",KEY_E)
	bind_key("release_mouse",KEY_ESCAPE)
	bind_key("season_spring",KEY_F1)
	bind_key("season_summer",KEY_F2)
	bind_key("season_autumn",KEY_F3)
	bind_key("season_winter",KEY_F4)
	bind_key("time_toggle",KEY_F6)
	bind_key("tp_house",KEY_1)
	bind_key("tp_village",KEY_2)
	bind_key("tp_lake",KEY_3)
	bind_key("tp_underwater",KEY_4)
	bind_key("tp_ridge",KEY_5)

func setup_sky() -> void:
	var sky:=Sky.new()
	var sky_mat:=ProceduralSkyMaterial.new()
	sky_mat.sky_top_color=Color("779cbb")
	sky_mat.sky_horizon_color=Color("d6e2df")
	sky_mat.ground_bottom_color=Color("64806d")
	sky_mat.ground_horizon_color=Color("b7caba")
	sky_mat.use_debanding=true
	sky.sky_material=sky_mat
	environment=Environment.new()
	environment.background_mode=Environment.BG_SKY
	environment.sky=sky
	environment.ambient_light_source=Environment.AMBIENT_SOURCE_SKY
	environment.ambient_light_energy=.52
	environment.tonemap_mode=Environment.TONE_MAPPER_FILMIC
	environment.fog_enabled=true
	environment.fog_light_color=Color("b4c8c5")
	environment.fog_density=.00032
	var we:=WorldEnvironment.new()
	we.environment=environment
	add_child(we)
	sunlight=DirectionalLight3D.new()
	sunlight.rotation_degrees=Vector3(-43,-27,0)
	sunlight.light_color=Color("ffe0b0")
	sunlight.light_energy=1.15
	sunlight.shadow_enabled=true
	add_child(sunlight)

func setup_interface() -> void:
	var ui:=CanvasLayer.new()
	ui.name="PrototypeHUD"
	add_child(ui)
	water_tint=ColorRect.new()
	water_tint.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	water_tint.mouse_filter=Control.MOUSE_FILTER_IGNORE
	water_tint.color=Color(.05,.39,.55,.18)
	water_tint.visible=false
	ui.add_child(water_tint)
	hud=Label.new()
	hud.add_theme_font_size_override("font_size",23)
	hud.add_theme_color_override("font_color",Color("f7f1da"))
	hud.add_theme_color_override("font_shadow_color",Color(.04,.12,.13,.85))
	hud.add_theme_constant_override("shadow_offset_x",2)
	hud.add_theme_constant_override("shadow_offset_y",2)
	hud.position=Vector2(28,22)
	ui.add_child(hud)
	bottom=Label.new()
	bottom.add_theme_font_size_override("font_size",17)
	bottom.add_theme_color_override("font_color",Color("f4ead3"))
	bottom.position=Vector2(29,158)
	bottom.text="WASD: đi  ·  SHIFT: chạy  ·  SPACE: nhảy/nổi  ·  CTRL: lặn  ·  M: bản đồ  ·  TAB trên bản đồ: các vùng B–I\n1: Nhà A  ·  2: Làng A  ·  3: Bến hồ  ·  4: Dưới nước  ·  5: Đỉnh núi\nF1–F4: 4 mùa  ·  F6: chiều/tối  ·  V: đổi camera  ·  E: câu cá thử  ·  ESC: thả/khóa chuột"
	ui.add_child(bottom)
	info=Label.new()
	info.add_theme_font_size_override("font_size",20)
	info.add_theme_color_override("font_color",Color("ffe6b0"))
	info.position=Vector2(29,260)
	ui.add_child(info)
	map_overlay=MAP.new()
	map_overlay.name="A1Atlas"
	ui.add_child(map_overlay)
	map_overlay.setup(generator,explorer)

func _process(delta:float) -> void:
	if explorer==null:return
	var pos:=explorer.global_position
	var season_name: String = ["Thu","Xuân","Hạ","Đông"][season]
	var underwater:=explorer.underwater
	water_tint.visible=underwater
	environment.fog_density=.016 if underwater else .00032
	environment.fog_light_color=Color("2f8ca7") if underwater else Color("b4c8c5")
	hud.text="A1 — RỪNG VÀ HỒ ÁNH SAO  |  4 × 4 km\n%s  ·  Mùa %s  ·  %s\nX: %.0f m   Z: %.0f m   H: %.0f m\n%d chunks tải quanh người chơi" % [generator.biome(pos.x,pos.z),season_name,"DƯỚI NƯỚC" if underwater else "KHÁM PHÁ",pos.x,pos.z,pos.y,streamer.active_count()]
	if warning_time>0:
		warning_time-=delta
		info.text=warning_message
	else:
		info.text="BẾN CÂU CÁ (E): Chưa triển khai minigame" if pos.distance_to(Vector3(GEN.PIER.x,pos.y,GEN.PIER.y))<80 else ""

func show_notice(msg:String,time:=4.0) -> void:
	warning_message=msg
	warning_time=time

func _unhandled_input(e:InputEvent) -> void:
	if e.is_action_pressed("map"):
		map_overlay.toggle()
		get_viewport().set_input_as_handled()
		return
	if map_overlay.map_open:return
	if e.is_action_pressed("release_mouse"):
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE if Input.mouse_mode==Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED
	if e.is_action_pressed("tp_house"):
		teleport(GEN.HOUSE+Vector2(0,-14))
	if e.is_action_pressed("tp_village"):
		teleport(GEN.VILLAGE)
	if e.is_action_pressed("tp_lake"):
		teleport(GEN.PIER+Vector2(-42,0))
	if e.is_action_pressed("tp_underwater"):
		teleport(GEN.UNDERWATER,true)
	if e.is_action_pressed("tp_ridge"):
		teleport(Vector2(-1200,710))
	if e.is_action_pressed("season_spring"):change_season(1)
	if e.is_action_pressed("season_summer"):change_season(2)
	if e.is_action_pressed("season_autumn"):change_season(0)
	if e.is_action_pressed("season_winter"):change_season(3)
	if e.is_action_pressed("time_toggle"):
		afternoon=not afternoon
		sunlight.rotation_degrees=Vector3(-43,-27,0) if afternoon else Vector3(-11,-66,0)
		sunlight.light_energy=1.15 if afternoon else .38
		show_notice("Ánh sáng %s"%("ban ngày" if afternoon else "chiều muộn"))
	if e.is_action_pressed("interact") and Vector2(explorer.global_position.x,explorer.global_position.z).distance_to(GEN.PIER)<85:
		show_notice("Đã đánh dấu điểm câu cá. Minigame câu cá sẽ phát triển sau!",5.0)

func teleport(p:Vector2,below_water:=false) -> void:
	explorer.teleport_to(p,below_water)
	streamer.ensure_spawn()
	show_notice("Đã đến %s" % generator.biome(p.x,p.y),3.0)

func change_season(s:int) -> void:
	season=s
	streamer.set_season(s)
	show_notice("Đã đổi sang mùa %s"%["Thu","Xuân","Hạ","Đông"][s],3.0)

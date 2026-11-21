extends RefCounted
const T=preload("res://scripts/ui/storybook_theme.gd")
const Mark=preload("res://scripts/ui/postal_motif.gd")
const Postcard=preload("res://scripts/ui/atmosphere_postcard.gd")
const MAPS = preload("res://scripts/story/map_flow.gd")

var ui
var current_map: int
var pages: Dictionary={}
var page_name:=""
var shade: Control
var menu_focus: Control
var postcards: Array[Button]=[]
var studio_cards: Array[Button]=[]
var reduce_motion:=false
func _init(owner_ui, map_number := MAPS.FOREST) -> void:
	ui = owner_ui
	current_map = map_number
	reduce_motion = ui.get_tree().get_meta(MAPS.QUIET_UI, false)
func button(parent: Node, text: String, action: Callable, primary := false) -> Button:
	var b := preload("res://scripts/ui/sketch_button.gd").new()
	b.text = text
	b.use_handwriting = not MAPS.is_vietnamese()
	b.primary = primary
	b.custom_minimum_size.y = 46
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.pressed.connect(action)
	parent.add_child(b)
	b.mouse_entered.connect(func():tick(650.))
	b.pressed.connect(func():tick(880.))
	return b
func tick(hz: float) -> void:
	if reduce_motion:return
	var player:=AudioStreamPlayer.new();var wav:=AudioStreamWAV.new();wav.format=AudioStreamWAV.FORMAT_16_BITS;wav.mix_rate=22050
	var bytes:=PackedByteArray();bytes.resize(1324)
	for i in range(662):bytes.encode_s16(i*2,int(sin(i*hz*TAU/22050.)*700.*pow(1.-i/662.,3.)))
	wav.data=bytes;player.stream=wav;ui.add_child(player);player.finished.connect(player.queue_free);player.play()
func column(parent: Node,gap: int=12) -> VBoxContainer:
	var v:=VBoxContainer.new();v.add_theme_constant_override("separation",gap);parent.add_child(v);return v
func build_title() -> void:
	ui.title_screen = Control.new()
	ui.title_screen.name = "ScenicTitleScreen"
	ui.root_ui.add_child(ui.title_screen)
	ui.title_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var wash := TextureRect.new()
	var gradient := Gradient.new()
	gradient.colors = PackedColorArray([
		T.CREAM, T.CREAM, Color(T.CREAM, 0.90), Color(T.CREAM, 0.0),
	])
	gradient.offsets = PackedFloat32Array([0.0, 0.338, 0.375, 0.565])
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.fill_to = Vector2.RIGHT
	wash.texture = texture
	wash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.title_screen.add_child(wash)
	wash.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var left := column(ui.title_screen, 11)
	left.position = Vector2(61, 57)
	left.custom_minimum_size.x = 350
	var seal := Mark.new()
	seal.seal = true
	seal.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	left.add_child(seal)

	var title := T.label("A Place\nto Belong", 82, T.FOREST, true)
	title.add_theme_constant_override("line_spacing", -17)
	left.add_child(title)
	var tagline := T.label(MAPS.text(
		"A second life, somewhere between\ndreams and reality.",
		"Một cuộc đời khác, đâu đó giữa\ngiấc mơ và hiện thực."
	), 16, T.SAGE)
	left.add_child(tagline)
	var gap := Control.new()
	gap.custom_minimum_size.y = 6
	gap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	left.add_child(gap)

	var first := button(left, MAPS.label(MAPS.OFFICE) + "   →", begin_day, true)
	first.name = "BeginDay"
	var forest := button(left, MAPS.label(MAPS.FOREST) + "   →", func(): ui.exit_title_menu(false))
	forest.name = "ExploreForest"

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 21)
	left.add_child(row)
	var settings := button(row, MAPS.text("Settings", "Cài đặt"), func(): open_page("Settings"))
	settings.name = "TitleSettings"
	var leave := button(row, MAPS.text("Quit game", "Thoát game"), func(): ui.get_tree().quit())
	for secondary in [settings, leave]:
		secondary.flat_ink = true
		secondary.custom_minimum_size.y = 40

func make_page(name: String, heading_text: String) -> VBoxContainer:
	var center := CenterContainer.new()
	center.name = name.replace(" ", "")
	shade.add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.hide()
	pages[name] = center

	var paper := PanelContainer.new()
	paper.custom_minimum_size.x = 660
	paper.add_theme_stylebox_override("panel", T.paper())
	center.add_child(paper)
	var col := column(paper, 14)
	col.add_child(T.label(heading_text, 29 if MAPS.is_vietnamese() else 38, T.FOREST, not MAPS.is_vietnamese()))
	return col

func add_back_button(parent: Node) -> void:
	button(parent, MAPS.text("Return   ←", "Quay lại   ←"), back)

func build_pause() -> void:
	ui.pause_overlay = Control.new()
	ui.pause_overlay.name = "CozyPauseMenu"
	ui.root_ui.add_child(ui.pause_overlay)
	ui.pause_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui.pause_overlay.hide()
	var dim := ColorRect.new()
	ui.pause_overlay.add_child(dim)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(.04, .09, .07, .61)
	var pause := CenterContainer.new()
	ui.pause_overlay.add_child(pause)
	pause.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var paper := PanelContainer.new()
	paper.custom_minimum_size.x = 398
	paper.add_theme_stylebox_override("panel", T.paper())
	pause.add_child(paper)
	var col := column(paper, 10)
	col.add_child(T.label(MAPS.label(current_map), 15, T.SAGE))
	col.add_child(T.label(MAPS.text("Paused", "Tạm dừng"), 31 if MAPS.is_vietnamese() else 44, T.FOREST, not MAPS.is_vietnamese()))
	button(col, MAPS.text("Continue   →", "Tiếp tục   →"), func(): ui.set_pause_menu(false), true)
	button(col, MAPS.text("Settings", "Cài đặt"), func(): open_page("Settings"))
	button(col, MAPS.text("Controls", "Điều khiển"), func(): open_page("Controls"))
	if current_map == MAPS.FOREST and ui.debug_tools:
		button(col, "Atmosphere Studio [test]", func(): open_page("Atmosphere Studio"))
	button(col, MAPS.text("Main menu", "Về menu chính"), func(): ui.enter_title_menu(false))
	button(col, MAPS.text("Quit game", "Thoát game"), func(): ui.get_tree().quit())

	shade = Control.new()
	shade.name = "StorybookPages"
	ui.root_ui.add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.hide()
	var overlay := ColorRect.new()
	shade.add_child(overlay)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(.04, .08, .06, .82)
	build_settings()
	if current_map == MAPS.FOREST:
		build_studio()
	var controls := make_page("Controls", MAPS.text("Controls", "Điều khiển"))
	controls.add_child(T.label(MAPS.label(current_map), 15, T.SAGE))
	controls.add_child(T.label(control_instructions(), 17, T.FOREST))
	add_back_button(controls)

func control_instructions() -> String:
	if current_map == MAPS.OFFICE:
		return MAPS.text(
			"WASD  ·  Walk\nShift  ·  Jog\nMouse  ·  Look around\nE  ·  Interact\nF  ·  Sit or stand\nQ  ·  Check phone\nEsc  ·  Pause or go back",
			"WASD  ·  Đi lại\nShift  ·  Chạy nhẹ\nChuột  ·  Nhìn xung quanh\nE  ·  Tương tác\nF  ·  Ngồi hoặc đứng\nQ  ·  Xem điện thoại\nEsc  ·  Tạm dừng hoặc quay lại"
		)
	if "player" in ui and ui.player!=null and "eyes" in ui.player and ui.player.eyes!=null:
		return MAPS.text("WASD · Walk\nMouse · Look\nShift · Jog\nE · Use\nM · Map outside\nEsc · Close or pause",
			"WASD · Đi\nChuột · Nhìn\nShift · Chạy\nE · Tương tác\nM · Bản đồ ngoài trời\nEsc · Đóng hoặc tạm dừng")
	return MAPS.text(
		"WASD  ·  Walk\nShift  ·  Jog\nMouse wheel  ·  Camera distance\nE  ·  Read, talk or interact\nEsc  ·  Pause or go back",
		"WASD  ·  Đi lại\nShift  ·  Chạy nhẹ\nCuộn chuột  ·  Đổi khoảng cách camera\nE  ·  Đọc, trò chuyện hoặc tương tác\nEsc  ·  Tạm dừng hoặc quay lại"
	)

func open_page(name: String) -> void:
	if not pages.has(name) or (name == "Atmosphere Studio" and not ui.debug_tools):
		return
	if not shade.visible:
		menu_focus = ui.get_viewport().gui_get_focus_owner()
		active_menu().focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
	for page in pages.values():
		page.hide()
	page_name = name
	ui.root_ui.move_child(shade, -1)
	shade.show()
	pages[name].show()
	if name == "Atmosphere Studio":
		for card in studio_cards:
			card.selected = card.get_meta("weather_key") == ui.weather.weather_name
	for control in pages[name].find_children("*", "Control", true, false):
		if control.is_visible_in_tree() and control.focus_mode == Control.FOCUS_ALL:
			control.grab_focus()
			break

func active_menu() -> Control:
	return ui.title_screen if ui.in_title_menu else ui.pause_overlay

func close_page() -> void:
	shade.hide()
	page_name = ""
	active_menu().focus_behavior_recursive = Control.FOCUS_BEHAVIOR_INHERITED

func back() -> void:
	close_page()
	if is_instance_valid(menu_focus) and menu_focus.is_visible_in_tree():
		menu_focus.grab_focus()

func build_settings() -> void:
	var col := make_page("Settings", MAPS.text("Settings", "Cài đặt"))
	var tabs := TabContainer.new()
	tabs.custom_minimum_size = Vector2(600, 221)
	col.add_child(tabs)

	var audio := column(tabs)
	audio.name = MAPS.text("Audio", "Âm thanh")
	var volume_label := T.label("", 17)
	audio.add_child(volume_label)
	var volume := HSlider.new()
	volume.name = "MasterVolume"
	volume.max_value = 1.0
	volume.step = 0.01
	volume.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	volume.custom_minimum_size.y = 42
	audio.add_child(volume)
	var show_volume := func(value: float):
		volume_label.text = MAPS.text("Master volume  ·  %d%%", "Âm lượng chung  ·  %d%%") % roundi(value * 100)
	show_volume.call(volume.value)
	volume.value_changed.connect(func(value: float):
		AudioServer.set_bus_volume_db(0, linear_to_db(maxf(value, 0.0001)))
		AudioServer.set_bus_mute(0, value == 0.0)
		show_volume.call(value)
	)
	if AudioServer.is_bus_mute(0):
		volume.set_value_no_signal(0.0)
		show_volume.call(0.0)

	var graphics := column(tabs)
	graphics.name = MAPS.text("Display", "Hiển thị")
	button(graphics, MAPS.text("Toggle fullscreen", "Bật / tắt toàn màn hình"), toggle_fullscreen)
	if current_map == MAPS.FOREST:
		graphics.add_child(T.label(MAPS.text("Forest grass detail", "Chi tiết cỏ khu rừng"), 17))
		var row := HBoxContainer.new()
		graphics.add_child(row)
		var presets := ButtonGroup.new()
		for entry in [
			["low", MAPS.text("Low", "Thấp")], ["medium", MAPS.text("Medium", "Vừa")],
			["high", MAPS.text("High", "Cao")], ["ultra", MAPS.text("Ultra", "Tối đa")],
		]:
			var quality: String = entry[0]
			var preset := button(row, entry[1], func(): ui.apply_grass_quality(quality))
			preset.toggle_mode = true
			preset.button_group = presets
			preset.button_pressed = ui.current_grass_quality == quality

	var controls := column(tabs)
	controls.name = MAPS.text("Controls", "Điều khiển")
	controls.add_child(T.label(control_instructions(), 16))
	if current_map == MAPS.OFFICE:
		var look := HBoxContainer.new()
		look.add_theme_constant_override("separation", 14)
		controls.add_child(look)
		look.add_child(T.label(MAPS.text("Mouse sensitivity", "Độ nhạy chuột"), 15))
		var sensitivity := HSlider.new()
		sensitivity.name = "OfficeSensitivity"
		sensitivity.min_value = 0.35
		sensitivity.max_value = 2.25
		sensitivity.step = 0.05
		sensitivity.value = ui.camera.sensitivity
		sensitivity.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		look.add_child(sensitivity)
		sensitivity.value_changed.connect(func(value: float):
			ui.camera.sensitivity = value
			ui.get_tree().set_meta(MAPS.LOOK_SENSITIVITY, value)
		)
		var bob := CheckButton.new()
		bob.name = "OfficeHeadBob"
		bob.text = MAPS.text("Gentle walking motion", "Nhún đầu nhẹ khi đi")
		bob.button_pressed = ui.camera.head_bob
		controls.add_child(bob)
		bob.toggled.connect(func(on: bool):
			ui.camera.head_bob = on
			ui.get_tree().set_meta(MAPS.HEAD_BOB, on)
		)

	elif "player" in ui and ui.player!=null and "eyes" in ui.player and ui.player.eyes!=null:
		var eyes: RefCounted = ui.player.eyes
		for row in [["Độ nhạy chuột",&"sensitivity",&"a1_sensitivity",.30,2.4,.05],
			["Góc nhìn dọc (FOV)",&"fov",&"a1_fov",55.0,88.0,1.0]]:
			var line := HBoxContainer.new()
			line.add_child(T.label(row[0],15))
			var slider := HSlider.new()
			slider.min_value = row[3]
			slider.max_value = row[4]
			slider.step = row[5]
			slider.value = eyes.get(row[1])
			slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			slider.value_changed.connect(func(value: float):
				eyes.set(row[1],value)
				ui.get_tree().set_meta(row[2],value))
			line.add_child(slider)
			controls.add_child(line)
		var bob := CheckButton.new()
		bob.text = "Nhún đầu nhẹ khi đi"
		bob.button_pressed = eyes.head_bob
		bob.toggled.connect(func(on: bool):
			eyes.head_bob = on
			ui.get_tree().set_meta(&"a1_head_bob",on))
		controls.add_child(bob)

	var access := column(tabs)
	access.name = MAPS.text("Accessibility", "Trợ năng")
	var quiet := CheckButton.new()
	quiet.text = MAPS.text("Reduce interface motion and sounds", "Giảm hiệu ứng và âm thanh giao diện")
	quiet.button_pressed = reduce_motion
	access.add_child(quiet)
	quiet.toggled.connect(func(on: bool):
		reduce_motion = on
		ui.get_tree().set_meta(MAPS.QUIET_UI, on)
		for card in studio_cards:
			card.reduce_motion = on
	)
	access.add_child(T.label(MAPS.text(
		"Tab or arrows  ·  Move focus\nEnter or Space  ·  Confirm",
		"Tab hoặc phím mũi tên  ·  Chuyển mục\nEnter hoặc Space  ·  Xác nhận"
	), 15, T.SAGE))
	add_back_button(col)

func toggle_fullscreen() -> void:
	var fullscreen := DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if fullscreen else DisplayServer.WINDOW_MODE_FULLSCREEN)

func build_studio() -> void:
	var col := make_page("Atmosphere Studio", "Atmosphere Studio")
	var row:=HBoxContainer.new();row.add_theme_constant_override("separation",20);col.add_child(row)
	ui.pause_time_readout=Label.new();ui.pause_time_readout.hide();col.add_child(ui.pause_time_readout)
	ui.pause_time_slider=preload("res://scripts/ui/daylight_dial.gd").new();ui.pause_time_slider.min_value=0.;ui.pause_time_slider.max_value=23.95;ui.pause_time_slider.step=.05;ui.pause_time_slider.value=16.5
	ui.pause_time_slider.value_changed.connect(ui._on_time_slider_changed);row.add_child(ui.pause_time_slider)
	var choices:=HFlowContainer.new();choices.custom_minimum_size=Vector2(370,230);row.add_child(choices)
	var cards: Array=[]
	for e in [["Sunshine","clear","golden"],["Drifting","partly_cloudy","golden"],["Cloud veil","overcast","overcast"],["Shower","light_rain","rain"],["Downpour","heavy_rain","rain"]]:
		var card=Postcard.new();card.compact=true;card.reduce_motion=reduce_motion;card.title=e[0];card.mood=e[2];choices.add_child(card);cards.append(card)
		var key: String=e[1]
		card.set_meta("weather_key",key);studio_cards.append(card)
		card.pressed.connect(func():
			ui.weather.set_weather(key,false)
			for other in cards:other.selected=other==card
		)
	var freeze:=CheckButton.new();freeze.text="Hold this light";freeze.button_pressed=ui.weather.paused;freeze.toggled.connect(func(on: bool):ui.weather.paused=on);col.add_child(freeze)
	button(col,"Return   ←",back)


func begin_day() -> void:
	if not OS.get_cmdline_user_args().has("--comic-preview"):
		ui.get_tree().change_scene_to_file.call_deferred(MAPS.OFFICE_SCENE)
		return
	var comic := preload("res://scripts/ui/comic_intro.gd").new()
	ui.title_screen.hide()
	ui.root_ui.add_child(comic)
	comic.finished.connect(func():
		comic.queue_free()
		ui.get_tree().change_scene_to_file.call_deferred(MAPS.OFFICE_SCENE)
	, CONNECT_ONE_SHOT)

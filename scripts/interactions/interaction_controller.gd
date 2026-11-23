extends CanvasLayer
## Cozy Forest Post Café UI/UX:
## - Live 3D Scenic Main Menu (when launched as main game scene)
## - Compact non-obstructive Time & Weather HUD badge (fixes hardcoded morning text)
## - Contextual bottom-center interaction prompt pill
## - Stationery letter & conversation modal card (retains panel/heading/body/active API)
## - Cozy Pause, Atmosphere Studio & Quality/Audio Settings menu

const T = preload("res://scripts/ui/storybook_theme.gd")
const MAPS = preload("res://scripts/story/map_flow.gd")
const CozyIcon = preload("res://scripts/ui/cozy_ui_icons.gd")

signal story_closed
var story_choices: VBoxContainer
var story_card: PanelContainer
var story_title: Label
var story_text: Label
var crosshair: Label
var carry_hint: Label
var story_open := false

var player: CharacterBody3D
var camera: Camera3D
var weather: Node
var active: Node3D

# Preserved public references used by regression tests
var panel: PanelContainer
var prompt: Label
var heading: Label
var body: Label
var close_button: Button

# New UI elements
var root_ui: Control
var hud_badge: PanelContainer
var postal_clock: Control
var hud_icon: CozyIcon
var hud_time_label: Label
var hud_weather_label: Label
var controls_hint_panel: PanelContainer
var prompt_card: PanelContainer
var prompt_icon: CozyIcon
var modal_backdrop: ColorRect
var category_label: Label

var title_screen: Control
var pause_overlay: Control
var pause_time_slider: HSlider
var pause_time_readout: Label

var debug_tools:=false
var in_title_menu := false
var mood_tween: Tween
var storybook
var letter_tween: Tween
var notice: Label
var notice_seal: Control
var notice_tween: Tween
var envelope: Control
var envelope_tween: Tween
var in_pause_menu := false
var valley_map: Control
var ui_clock := 0.0
var walk_timer := 0.0
var current_grass_quality := "high"

func _ready() -> void:
	debug_tools=OS.get_cmdline_user_args().has("--atmosphere-debug")
	var hub := get_parent()
	camera = hub.get_node_or_null("GameplayCamera") as Camera3D
	weather = hub.get_node_or_null("ForestWeather")

	root_ui = Control.new()
	root_ui.name = "CozyUiRoot"
	root_ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root_ui)

	root_ui.theme = T.theme()
	storybook=preload("res://scripts/ui/storybook_screens.gd").new(self)
	build_hud()
	build_interaction_prompt()
	build_letter_modal()
	build_story_card()
	if hub.superworld == null:
		valley_map = preload("res://scripts/ui/a1_map.gd").new()
	else:
		valley_map = preload("res://scripts/ui/a1_superworld_map.gd").new()
		valley_map.world = hub.superworld
	valley_map.player = player
	root_ui.add_child(valley_map)
	var saved_grass_quality: String = get_tree().get_meta(MAPS.GRASS_QUALITY, current_grass_quality)
	if saved_grass_quality != current_grass_quality:
		apply_grass_quality(saved_grass_quality)
	build_pause_menu()
	build_title_menu()
	notice=preload("res://scripts/ui/storybook_theme.gd").label("",15,Color("F6E8D0"))
	notice.position=Vector2(72,164)
	root_ui.add_child(notice)
	notice_seal=preload("res://scripts/ui/postal_motif.gd").new();notice_seal.seal=true;notice_seal.position=Vector2(22,152);notice_seal.scale=Vector2(.5,.5);notice_seal.hide();root_ui.add_child(notice_seal)

	for item in get_tree().get_nodes_in_group("interactables"):
		if not item.activated.is_connected(show_message):
			item.activated.connect(show_message.bind(item))

	# Show Scenic Main Menu on interactive game launches; skip automatically in headless/SceneTree test scripts
	var launched_as_main := (get_tree().current_scene == hub)
	var args := OS.get_cmdline_user_args()
	var skip_title := DisplayServer.get_name() == "headless" or args.has("--no-title") \
		or args.has("--lighting=golden_hour") or args.has("--lighting=blue_hour") or args.has("--lighting=baseline")
	if hub.get_meta(MAPS.SHOW_TITLE, launched_as_main and not skip_title):
		enter_title_menu(true)
	else:
		exit_title_menu(true)

func build_hud() -> void:
	hud_badge = PanelContainer.new()
	hud_badge.name = "HudStatusBadge"
	hud_badge.position = Vector2(18, 16)
	hud_badge.custom_minimum_size = Vector2(310, 132)
	hud_badge.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	hud_badge.mouse_filter = Control.MOUSE_FILTER_STOP
	hud_badge.gui_input.connect(_on_hud_badge_clicked)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	hud_badge.add_child(row)

	postal_clock=preload("res://scripts/ui/postal_clock.gd").new()
	row.add_child(postal_clock)
	hud_icon=postal_clock.icon

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 5)
	col.alignment=BoxContainer.ALIGNMENT_CENTER
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(col)

	hud_time_label = Label.new()
	hud_time_label.text = "16:30  •  Golden Hour"
	hud_time_label.add_theme_font_override("font",preload("res://scripts/ui/storybook_theme.gd").HAND)
	hud_time_label.add_theme_font_size_override("font_size", 24)
	hud_time_label.add_theme_color_override("font_color", Color("F7EEDB"))
	col.add_child(hud_time_label)

	hud_weather_label = Label.new()
	hud_weather_label.text = "Drifting Clouds   •   [Esc] Menu"
	hud_weather_label.add_theme_font_size_override("font_size", 12)
	hud_weather_label.add_theme_color_override("font_color", Color("B5CBB4"))
	col.add_child(hud_weather_label)

	var map_label := T.label(MAPS.label(MAPS.FOREST), 12, Color("F7EEDB"))
	col.add_child(map_label)

	for text_label in [hud_time_label, hud_weather_label, map_label]:
		text_label.add_theme_color_override("font_outline_color",Color("253D32"))
		text_label.add_theme_constant_override("outline_size",4)
	root_ui.add_child(hud_badge)
	hud_icon=postal_clock.icon

	# Subtle bottom-right controls micro-bar that gently fades once player explores
	controls_hint_panel = PanelContainer.new()
	controls_hint_panel.name = "ControlsMicroHint"
	controls_hint_panel.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	controls_hint_panel.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	controls_hint_panel.grow_vertical = Control.GROW_DIRECTION_BEGIN
	controls_hint_panel.offset_right = -18
	controls_hint_panel.offset_bottom = -16
	controls_hint_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	controls_hint_panel.add_theme_stylebox_override("panel", make_card_style(Color(0.13, 0.21, 0.17, 0.74), Color(0.72, 0.51, 0.33, 0.55), 10, 1, 12, 6))
	var hint_lbl := Label.new()
	hint_lbl.text = "WASD Đi · Chuột Nhìn · E Dùng · Shift Chạy · Esc Menu" if player.eyes!=null else \
		"WASD Move   •   Shift Jog   •   E Interact   •   Wheel Zoom   •   Esc Menu"
	hint_lbl.add_theme_font_size_override("font_size", 12)
	hint_lbl.add_theme_color_override("font_color", Color("EAE0CE"))
	controls_hint_panel.add_child(hint_lbl)
	root_ui.add_child(controls_hint_panel)

func build_interaction_prompt() -> void:
	prompt_card = PanelContainer.new()
	prompt_card.name = "InteractionPromptCard"
	prompt_card.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	prompt_card.grow_horizontal = Control.GROW_DIRECTION_BOTH
	prompt_card.grow_vertical = Control.GROW_DIRECTION_BEGIN
	prompt_card.offset_bottom = -34
	prompt_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	prompt_card.add_theme_stylebox_override("panel", make_card_style(Color(0.14, 0.23, 0.19, 0.93), Color("D5A06A"), 18, 2, 16, 9))

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	prompt_card.add_child(row)

	var key_badge := PanelContainer.new()
	key_badge.custom_minimum_size=Vector2(38,38)
	key_badge.add_theme_stylebox_override("panel", make_card_style(Color("B88254"), Color("F6E8D0"), 19, 1, 4, 4))
	var key_lbl := Label.new()
	key_lbl.text = "E"
	key_lbl.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	key_lbl.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
	key_lbl.add_theme_font_size_override("font_size", 14)
	key_lbl.add_theme_color_override("font_color", Color("FFF8EB"))
	key_badge.add_child(key_lbl)
	row.add_child(key_badge)

	prompt_icon = CozyIcon.new("envelope", Vector2(22, 22))
	row.add_child(prompt_icon)

	prompt = Label.new()
	prompt.add_theme_font_size_override("font_size", 16)
	prompt.add_theme_color_override("font_color", Color("F8EFE0"))
	row.add_child(prompt)

	root_ui.add_child(prompt_card)
	prompt_card.hide()
	carry_hint = T.label("",15,Color("F5E4CA"))
	carry_hint.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	carry_hint.offset_left = -235
	carry_hint.offset_right = 235
	carry_hint.offset_top = -29
	carry_hint.offset_bottom = -7
	carry_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	carry_hint.add_theme_color_override("font_outline_color",Color("271D19"))
	carry_hint.add_theme_constant_override("outline_size",5)
	carry_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root_ui.add_child(carry_hint)
	carry_hint.hide()

func build_letter_modal() -> void:
	modal_backdrop = ColorRect.new()
	modal_backdrop.name = "ModalBackdrop"
	modal_backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	modal_backdrop.color = Color(0.07, 0.11, 0.09, 0.44)
	modal_backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	modal_backdrop.hide()
	root_ui.add_child(modal_backdrop)

	panel = PanelContainer.new()
	panel.name = "LetterDialoguePanel"
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	panel.custom_minimum_size = Vector2(620, 330)
	panel.offset_left=-310;panel.offset_top=-165;panel.offset_right=310;panel.offset_bottom=165
	panel.add_theme_stylebox_override("panel",preload("res://scripts/ui/storybook_theme.gd").paper())

	panel.add_child(preload("res://scripts/ui/letter_stationery.gd").new())
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 14)
	panel.add_child(column)

	var header_row := HBoxContainer.new()
	header_row.add_theme_constant_override("separation", 10)
	column.add_child(header_row)

	var seal := preload("res://scripts/ui/postal_motif.gd").new()
	seal.seal=true
	seal.name = "ModalIcon"
	header_row.add_child(seal)

	category_label = Label.new()
	category_label.text = "FOREST POST  /  A LETTER FOR YOU"
	category_label.add_theme_font_size_override("font_size", 12)
	category_label.add_theme_color_override("font_color", Color("A8584C"))
	header_row.add_child(category_label)

	heading = Label.new()
	heading.add_theme_font_override("font",preload("res://scripts/ui/storybook_theme.gd").HAND)
	heading.add_theme_font_size_override("font_size", 27)
	heading.add_theme_color_override("font_color", Color("2B241D"))
	heading.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(heading)

	var divider := ColorRect.new()
	divider.custom_minimum_size = Vector2(0, 2)
	divider.color = Color(0.72, 0.51, 0.33, 0.38)
	column.add_child(divider)

	body = Label.new()
	body.add_theme_font_size_override("font_size", 16)
	body.add_theme_color_override("font_color", Color("3E342A"))
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.custom_minimum_size = Vector2(540, 90)
	column.add_child(body)

	var footer := HBoxContainer.new()
	footer.alignment = BoxContainer.ALIGNMENT_END
	column.add_child(footer)

	close_button=preload("res://scripts/ui/wax_close_button.gd").new()
	close_button.text="Put away"
	close_button.pressed.connect(close)
	footer.add_child(close_button)

	var stationery=preload("res://scripts/ui/letter_stationery.gd").new()
	panel.add_child(stationery);panel.move_child(stationery,0)
	root_ui.add_child(panel)
	panel.hide()
	envelope=preload("res://scripts/ui/envelope_reveal.gd").new()
	envelope.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);envelope.hide();root_ui.add_child(envelope)

func build_story_card() -> void:
	story_card = PanelContainer.new()
	story_card.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	story_card.grow_vertical = Control.GROW_DIRECTION_BEGIN
	story_card.offset_left = 32
	story_card.offset_right = 460
	story_card.offset_bottom = -25
	story_card.add_theme_stylebox_override("panel",make_card_style(Color(.10,.17,.14,.94),Color("BFA279"),9,1,18,12))
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation",7)
	story_card.add_child(column)
	story_title = T.label("",20,Color("F7DCB7"))
	column.add_child(story_title)
	story_text = T.label("",16,Color("ECE8D8"))
	story_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(story_text)
	story_choices = VBoxContainer.new()
	column.add_child(story_choices)
	root_ui.add_child(story_card)
	story_card.hide()
	crosshair = T.label("·",28,Color("F6E7CA"))
	crosshair.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	crosshair.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	crosshair.set_anchors_preset(Control.PRESET_CENTER)
	crosshair.offset_left = -15
	crosshair.offset_right = 15
	crosshair.offset_top = -18
	crosshair.offset_bottom = 18
	crosshair.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root_ui.add_child(crosshair)
	crosshair.hide()

func build_title_menu() -> void:
	storybook.build_title()

func build_pause_menu() -> void:
	storybook.build_pause()

func enter_title_menu(instant := false) -> void:
	storybook.close_page()
	in_title_menu = true
	in_pause_menu = false
	pause_overlay.hide()
	panel.hide()
	modal_backdrop.hide()
	prompt_card.hide()
	hud_badge.hide()
	controls_hint_panel.hide()
	title_screen.show()
	title_screen.find_child("BeginDay",true,false).grab_focus()
	if player != null:
		player.blocked = true
		player.visible=false
	if camera != null and camera.has_method("set_scenic_mode"):
		camera.set_scenic_mode(true, instant or storybook.reduce_motion)

func exit_title_menu(instant := false) -> void:
	in_title_menu = false
	title_screen.hide()
	hud_badge.show()
	controls_hint_panel.show()
	controls_hint_panel.modulate.a = 1.0
	walk_timer = 0.0
	if player!=null:player.visible=true
	if player != null and not panel.visible and not in_pause_menu:
		player.blocked = false
	if camera != null and camera.has_method("set_scenic_mode"):
		camera.set_scenic_mode(false, instant or storybook.reduce_motion)

func set_pause_menu(open: bool) -> void:
	if in_title_menu:
		return
	storybook.close_page()
	in_pause_menu = open
	pause_overlay.visible = open
	if open:
		var buttons=pause_overlay.find_children("*","Button",true,false)
		if not buttons.is_empty():buttons[0].grab_focus()
		prompt_card.hide()
		if weather != null:
			pause_time_slider.set_value_no_signal(weather.hours)
			pause_time_readout.text = format_clock(weather.hours)
		if player != null:
			player.blocked = true
	else:
		if player != null and not panel.visible:
			player.blocked = false

func apply_mood(h: float, w_name: String) -> void:
	if weather != null:
		if mood_tween!=null:mood_tween.kill()
		weather.set_weather(w_name,false)
		mood_tween=create_tween()
		mood_tween.tween_method(func(value: float):weather.set_time(value),weather.hours,h,2.).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func apply_grass_quality(quality: String) -> void:
	current_grass_quality = quality
	get_tree().set_meta(MAPS.GRASS_QUALITY, quality)
	var meadow := get_parent().get_node_or_null("CuratedGroundCover/DenseMeadow")
	if meadow != null:
		meadow.settings = load("res://environment/vegetation/presets/" + quality + ".tres")
		meadow.regenerate()

func _on_time_slider_changed(val: float) -> void:
	if weather != null:
		weather.set_time(val)
	pause_time_readout.text = format_clock(val)

func _on_hud_badge_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not panel.visible and not in_title_menu:
			set_pause_menu(not in_pause_menu)

func _process(delta: float) -> void:
	if notice_seal!=null:
		notice.visible=not in_title_menu
		notice_seal.visible=not in_title_menu and not notice.text.is_empty() and notice.modulate.a>.01
		notice_seal.modulate.a=notice.modulate.a
	ui_clock += delta
	update_hud_status()

	if player != null and not in_title_menu:
		walk_timer += delta
		if walk_timer > 7.5:
			controls_hint_panel.modulate.a = move_toward(controls_hint_panel.modulate.a, 0.0, delta * 0.45)

	var looking: bool = player!=null and player.eyes!=null and not player.blocked and not story_open and not in_title_menu and not in_pause_menu
	crosshair.visible = looking
	var prototype: Node = get_parent().story_prototype
	var held := ""
	if looking and prototype!=null and prototype.inside and not panel.visible:
		held = prototype.house.items.carry_label()
	carry_hint.visible = not held.is_empty()
	if carry_hint.visible:
		carry_hint.text = "Đang cầm %s  ·  R đặt lại chỗ vừa nhặt" % held
	if player!=null and player.eyes!=null and DisplayServer.get_name()!="headless":
		var mode := Input.MOUSE_MODE_CAPTURED if looking else Input.MOUSE_MODE_VISIBLE
		if mode!=Input.mouse_mode:
			Input.mouse_mode = mode
	active = null
	if looking:
		var camera_now := player.get_viewport().get_camera_3d()
		if camera_now!=null:
			active = player.eyes.select(camera_now,player)
	elif player != null and not player.blocked and not in_title_menu and not in_pause_menu:
		var nearest := INF
		for item in get_tree().get_nodes_in_group("interactables"):
			if item.get_viewport()!=player.get_viewport():
				continue
			var d: float = player.global_position.distance_to(item.global_position)
			if d < item.interaction_radius and d < nearest:
				active = item
				nearest = d

	var show_prompt := active != null and not valley_map.visible and not (panel.visible or story_open) and not in_title_menu and not in_pause_menu
	prompt.text = "E  •  " + active.interaction_name if show_prompt else ""
	prompt_card.visible = show_prompt
	if show_prompt:
		prompt.text = active.interaction_name
		prompt_icon.icon_kind = icon_for_item(active)
		prompt_card.offset_bottom = -34.0 if storybook.reduce_motion else -34.0 + sin(ui_clock * 3.4) * 2.5

func update_hud_status() -> void:
	if weather == null:
		return
	var h: float = weather.hours
	var period: String = weather.time_period_label() if weather.has_method("time_period_label") else "Golden Hour"
	var w_label: String = weather.weather_display_label() if weather.has_method("weather_display_label") else "Calm Air"
	hud_time_label.text = period
	postal_clock.hours=h
	postal_clock.queue_redraw()
	hud_weather_label.text = w_label
	if in_pause_menu:
		pause_time_readout.text = format_clock(h)
		if not pause_time_slider.dragging:pause_time_slider.set_value_no_signal(h)

	var w_name: String = weather.weather_name
	var desired_icon := "sun"
	if w_name in ["light_rain", "heavy_rain"]:
		desired_icon = "rain"
	elif w_name == "overcast":
		desired_icon = "overcast"
	elif h < 5.2 or h >= 19.8:
		desired_icon = "moon"
	elif h < 7.2 or (h >= 16.8 and h < 19.8):
		desired_icon = "dawn_dusk"
	elif w_name == "partly_cloudy":
		desired_icon = "partly_cloudy"
	if hud_icon.icon_kind != desired_icon:
		hud_icon.icon_kind = desired_icon

func format_clock(h: float) -> String:
	var wrapped := fposmod(h, 24.0)
	var hh := int(floorf(wrapped))
	var mm := int(floorf((wrapped - float(hh)) * 60.0))
	return "%02d:%02d" % [hh, mm]

func icon_for_item(item: Node) -> String:
	if item.has_meta("physical_prop"):
		return "hand"
	var n: String = str(item.get("interaction_name")).to_lower()
	if "talk" in n or "chat" in n or "eggeght" in n or "nói chuyện" in n:
		return "chat"
	elif "sign" in n or "trail" in n or "board" in n:
		return "signpost"
	return "envelope"

func _unhandled_input(event: InputEvent) -> void:
	var prototype: Node = get_parent().story_prototype
	if prototype!=null and prototype.intro_running:
		if event.is_action_pressed("ui_cancel"):
			prototype.skip_intro()
		get_viewport().set_input_as_handled()
		return
	if event is InputEventMouseMotion and player.eyes!=null and not player.blocked and Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
		player.eyes.turn(event.screen_relative)
		get_viewport().set_input_as_handled()
		return
	var map_key: bool = event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_M
	if valley_map.visible:
		if map_key or event.is_action_pressed("ui_cancel"):
			valley_map.hide()
			player.blocked = false
		elif event is InputEventKey and event.pressed and not event.echo:
			if event.keycode == KEY_HOME:
				valley_map.center_on_player()
			elif event.keycode == KEY_TAB and valley_map.has_method("toggle_atlas"):
				valley_map.toggle_atlas()
			elif event.keycode == KEY_F7 and valley_map.has_method("toggle_chunks"):
				valley_map.toggle_chunks()
		get_viewport().set_input_as_handled()
		return
	if map_key and (prototype==null or not prototype.inside) and not in_title_menu and not in_pause_menu and not panel.visible and not story_open:
		player.blocked = true
		valley_map.show()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("ui_cancel"):
		if storybook.shade.visible:
			storybook.back()
		elif panel.visible or story_open:
			close()
		elif in_pause_menu:
			set_pause_menu(false)
		elif not in_title_menu:
			set_pause_menu(true)
	elif prototype!=null and prototype.inside and event is InputEventKey and event.pressed and not event.echo \
			and event.physical_keycode==KEY_R and not player.blocked and not panel.visible and not story_open and not in_title_menu and not in_pause_menu:
		prototype.house.items.put_back()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("interact") and not event.is_echo() and active != null and not player.blocked and not panel.visible and not story_open and not in_title_menu and not in_pause_menu:
		active.interact()

func show_message(title: String, message: String, source_item: Node = null) -> void:
	story_choices.hide()
	heading.text = title
	body.text = message
	if source_item != null:
		var kind := icon_for_item(source_item)
		var icon_node := panel.find_child("ModalIcon", true, false) as CozyIcon
		if icon_node != null:
			icon_node.icon_kind = kind
		if "category" in source_item:
			category_label.text = source_item.category
		elif kind == "chat":
			category_label.text = "WOODLAND NEIGHBOR"
		elif kind == "signpost":
			category_label.text = "TRAIL & CAFÉ GUIDE"
		else:
			category_label.text = "POSTAL DISPATCH"
	else:
		category_label.text = "POSTAL DISPATCH"
	modal_backdrop.show()
	panel.show()
	if envelope_tween!=null:envelope_tween.kill()
	envelope.hide()
	if not storybook.reduce_motion and (source_item==null or icon_for_item(source_item)=="envelope"):
		root_ui.move_child(envelope,-1);envelope.progress=0.;envelope.modulate.a=1.;envelope.show()
		envelope_tween=create_tween()
		envelope_tween.tween_property(envelope,"progress",1.,.32)
		envelope_tween.tween_property(envelope,"modulate:a",0.,.20)
		envelope_tween.tween_callback(envelope.hide)

	if letter_tween!=null:letter_tween.kill()
	body.visible_ratio=0.0 if not storybook.reduce_motion else 1.0
	panel.pivot_offset=panel.size*.5
	panel.scale=Vector2.ONE if storybook.reduce_motion else Vector2(.95,.95)
	letter_tween=create_tween().set_parallel(true)
	letter_tween.tween_property(panel,"scale",Vector2.ONE,.25)
	letter_tween.tween_property(body,"visible_ratio",1.0,0.8 if not storybook.reduce_motion else 0.0)

	if player != null:
		player.blocked = true
	close_button.grab_focus()

func show_story(title: String, message: String, options: Array) -> void:
	story_open = true
	story_title.text = title
	story_text.text = message
	for child in story_choices.get_children():
		story_choices.remove_child(child)
		child.queue_free()
	for option in options:
		var button := make_cozy_button(option.label,false)
		button.pressed.connect(option.action)
		story_choices.add_child(button)
	story_choices.show()
	story_card.show()
	player.blocked = true
	if story_choices.get_child_count()>0:
		story_choices.get_child(0).grab_focus()

func story_notice(message: String) -> void:
	notice.text = message
	notice.modulate.a = 1.0
	if notice_tween!=null:
		notice_tween.kill()
	notice_tween = create_tween()
	notice_tween.tween_interval(3.5)
	notice_tween.tween_property(notice,"modulate:a",0.0,.45)

func close() -> void:
	var was_open:=panel.visible
	if story_open:
		story_open = false
		story_card.hide()
		if not in_pause_menu and not in_title_menu:
			player.blocked = false
		story_closed.emit()
		return
	if envelope_tween!=null:envelope_tween.kill()
	if envelope!=null:envelope.hide()
	if panel.visible and notice!=null:
		notice.text="Correspondence put away  ·  Have a gentle day."
		notice.modulate.a=1.
		if notice_tween!=null:notice_tween.kill()
		notice_tween=create_tween()
		notice_tween.tween_interval(2.0)
		notice_tween.tween_property(notice,"modulate:a",0.,.5)
	panel.hide()
	modal_backdrop.hide()
	if was_open and not storybook.reduce_motion and DisplayServer.get_name()!="headless":
		envelope.progress=1.;envelope.modulate.a=1.;envelope.show()
		envelope_tween=create_tween()
		envelope_tween.tween_property(envelope,"progress",0.,.20)
		envelope_tween.tween_property(envelope,"modulate:a",0.,.12)
		envelope_tween.tween_callback(envelope.hide)
	if player != null and not in_pause_menu and not in_title_menu:
		player.blocked = false

func make_card_style(bg: Color, border: Color, radius: int, border_w: int, pad_x: int, pad_y: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(border_w)
	s.set_corner_radius_all(radius)
	s.content_margin_left = pad_x
	s.content_margin_right = pad_x
	s.content_margin_top = pad_y
	s.content_margin_bottom = pad_y
	s.shadow_color = Color(0.04, 0.07, 0.05, 0.32)
	s.shadow_size = 8
	s.shadow_offset = Vector2(0, 3)
	return s

func make_cozy_button(label_text: String, primary: bool) -> Button:
	var b := Button.new()
	b.text = label_text
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.add_theme_font_size_override("font_size", 15 if primary else 14)
	var normal_bg := Color("B88254") if primary else Color(0.20, 0.31, 0.25, 0.95)
	var hover_bg := Color("C99262") if primary else Color(0.26, 0.39, 0.32, 0.98)
	var border := Color("F5E6CC") if primary else Color("8B7355")
	b.add_theme_color_override("font_color", Color("FFF9EE") if primary else Color("EAE0CE"))
	b.add_theme_color_override("font_hover_color", Color("FFFFFF"))
	b.add_theme_color_override("font_focus_color", Color("FFF9EE"))
	b.add_theme_stylebox_override("normal", make_card_style(normal_bg, border, 10, 1, 16, 9))
	b.add_theme_stylebox_override("hover", make_card_style(hover_bg, Color("F6E8D0"), 10, 2, 16, 9))
	b.add_theme_stylebox_override("pressed", make_card_style(normal_bg.darkened(0.12), Color("F6E8D0"), 10, 2, 16, 9))
	b.add_theme_stylebox_override("focus", make_card_style(hover_bg, Color("F6E8D0"), 10, 2, 16, 9))
	return b

func _exit_tree() -> void:
	if is_instance_valid(player) and player.eyes!=null and DisplayServer.get_name()!="headless":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

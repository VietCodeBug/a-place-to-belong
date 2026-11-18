extends CanvasLayer
## Cozy Forest Post Café UI/UX:
## - Live 3D Scenic Main Menu (when launched as main game scene)
## - Compact non-obstructive Time & Weather HUD badge (fixes hardcoded morning text)
## - Contextual bottom-center interaction prompt pill
## - Stationery letter & conversation modal card (retains panel/heading/body/active API)
## - Cozy Pause, Atmosphere Studio & Quality/Audio Settings menu

const CozyIcon = preload("res://scripts/ui/cozy_ui_icons.gd")

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
var hud_icon: CozyIcon
var hud_time_label: Label
var hud_weather_label: Label
var controls_hint_panel: PanelContainer
var prompt_card: PanelContainer
var prompt_icon: CozyIcon
var modal_backdrop: ColorRect
var category_label: Label

var title_screen: Control
var settings_box: VBoxContainer
var pause_overlay: Control
var pause_time_slider: HSlider
var pause_time_readout: Label
var grass_buttons: Dictionary = {}
var volume_slider: HSlider

var in_title_menu := false
var mood_tween: Tween
var in_pause_menu := false
var ui_clock := 0.0
var walk_timer := 0.0
var current_grass_quality := "high"

func _ready() -> void:
	var hub := get_parent()
	camera = hub.get_node_or_null("GameplayCamera") as Camera3D
	weather = hub.get_node_or_null("ForestWeather")

	root_ui = Control.new()
	root_ui.name = "CozyUiRoot"
	root_ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root_ui)

	build_hud()
	build_interaction_prompt()
	build_letter_modal()
	build_pause_menu()
	build_title_menu()

	for item in get_tree().get_nodes_in_group("interactables"):
		if not item.activated.is_connected(show_message):
			item.activated.connect(show_message.bind(item))

	# Show Scenic Main Menu on interactive game launches; skip automatically in headless/SceneTree test scripts
	var launched_as_main := (get_tree().current_scene == hub)
	var skip_title := DisplayServer.get_name() == "headless" or OS.get_cmdline_user_args().has("--no-title") or OS.get_cmdline_user_args().has("--lighting=golden_hour") or OS.get_cmdline_user_args().has("--lighting=blue_hour") or OS.get_cmdline_user_args().has("--lighting=baseline")
	if launched_as_main and not skip_title:
		enter_title_menu(true)
	else:
		exit_title_menu(true)

func build_hud() -> void:
	hud_badge = PanelContainer.new()
	hud_badge.name = "HudStatusBadge"
	hud_badge.position = Vector2(18, 16)
	hud_badge.custom_minimum_size = Vector2(246, 56)
	hud_badge.add_theme_stylebox_override("panel", make_card_style(Color(0.13, 0.21, 0.17, 0.88), Color("B88254"), 14, 2, 14, 10))
	hud_badge.mouse_filter = Control.MOUSE_FILTER_STOP
	hud_badge.gui_input.connect(_on_hud_badge_clicked)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	hud_badge.add_child(row)

	hud_icon = CozyIcon.new("partly_cloudy", Vector2(34, 34))
	row.add_child(hud_icon)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 1)
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(col)

	hud_time_label = Label.new()
	hud_time_label.text = "16:30  •  Golden Hour"
	hud_time_label.add_theme_font_size_override("font_size", 15)
	hud_time_label.add_theme_color_override("font_color", Color("F7EEDB"))
	col.add_child(hud_time_label)

	hud_weather_label = Label.new()
	hud_weather_label.text = "Drifting Clouds   •   [Esc] Menu"
	hud_weather_label.add_theme_font_size_override("font_size", 12)
	hud_weather_label.add_theme_color_override("font_color", Color("B5CBB4"))
	col.add_child(hud_weather_label)

	root_ui.add_child(hud_badge)

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
	hint_lbl.text = "WASD Move   •   Shift Jog   •   E Interact   •   Wheel Zoom   •   Esc Menu"
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
	key_badge.add_theme_stylebox_override("panel", make_card_style(Color("B88254"), Color("F6E8D0"), 7, 1, 8, 2))
	var key_lbl := Label.new()
	key_lbl.text = "E"
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
	panel.custom_minimum_size = Vector2(540, 250)
	panel.add_theme_stylebox_override("panel", make_card_style(Color("F6ECD8"), Color("8F623D"), 16, 4, 30, 24))

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 14)
	panel.add_child(column)

	var header_row := HBoxContainer.new()
	header_row.add_theme_constant_override("separation", 10)
	column.add_child(header_row)

	var seal := CozyIcon.new("envelope", Vector2(28, 28))
	seal.name = "ModalIcon"
	header_row.add_child(seal)

	category_label = Label.new()
	category_label.text = "POSTAL DISPATCH"
	category_label.add_theme_font_size_override("font_size", 12)
	category_label.add_theme_color_override("font_color", Color("A8584C"))
	header_row.add_child(category_label)

	heading = Label.new()
	heading.add_theme_font_size_override("font_size", 24)
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
	body.custom_minimum_size = Vector2(460, 64)
	column.add_child(body)

	var footer := HBoxContainer.new()
	footer.alignment = BoxContainer.ALIGNMENT_END
	column.add_child(footer)

	close_button = make_cozy_button("Put Away  [Esc]", true)
	close_button.pressed.connect(close)
	footer.add_child(close_button)

	root_ui.add_child(panel)
	panel.hide()

func build_title_menu() -> void:
	title_screen = Control.new()
	title_screen.name = "ScenicTitleScreen"
	title_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	title_screen.mouse_filter = Control.MOUSE_FILTER_STOP
	root_ui.add_child(title_screen)

	# Left cozy timber & parchment menu plaque leaving the 3D cafe open on the right
	var card := PanelContainer.new()
	card.set_anchors_preset(Control.PRESET_CENTER_LEFT)
	card.grow_vertical = Control.GROW_DIRECTION_BOTH
	card.offset_left = 42
	card.custom_minimum_size = Vector2(396, 0)
	card.add_theme_stylebox_override("panel", make_card_style(Color(0.13, 0.21, 0.17, 0.92), Color("C69260"), 18, 3, 26, 24))
	title_screen.add_child(card)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 13)
	card.add_child(col)

	var brand_row := HBoxContainer.new()
	brand_row.add_theme_constant_override("separation", 12)
	col.add_child(brand_row)

	brand_row.add_child(CozyIcon.new("coffee_post", Vector2(44, 44)))

	var title_col := VBoxContainer.new()
	title_col.add_theme_constant_override("separation", 1)
	brand_row.add_child(title_col)

	var eyebrow := Label.new()
	eyebrow.text = "WOODLAND POST & MORNING ROAST"
	eyebrow.add_theme_font_size_override("font_size", 11)
	eyebrow.add_theme_color_override("font_color", Color("D7A976"))
	title_col.add_child(eyebrow)

	var game_title := Label.new()
	game_title.text = "Forest Post Café"
	game_title.add_theme_font_size_override("font_size", 36)
	game_title.add_theme_color_override("font_color", Color("F8EFE0"))
	title_col.add_child(game_title)

	var tagline := Label.new()
	tagline.text = "Warm coffee. Unhurried letters.\nA little forest worth getting lost in."
	tagline.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tagline.add_theme_font_size_override("font_size", 13)
	tagline.add_theme_color_override("font_color", Color("C7D6C5"))
	col.add_child(tagline)

	var sep := ColorRect.new()
	sep.custom_minimum_size = Vector2(0, 1)
	sep.color = Color(0.78, 0.58, 0.38, 0.35)
	col.add_child(sep)

	var start_btn := make_cozy_button("▶   Enter the Clearing", true)
	start_btn.custom_minimum_size.y = 44
	start_btn.pressed.connect(func(): exit_title_menu(false))
	col.add_child(start_btn)

	# Live Atmosphere Mood preview right on the scenic title screen
	var mood_lbl := Label.new()
	mood_lbl.text = "CHOOSE YOUR MOMENT"
	mood_lbl.add_theme_font_size_override("font_size", 12)
	mood_lbl.add_theme_color_override("font_color", Color("D8CBB5"))
	col.add_child(mood_lbl)

	var mood_row := HFlowContainer.new()
	mood_row.add_theme_constant_override("h_separation", 6)
	mood_row.add_theme_constant_override("v_separation", 6)
	col.add_child(mood_row)

	for preset in [["Honey light",16.7,"partly_cloudy","golden"],["Forest rain",15.2,"heavy_rain","rain"],["Firefly dusk",21.5,"clear","night"]]:
		var card_button=preload("res://scripts/ui/atmosphere_postcard.gd").new()
		card_button.title=preset[0];card_button.mood=preset[3]
		var h_val: float=preset[1];var w_val: String=preset[2]
		card_button.pressed.connect(func():apply_mood(h_val,w_val))
		mood_row.add_child(card_button)

	var settings_toggle := make_cozy_button("⚙   Quality & Sound", false)
	settings_toggle.pressed.connect(func(): settings_box.visible = not settings_box.visible)
	col.add_child(settings_toggle)

	settings_box = build_shared_settings_box()
	settings_box.hide()
	col.add_child(settings_box)

	var quit_btn := make_cozy_button("Leave Forest", false)
	quit_btn.pressed.connect(func(): get_tree().quit())
	col.add_child(quit_btn)

func build_pause_menu() -> void:
	pause_overlay = Control.new()
	pause_overlay.name = "CozyPauseMenu"
	pause_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pause_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	pause_overlay.hide()
	root_ui.add_child(pause_overlay)

	var dim := ColorRect.new()
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0.06, 0.10, 0.08, 0.50)
	pause_overlay.add_child(dim)

	var card := PanelContainer.new()
	card.set_anchors_preset(Control.PRESET_CENTER)
	card.grow_horizontal = Control.GROW_DIRECTION_BOTH
	card.grow_vertical = Control.GROW_DIRECTION_BOTH
	card.custom_minimum_size = Vector2(640, 490)
	card.offset_left=-320;card.offset_top=-245;card.offset_right=320;card.offset_bottom=245
	card.add_theme_stylebox_override("panel", make_card_style(Color(0.13, 0.21, 0.17, 0.95), Color("C69260"), 18, 3, 28, 24))
	pause_overlay.add_child(card)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 12)
	var scroll:=ScrollContainer.new();scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;card.add_child(scroll)
	col.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	scroll.add_child(col)

	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 10)
	col.add_child(head)
	head.add_child(CozyIcon.new("coffee_post", Vector2(32, 32)))
	var title := Label.new()
	title.text = "Café Break & Atmosphere"
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color("F8EFE0"))
	head.add_child(title)

	var resume_btn := make_cozy_button("Resume Shift   [Esc]", true)
	resume_btn.pressed.connect(func(): set_pause_menu(false))
	col.add_child(resume_btn)

	var atlas:=HBoxContainer.new();atlas.add_theme_constant_override("separation",16);col.add_child(atlas)
	var clock_column:=VBoxContainer.new();atlas.add_child(clock_column)
	pause_time_readout=Label.new();pause_time_readout.hide();clock_column.add_child(pause_time_readout)
	pause_time_slider=preload("res://scripts/ui/daylight_dial.gd").new()
	pause_time_slider.min_value=0.;pause_time_slider.max_value=23.95;pause_time_slider.step=.05;pause_time_slider.value=16.5
	pause_time_slider.value_changed.connect(_on_time_slider_changed);clock_column.add_child(pause_time_slider)
	var weather_cards:=HFlowContainer.new();weather_cards.custom_minimum_size=Vector2(320,220);atlas.add_child(weather_cards)
	weather_cards.add_theme_constant_override("h_separation",8);weather_cards.add_theme_constant_override("v_separation",8)
	for entry in [["Sunshine","clear","golden"],["Drifting","partly_cloudy","golden"],["Cloud veil","overcast","overcast"],["Shower","light_rain","rain"],["Downpour","heavy_rain","rain"]]:
		var choice=preload("res://scripts/ui/atmosphere_postcard.gd").new();choice.compact=true;choice.title=entry[0];choice.mood=entry[2]
		var weather_key: String=entry[1]
		choice.pressed.connect(func():weather.set_weather(weather_key,false))
		weather_cards.add_child(choice)

	var extras:=build_shared_settings_box();extras.hide()
	var options:=make_cozy_button("Sound & display",false)
	options.pressed.connect(func():extras.visible=not extras.visible)
	col.add_child(options);col.add_child(extras)

	var bottom_row := HBoxContainer.new()
	bottom_row.add_theme_constant_override("separation", 10)
	col.add_child(bottom_row)

	var title_btn := make_cozy_button("Scenic Title View", false)
	title_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_btn.pressed.connect(func():
		set_pause_menu(false)
		enter_title_menu(false)
	)
	bottom_row.add_child(title_btn)

	var quit_btn := make_cozy_button("Quit Game", false)
	quit_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	quit_btn.pressed.connect(func(): get_tree().quit())
	bottom_row.add_child(quit_btn)

func build_shared_settings_box() -> VBoxContainer:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)

	var g_lbl := Label.new()
	g_lbl.text = "Scenery detail"
	g_lbl.add_theme_font_size_override("font_size", 12)
	g_lbl.add_theme_color_override("font_color", Color("D8CBB5"))
	box.add_child(g_lbl)

	var q_row := HBoxContainer.new()
	q_row.add_theme_constant_override("separation", 6)
	box.add_child(q_row)
	for q in ["low", "medium", "high", "ultra"]:
		var qb := make_chip_button(q.capitalize())
		qb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var q_name: String = q
		qb.pressed.connect(func(): apply_grass_quality(q_name))
		q_row.add_child(qb)

	var v_row := HBoxContainer.new()
	v_row.add_theme_constant_override("separation", 10)
	box.add_child(v_row)
	var v_lbl := Label.new()
	v_lbl.text = "Forest Ambience"
	v_lbl.add_theme_font_size_override("font_size", 12)
	v_lbl.add_theme_color_override("font_color", Color("D8CBB5"))
	v_row.add_child(v_lbl)

	var sld := HSlider.new()
	sld.min_value = 0.0
	sld.max_value = 1.0
	sld.step = 0.05
	sld.value = 0.85
	sld.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sld.value_changed.connect(func(val: float):
		if weather != null and weather.get("ambience") != null and weather.ambience != null:
			weather.ambience.master_volume = val
	)
	v_row.add_child(sld)

	var opt_row := HBoxContainer.new()
	opt_row.add_theme_constant_override("separation", 8)
	box.add_child(opt_row)

	var pause_clock_btn := make_chip_button("Freeze Sun Clock")
	pause_clock_btn.toggle_mode = true
	pause_clock_btn.toggled.connect(func(on: bool):
		if weather != null:
			weather.paused = on
	)
	opt_row.add_child(pause_clock_btn)

	var fs_btn := make_chip_button("Toggle Fullscreen")
	fs_btn.pressed.connect(func():
		var mode := DisplayServer.window_get_mode()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if mode == DisplayServer.WINDOW_MODE_FULLSCREEN else DisplayServer.WINDOW_MODE_FULLSCREEN)
	)
	opt_row.add_child(fs_btn)
	return box

func enter_title_menu(instant := false) -> void:
	in_title_menu = true
	in_pause_menu = false
	pause_overlay.hide()
	panel.hide()
	modal_backdrop.hide()
	prompt_card.hide()
	hud_badge.hide()
	controls_hint_panel.hide()
	title_screen.show()
	if player != null:
		player.blocked = true
		player.visible=false
	if camera != null and camera.has_method("set_scenic_mode"):
		camera.set_scenic_mode(true, instant)

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
		camera.set_scenic_mode(false, instant)

func set_pause_menu(open: bool) -> void:
	if in_title_menu:
		return
	in_pause_menu = open
	pause_overlay.visible = open
	if open:
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
	ui_clock += delta
	update_hud_status()

	if player != null and player.state == "walking" and not in_title_menu:
		walk_timer += delta
		if walk_timer > 7.5:
			controls_hint_panel.modulate.a = move_toward(controls_hint_panel.modulate.a, 0.0, delta * 0.45)

	active = null
	if player != null and not in_title_menu and not in_pause_menu:
		var nearest := INF
		for item in get_tree().get_nodes_in_group("interactables"):
			var d: float = player.global_position.distance_to(item.global_position)
			if d < item.interaction_radius and d < nearest:
				active = item
				nearest = d

	var show_prompt := active != null and not panel.visible and not in_title_menu and not in_pause_menu
	prompt.text = "E  •  " + active.interaction_name if show_prompt else ""
	prompt_card.visible = show_prompt
	if show_prompt:
		prompt.text = active.interaction_name
		prompt_icon.icon_kind = icon_for_item(active)
		prompt_card.offset_bottom = -34.0 + sin(ui_clock * 3.4) * 2.5

func update_hud_status() -> void:
	if weather == null:
		return
	var h: float = weather.hours
	var period: String = weather.time_period_label() if weather.has_method("time_period_label") else "Golden Hour"
	var w_label: String = weather.weather_display_label() if weather.has_method("weather_display_label") else "Calm Air"
	hud_time_label.text = format_clock(h) + "  •  " + period
	hud_weather_label.text = w_label + "   •   [Esc]"
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
	var n: String = str(item.get("interaction_name")).to_lower()
	if "talk" in n or "chat" in n or "eggeght" in n:
		return "chat"
	elif "sign" in n or "trail" in n or "board" in n:
		return "signpost"
	return "envelope"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if panel.visible:
			close()
		elif in_pause_menu:
			set_pause_menu(false)
		elif not in_title_menu:
			set_pause_menu(true)
	elif event.is_action_pressed("interact") and active != null and not panel.visible and not in_title_menu and not in_pause_menu:
		active.interact()

func show_message(title: String, message: String, source_item: Node = null) -> void:
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
	if player != null:
		player.blocked = true
	close_button.grab_focus()

func close() -> void:
	panel.hide()
	modal_backdrop.hide()
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

func make_chip_button(label_text: String) -> Button:
	var b := Button.new()
	b.text = label_text
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.add_theme_font_size_override("font_size", 12)
	b.add_theme_color_override("font_color", Color("EDE2CE"))
	b.add_theme_color_override("font_hover_color", Color("FFF9EE"))
	b.add_theme_stylebox_override("normal", make_card_style(Color(0.20, 0.31, 0.26, 0.92), Color(0.72, 0.54, 0.37, 0.65), 8, 1, 10, 5))
	b.add_theme_stylebox_override("hover", make_card_style(Color("9D6F47"), Color("F6E8D0"), 8, 1, 10, 5))
	b.add_theme_stylebox_override("pressed", make_card_style(Color("B88254"), Color("F6E8D0"), 8, 1, 10, 5))
	return b

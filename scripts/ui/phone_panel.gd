extends Control

const MAPS = preload("res://scripts/story/map_flow.gd")
const T = preload("res://scripts/ui/storybook_theme.gd")
const INK := Color("233632")
const PAPER := Color("ede8d7")

signal dismissed
signal alarm_silenced

var calendar_button: Button
var application_button: Button
var alarm_button: Button
var title: Label
var calendar_text: Label
var application_text: Label
var applications_open := false

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	theme = T.theme()
	var backdrop := ColorRect.new()
	backdrop.color = Color(0.035, 0.060, 0.059, 0.16)
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var case_panel := PanelContainer.new()
	case_panel.name = &"PhoneCase"
	case_panel.add_theme_stylebox_override("panel", panel_style(Color("202a28"), 32, 8, Color("56615a"), 1))
	add_child(case_panel)
	case_panel.set_anchor(SIDE_TOP, 0.5)
	case_panel.set_anchor(SIDE_BOTTOM, 0.5)
	case_panel.offset_left = 39
	case_panel.offset_right = 355
	case_panel.offset_top = -252
	case_panel.offset_bottom = 252

	var screen := PanelContainer.new()
	screen.add_theme_stylebox_override("panel", panel_style(PAPER, 25, 0))
	case_panel.add_child(screen)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 0)
	screen.add_child(column)

	var chrome := PanelContainer.new()
	chrome.add_theme_stylebox_override("panel", panel_style(INK, 20, 16))
	column.add_child(chrome)
	var heading := VBoxContainer.new()
	heading.add_theme_constant_override("separation", 3)
	chrome.add_child(heading)
	title = T.label("", 14, Color("c3cdb9"))
	heading.add_child(title)
	heading.add_child(T.label(MAPS.text("Phone", "Điện thoại"), 26, T.CREAM))

	var inset := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		inset.add_theme_constant_override("margin_" + side, 14)
	inset.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(inset)
	var contents := VBoxContainer.new()
	contents.add_theme_constant_override("separation", 13)
	inset.add_child(contents)

	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 6)
	contents.add_child(tabs)
	var group := ButtonGroup.new()
	calendar_button = button(tabs, MAPS.text("Schedule", "Lịch"), func(): show_page(false))
	application_button = button(tabs, MAPS.text("Applications", "Hồ sơ"), func(): show_page(true))
	for tab in [calendar_button, application_button]:
		tab.toggle_mode = true
		tab.button_group = group
		tab.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", panel_style(Color("f9f3e3"), 12, 14, Color("d6cfb9"), 1))
	card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	contents.add_child(card)
	var details := VBoxContainer.new()
	details.add_theme_constant_override("separation", 10)
	card.add_child(details)
	calendar_text = T.label("", 16, INK)
	application_text = T.label("", 16, INK)
	for label in [calendar_text, application_text]:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		details.add_child(label)
	alarm_button = button(details, MAPS.text("Silence alarm", "Tắt báo thức"), func(): alarm_silenced.emit())
	button(contents, MAPS.text("Close   ·   Q / Esc", "Đóng   ·   Q / Esc"), close_panel)
	hide()

func show_phone(context: String, schedule: String, applications: String, ringing: bool = false) -> void:
	title.text = context
	calendar_text.text = schedule
	application_text.text = applications
	alarm_button.disabled = not ringing
	show_page(false)
	show()
	calendar_button.grab_focus()

func update_calendar(schedule: String) -> void:
	calendar_text.text = schedule
	alarm_button.disabled = true
	show_page(applications_open)
	calendar_button.grab_focus()

func show_page(applications: bool) -> void:
	applications_open = applications
	calendar_button.button_pressed = not applications
	application_button.button_pressed = applications
	calendar_text.visible = not applications
	application_text.visible = applications
	alarm_button.visible = not applications and not alarm_button.disabled

func close_panel() -> void:
	hide()
	dismissed.emit()

static func is_shortcut(event: InputEvent) -> bool:
	return event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_Q

func button(parent: Node, label: String, action: Callable) -> Button:
	var control := Button.new()
	control.text = label
	control.custom_minimum_size.y = 43
	control.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	control.add_theme_font_size_override("font_size", 14)
	control.add_theme_stylebox_override("normal", panel_style(Color("dee2d3"), 8, 6))
	control.add_theme_stylebox_override("hover", panel_style(Color("cbd6c4"), 8, 6))
	control.add_theme_stylebox_override("pressed", panel_style(Color("b8c7b4"), 8, 6))
	control.add_theme_stylebox_override("focus", panel_style(Color.TRANSPARENT, 8, 6, T.SAGE, 2))
	for state in ["font_color", "font_focus_color", "font_hover_color", "font_pressed_color"]:
		control.add_theme_color_override(state, INK)
	control.pressed.connect(action)
	parent.add_child(control)
	return control

func panel_style(fill: Color, radius: int, inset: int, rim := Color.TRANSPARENT, border := 0) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.set_corner_radius_all(radius)
	style.border_color = rim
	style.set_border_width_all(border)
	for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		style.set_content_margin(side, inset)
	return style

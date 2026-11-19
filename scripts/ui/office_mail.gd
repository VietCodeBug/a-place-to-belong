extends Control
## The workstation and the reading view use the same inbox and message data.

const T = preload("res://scripts/ui/storybook_theme.gd")
const MAPS = preload("res://scripts/story/map_flow.gd")
const INK := Color("2f423e")
const PAPER := Color("f5eddb")
const TRAY := Color("e8e5d4")
const SLATE := Color("364e49")

signal dismissed

var copy: Dictionary
var screen: SubViewport
var inbox_row: VBoxContainer
var inbox_state: Label
var unread_dot: ColorRect
var empty_state: Label
var close_button: Button

func build(data: Dictionary) -> void:
	copy = data
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	theme = T.theme()

	var dim := ColorRect.new()
	add_child(dim)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0.049, 0.075, 0.078, 0.46)

	var center := CenterContainer.new()
	add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(750, 0)
	panel.add_theme_stylebox_override("panel", style(PAPER, 10, 0))
	center.add_child(panel)
	var column := stack(panel, 0)
	header(column, false)

	var page := PanelContainer.new()
	page.add_theme_stylebox_override("panel", style(PAPER, 0, 28))
	column.add_child(page)
	var body := stack(page, 13)
	body.add_child(T.label(copy.subject, 25, INK))
	body.add_child(T.label(copy.email.get_slice("\n", 0), 15, T.SAGE))
	var rule := ColorRect.new()
	rule.custom_minimum_size.y = 1
	rule.color = Color("c9c8b7")
	body.add_child(rule)

	var text := T.label(copy.email.substr(copy.email.find("\n\n") + 2), 17, INK)
	text.custom_minimum_size.x = 685
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text.add_theme_constant_override("line_spacing", 4)
	body.add_child(text)

	var footer := HBoxContainer.new()
	body.add_child(footer)
	footer.alignment = BoxContainer.ALIGNMENT_END
	close_button = Button.new()
	close_button.text = copy.close + "   ·   Esc"
	close_button.custom_minimum_size = Vector2(164, 40)
	close_button.add_theme_stylebox_override("normal", style(SLATE, 6, 12))
	close_button.add_theme_stylebox_override("hover", style(T.SAGE, 6, 12))
	close_button.pressed.connect(close_message)
	footer.add_child(close_button)
	hide()

func attach_screen(surface: MeshInstance3D) -> void:
	screen = SubViewport.new()
	screen.disable_3d = true
	screen.size = Vector2i(800, 403)
	screen.render_target_update_mode = SubViewport.UPDATE_ONCE
	add_child(screen)
	var paper := PanelContainer.new()
	paper.theme = T.theme()
	paper.add_theme_stylebox_override("panel", style(TRAY, 0, 0))
	screen.add_child(paper)
	paper.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var column := stack(paper, 0)
	header(column, true)
	var workspace := HBoxContainer.new()
	workspace.size_flags_vertical = Control.SIZE_EXPAND_FILL
	workspace.add_theme_constant_override("separation", 0)
	column.add_child(workspace)
	var sidebar := PanelContainer.new()
	sidebar.custom_minimum_size.x = 133
	sidebar.add_theme_stylebox_override("panel", style(Color("cad1bd"), 0, 17))
	workspace.add_child(sidebar)
	var folders := stack(sidebar, 13)
	folders.add_child(T.label(MAPS.text("Inbox", "Hộp thư"), 22, INK))
	var highlight := ColorRect.new()
	highlight.color = Color("849c87")
	highlight.custom_minimum_size = Vector2(43, 4)
	highlight.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	folders.add_child(highlight)

	var inset := PanelContainer.new()
	inset.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inset.add_theme_stylebox_override("panel", style(TRAY, 0, 23))
	workspace.add_child(inset)
	var tray := stack(inset, 17)
	inbox_state = T.label(copy.inbox, 28, INK)
	tray.add_child(inbox_state)
	empty_state = T.label(MAPS.text("No new messages", "Chưa có thư mới"), 21, T.SAGE)
	tray.add_child(empty_state)
	var row := PanelContainer.new()
	row.add_theme_stylebox_override("panel", style(PAPER, 5, 15))
	tray.add_child(row)
	inbox_row = stack(row, 10)
	var sender := HBoxContainer.new()
	inbox_row.add_child(sender)
	unread_dot = ColorRect.new()
	unread_dot.color = Color("ab674d")
	unread_dot.custom_minimum_size = Vector2(13, 13)
	unread_dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	sender.add_child(unread_dot)
	sender.add_child(T.label(copy.email.get_slice("\n", 0), 24, INK))
	var subject := T.label(copy.subject, 24, INK)
	subject.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	inbox_row.add_child(subject)
	inbox_row.add_child(T.label(copy.email.get_slice("\n", 2), 20, T.SAGE))
	row.hide()
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_texture = screen.get_texture()
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR
	surface.material_override = material

func update_inbox(arrived: bool, read: bool) -> void:
	inbox_state.text = copy.unread if arrived and not read else copy.inbox
	unread_dot.visible = not read
	inbox_row.get_parent().visible = arrived
	empty_state.visible = not arrived
	screen.render_target_update_mode = SubViewport.UPDATE_ONCE

func open_message() -> void:
	show()
	close_button.grab_focus()

func close_message() -> void:
	hide()
	dismissed.emit()

func header(parent: Node, monitor: bool) -> void:
	var banner := PanelContainer.new()
	banner.add_theme_stylebox_override("panel", style(SLATE, 0, 16 if monitor else 11))
	parent.add_child(banner)
	banner.add_child(T.label(MAPS.text("Work mail", "Thư công việc"), 24 if monitor else 16, T.CREAM))

func stack(parent: Node, gap: int) -> VBoxContainer:
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", gap)
	parent.add_child(column)
	return column

func style(color: Color, radius: int, padding: int) -> StyleBoxFlat:
	var panel := StyleBoxFlat.new()
	panel.bg_color = color
	panel.set_corner_radius_all(radius)
	for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		panel.set_content_margin(side, padding)
	return panel

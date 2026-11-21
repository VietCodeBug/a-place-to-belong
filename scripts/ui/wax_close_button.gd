extends Button
const T=preload("res://scripts/ui/storybook_theme.gd")
func _ready() -> void:
	custom_minimum_size=Vector2(150,76);tooltip_text="Put away letter [Esc]"
	for state in ["normal","hover","pressed","focus"]:add_theme_stylebox_override(state,StyleBoxEmpty.new())
	for state in ["font_color","font_hover_color","font_pressed_color","font_focus_color"]:add_theme_color_override(state,Color.TRANSPARENT)
	mouse_entered.connect(queue_redraw);mouse_exited.connect(queue_redraw);focus_entered.connect(queue_redraw);focus_exited.connect(queue_redraw)
func _draw() -> void:
	var c:=Vector2(75,26)
	draw_circle(c,25,T.CORAL);draw_arc(c,20,0,TAU,48,T.CREAM,1.,true)
	if has_focus() or is_hovered():draw_arc(c,28,0,TAU,48,T.OAK,2.,true)
	draw_rect(Rect2(c-Vector2(11,7),Vector2(22,15)),T.CREAM,false,1.4)
	draw_polyline(PackedVector2Array([c+Vector2(-11,-7),c+Vector2(0,2),c+Vector2(11,-7)]),T.CREAM,1.4,true)
	var caption := "%s [Esc]" % (text if not text.is_empty() else "Put away")
	draw_string(T.HAND,Vector2(0,72),caption,HORIZONTAL_ALIGNMENT_CENTER,150,23,T.FOREST)

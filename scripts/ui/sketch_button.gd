extends Button
## Deterministic pen contour, flat gouache fill and handwritten label; native focus/input preserved.
const T=preload("res://scripts/ui/storybook_theme.gd")
var primary:=false
var flat_ink:=false
var use_handwriting := true

func label_font() -> Font:
	return T.HAND if use_handwriting else T.SANS

func label_size() -> int:
	if use_handwriting:
		return 28 if primary else 25
	return 18 if primary else 17

func _ready() -> void:
	custom_minimum_size.x=maxf(custom_minimum_size.x,label_font().get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, label_size()).x+28)
	for state in ["normal","hover","pressed","focus","disabled"]:add_theme_stylebox_override(state,StyleBoxEmpty.new())
	for state in ["font_color","font_hover_color","font_pressed_color","font_focus_color"]:add_theme_color_override(state,Color.TRANSPARENT)
	mouse_entered.connect(queue_redraw);mouse_exited.connect(queue_redraw);focus_entered.connect(queue_redraw);focus_exited.connect(queue_redraw);button_down.connect(queue_redraw);button_up.connect(queue_redraw)
func _draw() -> void:
	var selected := has_focus() or (toggle_mode and button_pressed)
	var ink := T.CORAL if selected else (T.SAGE if is_hovered() else T.FOREST)
	var points:=PackedVector2Array([Vector2(3,4),Vector2(size.x*.32,2),Vector2(size.x-5,3),Vector2(size.x-2,size.y*.6),Vector2(size.x-5,size.y-3),Vector2(size.x*.6,size.y-2),Vector2(2,size.y-4),Vector2(3,4)])
	if not flat_ink:
		draw_colored_polygon(points,T.FOREST if primary else Color("F2E3C8"))
		draw_polyline(points,ink, 2.4 if selected else 1.2, true)
		draw_line(Vector2(7,size.y-7),Vector2(size.x-9,size.y-5),Color("B89B76"),.7,true)
	elif selected or is_hovered():draw_line(Vector2(8,size.y-5),Vector2(size.x*.65,size.y-6),ink,1.5,true)
	var text_color:=T.CREAM if primary else T.FOREST
	var font := label_font()
	var font_size := label_size()
	var baseline := (size.y + font.get_ascent(font_size) - font.get_descent(font_size)) * 0.5
	draw_string(font, Vector2(12, baseline), text, HORIZONTAL_ALIGNMENT_LEFT, size.x - 24, font_size, text_color)

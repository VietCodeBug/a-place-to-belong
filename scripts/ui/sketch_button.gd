extends Button
## Deterministic pen contour, flat gouache fill and handwritten label; native focus/input preserved.
const T=preload("res://scripts/ui/storybook_theme.gd")
var primary:=false
var flat_ink:=false
func _ready() -> void:
	custom_minimum_size.x=maxf(custom_minimum_size.x,T.HAND.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,28 if primary else 25).x+28)
	for state in ["normal","hover","pressed","focus","disabled"]:add_theme_stylebox_override(state,StyleBoxEmpty.new())
	for state in ["font_color","font_hover_color","font_pressed_color","font_focus_color"]:add_theme_color_override(state,Color.TRANSPARENT)
	mouse_entered.connect(queue_redraw);mouse_exited.connect(queue_redraw);focus_entered.connect(queue_redraw);focus_exited.connect(queue_redraw);button_down.connect(queue_redraw);button_up.connect(queue_redraw)
func _draw() -> void:
	var hot:=is_hovered() or has_focus();var ink:=T.CORAL if hot else T.FOREST
	var points:=PackedVector2Array([Vector2(3,4),Vector2(size.x*.32,2),Vector2(size.x-5,3),Vector2(size.x-2,size.y*.6),Vector2(size.x-5,size.y-3),Vector2(size.x*.6,size.y-2),Vector2(2,size.y-4),Vector2(3,4)])
	if not flat_ink:
		draw_colored_polygon(points,T.OAK if primary else Color("F2E3C8"))
		draw_polyline(points,ink,2. if hot else 1.2,true)
		draw_line(Vector2(7,size.y-7),Vector2(size.x-9,size.y-5),Color("B89B76"),.7,true)
	elif hot:draw_line(Vector2(8,size.y-5),Vector2(size.x*.65,size.y-6),ink,1.5,true)
	var text_color:=T.CREAM if primary else T.FOREST
	var font_size:=28 if primary else 25
	var start:=Vector2(12,size.y*.5+font_size*.32)
	draw_string(T.HAND,start,text,HORIZONTAL_ALIGNMENT_LEFT,size.x-24,font_size,text_color)

class_name AtmospherePostcard
extends Button
## Animated miniature landscape, not a text-input chip.
var mood:="golden"
var title:="Golden hour"
var clock:=0.
var compact:=false
func _ready() -> void:
	custom_minimum_size=Vector2(94,100) if compact else Vector2(101,116);mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND
	tooltip_text="Visit the clearing at "+title.to_lower()
func _process(delta: float) -> void:clock+=delta;queue_redraw()
func _draw() -> void:
	var night:=mood=="night";var rain:=mood=="rain"
	var cloudy:=rain or mood=="overcast"
	var sky:=Color("233B59") if night else (Color("74878A") if cloudy else Color("E8BD80"))
	var box:=StyleBoxFlat.new();box.bg_color=sky;box.set_corner_radius_all(10);box.border_color=Color("EDDBAE") if is_hovered() or has_focus() else Color("83917A");box.set_border_width_all(2)
	draw_style_box(box,Rect2(Vector2.ZERO,size))
	if night:
		draw_circle(Vector2(size.x*.72,23),8,Color("EFE1A8"));draw_circle(Vector2(size.x*.76,20),7,sky)
		for i in range(9):draw_circle(Vector2(10+fmod(i*19.,size.x-20),12+fmod(i*11.,36)),.8,Color("D7D7BB"))
	elif not cloudy:draw_circle(Vector2(size.x*.74,25),11,Color("FFF0BE"))
	if cloudy:
		for p in [Vector2(27,23),Vector2(38,18),Vector2(49,25)]:draw_circle(p,10,Color("B7C4BF"))
	for layer in range(3):
		var points:=PackedVector2Array([Vector2(0,82),Vector2(0,53-layer*5)])
		for i in range(7):points.append(Vector2(i*size.x/6.,49-layer*5+sin(i*1.6+layer)*9))
		points.append(Vector2(size.x,88));points.append(Vector2(0,88))
		draw_colored_polygon(points,[Color("82928B"),Color("58786D"),Color("315447")][layer].darkened(.25 if night else 0.))
	for i in range(4):
		var x:=10+i*25.;var y:=59.+sin(i*2.)*7
		draw_colored_polygon(PackedVector2Array([Vector2(x,y-19),Vector2(x-10,y+8),Vector2(x+10,y+8)]),Color("203F35"))
	if rain:
		for i in range(10):
			var p:=Vector2(8+fmod(i*23.,size.x-12),fposmod(clock*35.+i*19.,69.))
			draw_line(p,p+Vector2(-3,8),Color(.78,.87,.90,.7),1.,true)
	var base:=StyleBoxFlat.new();base.bg_color=Color("213F33");base.corner_radius_bottom_left=9;base.corner_radius_bottom_right=9
	draw_style_box(base,Rect2(1,size.y-29,size.x-2,28))
	draw_string(ThemeDB.fallback_font,Vector2(8,size.y-10),title,HORIZONTAL_ALIGNMENT_CENTER,size.x-16,12,Color("F1E7CB"))

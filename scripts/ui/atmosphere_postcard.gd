class_name AtmospherePostcard
extends Button
## Original illustrated postal collectibles, with persistent selection and keyboard focus.
const T=preload("res://scripts/ui/storybook_theme.gd")
var mood:="golden"
var title:="Honey & letters"
var clock:=0.
var compact:=false
var selected:=false
var reduce_motion:=false
var lift:=0.
var art: Texture2D
func _ready() -> void:
	custom_minimum_size=Vector2(112,104) if compact else Vector2(190,156)
	mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND
	tooltip_text=title+" — preview this atmosphere"
	art=load("res://assets/ui/postcards/"+({"rain":"rain","night":"night"}.get(mood,"honey"))+"-sketch.png")
	for state in ["normal","hover","pressed","focus"]:add_theme_stylebox_override(state,StyleBoxEmpty.new())
func _process(delta: float) -> void:
	if not reduce_motion:clock+=delta
	lift=move_toward(lift,0. if reduce_motion else (1. if is_hovered() or has_focus() else 0.),delta*7.)
	pivot_offset=size*.5;rotation=0. if reduce_motion else lift*(-.025 if mood=="rain" else .025)
	queue_redraw()
func _draw() -> void:
	var box:=T.paper();box.content_margin_left=0;box.content_margin_top=0;box.bg_color=T.CREAM;box.border_color=T.CORAL if selected else T.OAK;box.set_border_width_all(3 if selected or has_focus() else 1)
	draw_style_box(box,Rect2(Vector2(0,-lift*5),size))
	var rect:=Rect2(7,7-lift*5,size.x-14,size.y-40)
	draw_texture_rect(art,rect,false)
	var font_size:=11 if compact else 13
	draw_string(T.SANS,Vector2(8,size.y-17-lift*5),title,HORIZONTAL_ALIGNMENT_CENTER,size.x-16,font_size,T.FOREST)
	if selected:
		draw_circle(Vector2(size.x-14,15-lift*5),9,T.CORAL)
		draw_line(Vector2(size.x-18,15-lift*5),Vector2(size.x-15,18-lift*5),T.CREAM,2.)
		draw_line(Vector2(size.x-15,18-lift*5),Vector2(size.x-10,11-lift*5),T.CREAM,2.)

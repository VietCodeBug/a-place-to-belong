class_name DaylightDial
extends HSlider
var dragging:=false
func _ready() -> void:
	custom_minimum_size=Vector2(210,156)
	for name in ["slider","grabber_area","grabber_area_highlight"]:add_theme_stylebox_override(name,StyleBoxEmpty.new())
	var pixels:=Image.create(1,1,false,Image.FORMAT_RGBA8);pixels.fill(Color.TRANSPARENT)
	var blank:=ImageTexture.create_from_image(pixels)
	for name in ["grabber","grabber_highlight","grabber_disabled"]:add_theme_icon_override(name,blank)
	mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND
func _process(_delta: float) -> void:queue_redraw()
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT:dragging=event.pressed
	if dragging and (event is InputEventMouseMotion or event is InputEventMouseButton):
		var p:=get_local_mouse_position()-Vector2(size.x*.5,72)
		value=fposmod((atan2(p.y,p.x)+PI/2)/TAU*24.,24.);accept_event()
func _draw() -> void:
	var center:=Vector2(size.x*.5,72);var radius:=54.
	draw_circle(center,62,Color("253D38"));draw_arc(center,radius,-PI/2,PI*1.5,64,Color("9EA888"),2.,true)
	for i in range(24):
		var d:=Vector2.from_angle(i*TAU/24.-PI/2)
		draw_line(center+d*48,center+d*(42 if i%6==0 else 45),Color("C5B58B"),1.,true)
	var sun:=center+Vector2.from_angle(value/24.*TAU-PI/2)*radius
	draw_circle(sun,7,Color("F2D398"))
	draw_string(ThemeDB.fallback_font,center+Vector2(-45,4),"%02d:%02d"%[int(value),int(fmod(value,1.)*60.)],HORIZONTAL_ALIGNMENT_CENTER,90,22,Color("F2E6C9"))
	draw_string(ThemeDB.fallback_font,Vector2(center.x-70,151),"Follow the daylight",HORIZONTAL_ALIGNMENT_CENTER,140,12,Color("B6C4AA"))

extends Control
## Read-only 24-hour status; hands use a conventional 12-hour dial.
const T=preload("res://scripts/ui/storybook_theme.gd")
var hours:=16.5
var icon: Control
func _ready() -> void:
	custom_minimum_size=Vector2(124,132);mouse_filter=Control.MOUSE_FILTER_IGNORE
	icon=preload("res://scripts/ui/cozy_ui_icons.gd").new("partly_cloudy",Vector2(27,27));icon.position=Vector2(86,91);icon.modulate=Color("809B88");add_child(icon)
func _draw() -> void:
	var c:=Vector2(57,68)
	draw_arc(Vector2(57,12),10,0,TAU,32,T.OAK,3.,true)
	draw_circle(c,55,T.OAK);draw_circle(c,50,T.FOREST);draw_arc(c,45,0,TAU,64,T.CREAM,1.2,true)
	for i in range(12):
		var d:=Vector2.from_angle(i*TAU/12.-PI/2)
		draw_line(c+d*38,c+d*(32 if i%3==0 else 35),T.CREAM,1.5,true)
	var minute:=Vector2.from_angle(fmod(hours,1.)*TAU-PI/2)
	var hour:=Vector2.from_angle(fmod(hours,12.)*TAU/12.-PI/2)
	draw_line(c,c+minute*29,T.CREAM,2.,true);draw_line(c,c+hour*21,T.CREAM,3.,true);draw_circle(c,3,T.CREAM)
	var clock:="%02d:%02d"%[int(hours),int(fmod(hours,1.)*60.)]
	draw_rect(Rect2(25,93,64,20),T.FOREST)
	draw_string(T.SANS,Vector2(25,110),clock,HORIZONTAL_ALIGNMENT_CENTER,64,17,T.CREAM)
	draw_circle(Vector2(100,105),22,T.OAK);draw_circle(Vector2(100,105),18,T.CREAM)

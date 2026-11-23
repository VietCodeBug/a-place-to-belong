extends Control
## Original postal mark: coffee steam, envelope and circular sorting-office cancellation.
var seal:=false
func _ready() -> void:
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	custom_minimum_size=Vector2(80,80)
func _draw() -> void:
	var c:=size*.5
	var ink:=Color("C85E55") if seal else Color("F6E8D0")
	draw_arc(c,33,0,TAU,64,ink,2.,true);draw_arc(c,28,0,TAU,64,ink,1.,true)
	if seal:draw_circle(c,25,Color("C85E55"));ink=Color("F6E8D0")
	draw_rect(Rect2(c-Vector2(18,4),Vector2(36,22)),ink,false,2.)
	draw_line(c-Vector2(18,4),c+Vector2(0,9),ink,2.);draw_line(c+Vector2(18,-4),c+Vector2(0,9),ink,2.)
	for x in [-8,0,8]:draw_arc(c+Vector2(x,-13),5,-1.6,1.6,12,ink,1.5,true)

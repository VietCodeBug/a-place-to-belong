extends Control
## Original envelope opening transition; the underlying real letter remains the modal.
var progress:=0.0:
	set(value):progress=value;queue_redraw()
func _ready() -> void:mouse_filter=Control.MOUSE_FILTER_IGNORE
func _draw() -> void:
	var c:=size*.5;var ink:=Color("B88254");var paper:=Color("F6E8D0")
	var rect:=Rect2(c-Vector2(290,145),Vector2(580,290))
	draw_rect(rect,paper);draw_rect(rect,ink,false,2.)
	draw_colored_polygon(PackedVector2Array([c+Vector2(-290,145),c+Vector2(0,-30),c+Vector2(290,145)]),Color("E5D1AC"))
	var fold:=lerpf(120.,-220.,progress)
	draw_colored_polygon(PackedVector2Array([c+Vector2(-290,-145),c+Vector2(0,fold),c+Vector2(290,-145)]),Color("ECDBBD"))
	draw_polyline(PackedVector2Array([c+Vector2(-290,-145),c+Vector2(0,fold),c+Vector2(290,-145)]),ink,2.,true)
	if progress<.3:draw_circle(c+Vector2(0,36),22,Color("C85E55"))

extends Control
## Original airmail edging and cancellation mark; decorative, never intercepts input.
func _ready() -> void:mouse_filter=Control.MOUSE_FILTER_IGNORE
func _draw() -> void:
	# Folded upper corner and a second paper edge, outside the reading column.
	draw_colored_polygon(PackedVector2Array([Vector2(size.x-16,-10),Vector2(size.x+10,16),Vector2(size.x-16,16)]),Color("E4D1AE"))
	draw_line(Vector2(size.x-16,-10),Vector2(size.x-16,16),Color("C6AD87"),1.)
	draw_line(Vector2(-20,size.y+16),Vector2(size.x+12,size.y+16),Color("D7C09C"),2.)
	for i in range(int(size.y/28.)):
		var y:=10.+i*28.
		draw_line(Vector2(-16,y),Vector2(-16,y+14),Color("C85E55") if i%2==0 else Color("496B59"),3.)
	var p:=Vector2(75,size.y-18)
	draw_arc(p,18,0,TAU,48,Color("B79A77"),1.,true)
	draw_string(ThemeDB.fallback_font,p+Vector2(-16,4),"POST",HORIZONTAL_ALIGNMENT_LEFT,-1,10,Color("8F795E"))
	for i in range(3):draw_line(p+Vector2(23,-9+i*8),p+Vector2(105,-9+i*8),Color("B79A77"),1.,true)

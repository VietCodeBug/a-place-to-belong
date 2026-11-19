extends "res://scripts/ui/cozy_ui_icons.gd"
## Ink colors for a cream weather seal; no dark rectangular moon cut-out.
func _draw() -> void:
	var c:=size*.5;var r:=minf(size.x,size.y)*.5
	var sage:=Color("496B59");var cream:=Color("F6E8D0")
	match icon_kind:
		"moon":
			draw_circle(c,r*.62,sage);draw_circle(c+Vector2(r*.28,-r*.2),r*.52,cream)
		"partly_cloudy":
			draw_sun_glyph(c+Vector2(-r*.25,-r*.2),r*.35,Color("B88254"),6)
			draw_cloud_shape(c+Vector2(r*.12,r*.2),r*.68,sage)
		"overcast":draw_cloud_shape(c,r*.76,sage)
		"rain":
			draw_cloud_shape(c-Vector2(0,r*.15),r*.68,sage)
			for i in [-1,0,1]:draw_line(c+Vector2(i*r*.35,r*.25),c+Vector2(i*r*.35-r*.12,r*.6),sage,1.5,true)
		_:draw_sun_glyph(c,r*.5,Color("B88254"),8)

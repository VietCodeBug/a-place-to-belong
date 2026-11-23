class_name CozyUiIcon
extends Control
## Crisp procedural vector icons matching the Forest Post Café palette at any resolution.

@export var icon_kind := "sun":
	set(value):
		icon_kind = value
		queue_redraw()

func _init(kind := "sun", min_sz := Vector2(28, 28)) -> void:
	icon_kind = kind
	custom_minimum_size = min_sz
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _draw() -> void:
	var c := size * 0.5
	var r := minf(size.x, size.y) * 0.5
	match icon_kind:
		"sun":
			draw_sun_glyph(c, r * 0.44, Color("F6C86E"), 8)
		"dawn_dusk":
			draw_arc(c + Vector2(0, r * 0.18), r * 0.44, PI, TAU, 20, Color("F4AE68"), 2.2, true)
			draw_colored_polygon(semi_disc(c + Vector2(0, r * 0.18), r * 0.38), Color("F6C27A"))
			draw_line(Vector2(c.x - r * 0.72, c.y + r * 0.22), Vector2(c.x + r * 0.72, c.y + r * 0.22), Color("B88254"), 2.2, true)
			draw_line(Vector2(c.x - r * 0.46, c.y + r * 0.44), Vector2(c.x + r * 0.46, c.y + r * 0.44), Color("8BA58A"), 1.8, true)
		"moon":
			draw_circle(c, r * 0.50, Color("F3DFB6"))
			draw_circle(c + Vector2(r * 0.22, -r * 0.14), r * 0.42, Color("22362D"))
			draw_circle(c + Vector2(r * 0.46, -r * 0.36), maxf(1.4, r * 0.09), Color("F7EEDB"))
			draw_circle(c + Vector2(-r * 0.48, -r * 0.30), maxf(1.1, r * 0.07), Color("D7E4EE"))
		"partly_cloudy":
			draw_sun_glyph(c + Vector2(-r * 0.22, -r * 0.18), r * 0.30, Color("F5C469"), 6)
			draw_cloud_shape(c + Vector2(r * 0.10, r * 0.16), r * 0.68, Color("F5EBDD"))
		"overcast":
			draw_cloud_shape(c + Vector2(-r * 0.12, -r * 0.08), r * 0.58, Color("AEBDB8"))
			draw_cloud_shape(c + Vector2(r * 0.10, r * 0.14), r * 0.68, Color("E7E2D6"))
		"rain":
			draw_cloud_shape(c + Vector2(0, -r * 0.12), r * 0.66, Color("C9D6D8"))
			for ox in [-0.30, 0.0, 0.30]:
				var p0 := c + Vector2(ox * r, r * 0.22)
				var p1 := p0 + Vector2(-r * 0.12, r * 0.34)
				draw_line(p0, p1, Color("8DC9CB"), 2.0, true)
		"envelope":
			var w := r * 1.32
			var h := r * 0.92
			var rect := Rect2(c - Vector2(w, h) * 0.5, Vector2(w, h))
			draw_rect(rect, Color("F4E5CA"), true)
			draw_rect(rect, Color("9E6E46"), false, 1.8)
			draw_line(rect.position, c + Vector2(0, h * 0.08), Color("9E6E46"), 1.6, true)
			draw_line(Vector2(rect.end.x, rect.position.y), c + Vector2(0, h * 0.08), Color("9E6E46"), 1.6, true)
			draw_circle(c + Vector2(0, h * 0.08), r * 0.18, Color("C85E55"))
		"chat":
			var bubble := Rect2(c - Vector2(r * 0.62, r * 0.46), Vector2(r * 1.24, r * 0.84))
			draw_rect(bubble, Color("F4E5CA"), true)
			draw_rect(bubble, Color("9E6E46"), false, 1.8)
			var tail := PackedVector2Array([
				Vector2(c.x - r * 0.18, bubble.end.y - 1.0),
				Vector2(c.x - r * 0.32, bubble.end.y + r * 0.26),
				Vector2(c.x + r * 0.06, bubble.end.y - 1.0),
			])
			draw_colored_polygon(tail, Color("F4E5CA"))
			for dx in [-0.26, 0.0, 0.26]:
				draw_circle(Vector2(c.x + dx * r, bubble.get_center().y), maxf(1.5, r * 0.08), Color("496B59"))
		"hand":
			var contour := PackedVector2Array([Vector2(-.27,.65),Vector2(-.52,.21),Vector2(-.56,-.04),
				Vector2(-.41,-.11),Vector2(-.24,.06),Vector2(-.24,-.50),Vector2(-.10,-.59),
				Vector2(.01,-.12),Vector2(.025,-.74),Vector2(.17,-.75),Vector2(.25,-.16),
				Vector2(.30,-.57),Vector2(.44,-.54),Vector2(.44,-.12),Vector2(.54,-.36),Vector2(.65,-.29),
				Vector2(.60,.25),Vector2(.41,.65)])
			for i in contour.size():
				contour[i] = c+contour[i]*r
			draw_colored_polygon(contour,Color("F4E5CA"))
		"signpost":
			draw_rect(Rect2(c.x - r * 0.09, c.y - r * 0.58, r * 0.18, r * 1.20), Color("8F623D"), true)
			var board := PackedVector2Array([
				Vector2(c.x - r * 0.56, c.y - r * 0.36),
				Vector2(c.x + r * 0.42, c.y - r * 0.36),
				Vector2(c.x + r * 0.64, c.y - r * 0.14),
				Vector2(c.x + r * 0.42, c.y + r * 0.08),
				Vector2(c.x - r * 0.56, c.y + r * 0.08),
			])
			draw_colored_polygon(board, Color("D9B589"))
		"coffee_post":
			# Warm mug + steam wisps + coral wax dot
			var cup := Rect2(c.x - r * 0.44, c.y - r * 0.08, r * 0.82, r * 0.62)
			draw_rect(cup, Color("F6E8D0"), true)
			draw_rect(cup, Color("B88254"), false, 2.0)
			draw_arc(Vector2(cup.end.x, cup.get_center().y), r * 0.18, -PI * 0.5, PI * 0.5, 12, Color("B88254"), 2.0, true)
			draw_line(Vector2(c.x - r * 0.56, cup.end.y + r * 0.10), Vector2(c.x + r * 0.52, cup.end.y + r * 0.10), Color("B88254"), 2.2, true)
			for sx in [-0.20, 0.08]:
				draw_arc(Vector2(c.x + sx * r, c.y - r * 0.30), r * 0.14, PI * 0.6, PI * 1.5, 10, Color("E8D5B5"), 1.6, true)
			draw_circle(Vector2(cup.get_center().x, cup.get_center().y), r * 0.14, Color("C85E55"))

func draw_sun_glyph(center: Vector2, rad: float, col: Color, rays: int) -> void:
	draw_circle(center, rad, col)
	for i in range(rays):
		var a := float(i) / float(rays) * TAU
		var dir := Vector2(cos(a), sin(a))
		draw_line(center + dir * (rad * 1.32), center + dir * (rad * 1.72), col, 1.8, true)

func draw_cloud_shape(center: Vector2, scale_r: float, col: Color) -> void:
	draw_circle(center + Vector2(-scale_r * 0.34, scale_r * 0.08), scale_r * 0.30, col)
	draw_circle(center + Vector2(0.0, -scale_r * 0.08), scale_r * 0.38, col)
	draw_circle(center + Vector2(scale_r * 0.34, scale_r * 0.10), scale_r * 0.28, col)
	draw_rect(Rect2(center.x - scale_r * 0.36, center.y + scale_r * 0.02, scale_r * 0.72, scale_r * 0.34), col, true)

func semi_disc(center: Vector2, rad: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in range(15):
		var a := PI + float(i) / 14.0 * PI
		pts.append(center + Vector2(cos(a), sin(a)) * rad)
	return pts

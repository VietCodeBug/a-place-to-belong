shader_type spatial;
render_mode unshaded, blend_add, cull_disabled, depth_draw_never;

uniform vec3 flow_direction = vec3(0.0, 0.0, -1.0);
varying float lifetime;

void vertex() {
	lifetime = fract(TIME * (0.11 + COLOR.g * 0.08) + COLOR.r);
	VERTEX += flow_direction * (lifetime - 0.5) * 13.0;
	VERTEX.y += 0.47 * sin(lifetime * TAU + COLOR.b * PI);
}

void fragment() {
	float end_fade = sin(UV.x * PI);
	float edge_fade = 1.0 - abs(UV.y * 2.0 - 1.0);
	float cycle_fade = sin(lifetime * PI);
	ALBEDO = vec3(0.31, 0.64, 0.74);
	ALPHA = end_fade * edge_fade * cycle_fade * 0.22;
}

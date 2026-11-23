shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_never, shadows_disabled;

uniform vec3 lower;
uniform vec3 span;
varying float streak_alpha;

void vertex() {
	vec3 origin = MODEL_MATRIX[3].xyz;
	float speed = mix(10.0, 17.0, INSTANCE_CUSTOM.r);
	float lean = mix(0.16, 0.38, INSTANCE_CUSTOM.g);
	vec3 wind = vec3(1.65, -speed, -0.72);
	origin = lower + mod(origin - lower + wind * TIME, span);
	VERTEX.x += VERTEX.y * lean;
	VERTEX.y *= mix(0.70, 1.52, INSTANCE_CUSTOM.b);
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
		INV_VIEW_MATRIX[0], vec4(0.0, 1.0, 0.0, 0.0), INV_VIEW_MATRIX[2], vec4(origin, 1.0));
	streak_alpha = mix(0.31, 0.61, INSTANCE_CUSTOM.a);
}

void fragment() {
	float line = 1.0 - abs(UV.x * 2.0 - 1.0);
	ALBEDO = vec3(0.72, 0.82, 0.89);
	ALPHA = streak_alpha * smoothstep(0.02, 0.72, line) * sin(UV.y * 3.14159265);
}

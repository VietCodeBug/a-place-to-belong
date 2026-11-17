shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_never;

uniform float rain_strength = 0.0;
varying vec3 position_world;
varying vec2 quad_uv;

void vertex() {
	quad_uv = UV;
	// Camera-facing streaks, geometry rather than image textures.
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	position_world = (INV_VIEW_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	if (position_world.y < 0.10) discard;
	if (abs(position_world.x) < 8.4 && position_world.z > -12.4 && position_world.z < 5.25 && position_world.y < 8.0) discard;
	float v_taper = sin(clamp(quad_uv.y, 0.0, 1.0) * 3.14159265);
	float h_core = 1.0 - abs(quad_uv.x * 2.0 - 1.0);
	ALBEDO = vec3(0.74, 0.84, 0.90);
	ALPHA = 0.56 * rain_strength * v_taper * smoothstep(0.0, 0.65, h_core);
}

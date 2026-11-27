shader_type spatial;
render_mode unshaded, blend_add, cull_disabled, depth_draw_never;

uniform float travel = 4.0;
varying float lifetime;

void vertex() {
	lifetime = fract(TIME * (0.16 + COLOR.g * 0.14) + COLOR.r);
	VERTEX.y = min(VERTEX.y + lifetime * travel, 4.81);
	VERTEX.x += 0.25 * sin(lifetime * 6.28318 + COLOR.b * 5.0);
}

void fragment() {
	float radius = length(UV * 2.0 - 1.0);
	float ring = smoothstep(0.40, 0.81, radius) * (1.0 - smoothstep(0.83, 1.0, radius));
	float glim = smoothstep(0.5, 1.0, UV.y) * (1.0 - smoothstep(0.42, 0.98, radius));
	ALBEDO = vec3(0.62, 0.89, 0.95);
	ALPHA = (ring * 0.16 + glim * 0.19) * sin(lifetime * 3.14159);
}

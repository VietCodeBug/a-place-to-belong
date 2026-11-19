shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_never, shadows_disabled;

uniform float pane_width = 2.0;
uniform float pane_seed = 0.0;

float hash11(float r) {
	return fract(sin(r * 127.1 + pane_seed * 23.24) * 43758.5453);
}

void fragment() {
	float x = UV.x * pane_width;
	float channel = floor(x * 34.0);
	float seed = hash11(channel);
	float lane_x = fract(x * 34.0) - mix(0.16, 0.83, seed);
	float flow = UV.y * mix(1.6, 3.7, seed) - TIME * mix(0.37, 1.03, hash11(channel + 18.0));
	float bead = fract(flow + seed * 6.7);
	float wave = sin(bead * 19.0 + channel) * 0.032;
	float lengthwise = smoothstep(0.10, 0.37, bead) * (1.0 - smoothstep(0.48, 0.75, bead));
	float thin = 1.0 - smoothstep(0.009, 0.043 + 0.050 * bead, abs(lane_x + wave));
	float glint = lengthwise * thin * mix(0.23, 1.0, seed);
	vec2 cell_uv = vec2(x, UV.y) * vec2(48.0, 62.0);
	vec2 cell = floor(cell_uv);
	float drop_id = hash11(cell.x * 29.0 + cell.y * 143.0);
	float drop = (1.0 - smoothstep(0.043, 0.149, length(fract(cell_uv) - 0.5))) * step(0.90, drop_id);
	ALBEDO = mix(vec3(0.26, 0.36, 0.44), vec3(0.67, 0.78, 0.87), clamp(glint + drop, 0.0, 1.0));
	ALPHA = 0.045 + glint * 0.34 + drop * 0.24;
}

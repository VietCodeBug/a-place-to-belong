shader_type spatial;
render_mode cull_disabled, diffuse_burley;

uniform vec4 leaf_color : source_color = vec4(0.31, 0.46, 0.34, 1.0);
uniform vec4 sun_tint : source_color = vec4(1.0, 0.88, 0.66, 1.0);
uniform vec4 distance_haze : source_color = vec4(0.56, 0.68, 0.67, 1.0);
uniform vec2 wind_direction = vec2(0.85, 0.52);
uniform float wind_strength = 0.08;
uniform float wind_clock = 0.0;
uniform float base_height = 2.0;
uniform float crown_top = 12.0;
uniform float daylight = 1.0;
uniform float wetness = 0.0;
uniform vec3 sun_direction = vec3(0.45, 0.45, 0.55);

varying float crown_ratio;
varying vec3 inst_tint;
varying float haze_factor;
varying float sun_catch;

void vertex() {
	vec3 world = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 root = MODEL_MATRIX[3].xyz;
	crown_ratio = clamp((VERTEX.y - base_height) / max(crown_top - base_height, 0.45), 0.0, 1.0);
	inst_tint = (dot(INSTANCE_CUSTOM.rgb, INSTANCE_CUSTOM.rgb) > 0.001) ? INSTANCE_CUSTOM.rgb : vec3(1.0);
	float phase = INSTANCE_CUSTOM.a * 6.2831853;
	float anchor = smoothstep(base_height * 0.65, crown_top, VERTEX.y);
	vec2 dir = normalize(wind_direction);
	float gust = 0.32 + 0.68 * smoothstep(-0.65, 0.85, sin(dot(world.xz, dir) * 0.36 - wind_clock * 1.45 + phase * 0.25));
	float flutter = sin(wind_clock * 2.4 + phase + VERTEX.x * 1.7) * 0.12;
	vec2 offset = dir * wind_strength * (gust + flutter) * anchor * 0.68;
	VERTEX += transpose(mat3(MODEL_MATRIX)) * vec3(offset.x, 0.0, offset.y) / max(dot(MODEL_MATRIX[0].xyz, MODEL_MATRIX[0].xyz), 0.0001);

	vec3 world_n = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
	sun_catch = clamp(dot(world_n, -normalize(sun_direction)) * 0.5 + 0.5, 0.0, 1.0);
	haze_factor = smoothstep(32.0, 108.0, length(root.xz)) * 0.42;
}

void fragment() {
	vec3 base = leaf_color.rgb * inst_tint;
	// Vertical canopy value separation: grounded lower boughs, luminous sunlit crown tips
	vec3 lower_shade = base * vec3(0.80, 0.84, 0.88);
	vec3 upper_crown = mix(base * 1.14, base * sun_tint.rgb * 1.24, daylight * 0.45);
	vec3 color = mix(lower_shade, upper_crown, smoothstep(0.06, 0.92, crown_ratio));
	// Warm directional crown catch in daylight without washing out flat-shaded facets
	color = mix(color, color * sun_tint.rgb * 1.16, sun_catch * crown_ratio * daylight * 0.28);
	// Subtle atmospheric depth separation for outer hillside groves
	color = mix(color, mix(color, distance_haze.rgb, 0.58), haze_factor);
	// Soften underside normals slightly so deep pine tiers never crush into heavy black
	NORMAL = normalize(mix(NORMAL, normalize((VIEW_MATRIX * vec4(0.0, 1.0, 0.0, 0.0)).xyz), 0.24));
	ALBEDO = color * mix(1.0, 0.78, wetness);
	ROUGHNESS = mix(0.94, 0.62, wetness);
	SPECULAR = mix(0.08, 0.22, wetness);
}

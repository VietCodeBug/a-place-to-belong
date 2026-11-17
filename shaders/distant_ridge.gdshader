shader_type spatial;
render_mode diffuse_lambert, cull_disabled;

uniform vec4 ridge_color : source_color = vec4(0.32, 0.45, 0.44, 1.0);
uniform vec4 crest_color : source_color = vec4(0.46, 0.58, 0.54, 1.0);
uniform vec4 haze_color : source_color = vec4(0.76, 0.81, 0.78, 1.0);
uniform float haze_amount : hint_range(0.0, 1.0) = 0.42;
uniform float foot_fade_height = 18.0;
uniform float crest_height = 46.0;
uniform float sun_warmth : hint_range(0.0, 1.0) = 0.25;
uniform vec3 sun_direction = vec3(0.5, 0.3, 0.5);

varying float world_y;
varying vec3 world_pos;
varying vec3 world_normal;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	world_y = world_pos.y;
	world_normal = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
}

void fragment() {
	float h = clamp((world_y + 4.0) / max(crest_height, 1.0), 0.0, 1.0);
	vec3 base = mix(ridge_color.rgb, crest_color.rgb, smoothstep(0.18, 0.88, h));
	float sun_facing = clamp(dot(normalize(world_pos), -normalize(sun_direction)) * 0.5 + 0.5, 0.0, 1.0);
	float facet = clamp(world_normal.y * 0.55 + 0.45, 0.0, 1.0);
	base *= mix(0.88, 1.08, facet);
	base = mix(base, haze_color.rgb, sun_facing * sun_warmth * 0.22 * smoothstep(0.35, 0.95, h));
	float valley_mist = 1.0 - smoothstep(-3.0, foot_fade_height, world_y);
	float atmospheric = clamp(haze_amount + valley_mist * 0.48, 0.0, 0.94);
	ALBEDO = mix(base, haze_color.rgb, atmospheric);
	ROUGHNESS = 1.0;
	SPECULAR = 0.02;
}

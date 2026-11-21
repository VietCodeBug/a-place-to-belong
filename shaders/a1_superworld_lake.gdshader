shader_type spatial;
render_mode cull_disabled, diffuse_burley;

uniform vec2 center;
uniform vec2 radii;
varying vec3 world;
void vertex() {
	world = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float edge = length((world.xz - center) / radii);
	float wave = sin(world.x * .22 + world.z * .45 - TIME * .64);
	float ripple = sin(world.z * 1.16 - world.x * .48 - TIME * 1.1 + wave * .5);
	float glints = smoothstep(.85,.99,wave * .45 + ripple * .55);
	float rim = smoothstep(.81,1.0,edge);
	ALBEDO = mix(vec3(.034,.24,.31),vec3(.16,.44,.40),rim) + glints * .09;
	NORMAL = normalize(NORMAL + vec3(wave * .07,ripple * .035,0.0));
	ROUGHNESS = .37;
	SPECULAR = .55;
	ALPHA = (1.0-smoothstep(.99,1.0,edge)) * mix(.74,.40,rim);
}

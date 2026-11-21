shader_type spatial;
render_mode cull_disabled, diffuse_burley;

uniform bool superworld_water = false;
varying vec3 world_point;
void vertex() {
	world_point = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}
void fragment() {
	float waves = sin(world_point.z * 3.2 + sin(world_point.x * 0.7 - TIME * 1.8) * 0.8);
	float ripple = sin(world_point.x * 1.55 - TIME * 2.7 + world_point.z * 0.8);
	float gleam = smoothstep(0.82, 1.0, waves * 0.65 + ripple * 0.35);
	float center = 74.0 + 6.0 * sin(world_point.x * .057) * smoothstep(3.0, 16.0, abs(world_point.x));
	float shoal = smoothstep(2.1, 5.7, abs(world_point.z - center) + waves * .20);
	float foam = smoothstep(.85, .98, ripple) * smoothstep(.78, .98, shoal);
	ALBEDO = mix(vec3(0.032, 0.26, 0.29), vec3(0.24, 0.56, 0.53), 0.12 + gleam * 0.26 + shoal * 0.48) + vec3(.19,.23,.17) * foam;
	NORMAL = normalize(NORMAL + vec3(waves * 0.045, ripple * 0.038, 0.0));
	if (superworld_water) {
		float satin = sin(world_point.x*.44-TIME*.97+world_point.z*1.2);
		ALBEDO = mix(vec3(.039,.19,.196),vec3(.146,.316,.246),shoal*.8) + vec3(.21,.271,.225)*(foam*.57+gleam*.23);
		NORMAL = normalize(NORMAL+vec3(satin*.038,0,0));
	}
	ROUGHNESS = 0.32;
	SPECULAR = 0.45;
}

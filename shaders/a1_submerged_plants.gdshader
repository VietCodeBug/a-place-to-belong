shader_type spatial;
render_mode cull_disabled;
varying float leaf_position;
varying vec3 tint;
void vertex() {
	leaf_position = COLOR.r;
	vec3 eelgrass = mix(vec3(.039,.145,.079),vec3(.17,.34,.17),COLOR.g);
	vec3 milfoil = mix(vec3(.035,.16,.128),vec3(.12,.35,.26),COLOR.g);
	vec3 fans = mix(vec3(.11,.14,.048),vec3(.27,.32,.115),COLOR.g);
	tint = mix(mix(eelgrass,milfoil,smoothstep(0.0,.5,COLOR.b)),fans,smoothstep(.5,1.0,COLOR.b));
	float shift = sin(TIME * 1.08 + MODEL_MATRIX[3].x * .41 + MODEL_MATRIX[3].z*.18 + VERTEX.y*1.8);
	VERTEX.x += shift * (.09+.11*COLOR.b) * leaf_position * leaf_position;
	VERTEX.z += cos(TIME*.90+MODEL_MATRIX[3].z*.71)*.09*leaf_position;
}
void fragment() {
	ALBEDO = tint * (.69 + leaf_position*.49);
	BACKLIGHT = vec3(.018,.044,.028);
	ROUGHNESS = .86;
}

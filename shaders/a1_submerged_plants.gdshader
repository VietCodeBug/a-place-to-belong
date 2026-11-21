shader_type spatial;
render_mode cull_disabled;
varying float leaf_position;
varying vec3 tint;
void vertex() {
	leaf_position = COLOR.r;
	tint = mix(vec3(.043,.16,.065),vec3(.124,.33,.20),COLOR.g);
	float shift = sin(TIME * 1.08 + MODEL_MATRIX[3].x * .41 + MODEL_MATRIX[3].z*.18 + VERTEX.y*1.8);
	VERTEX.x += shift * .11 * leaf_position * leaf_position;
	VERTEX.z += cos(TIME*.90+MODEL_MATRIX[3].z*.71)*.08*leaf_position;
}
void fragment() {
	ALBEDO = tint * (.69 + leaf_position*.49);
	BACKLIGHT = vec3(.018,.044,.028);
	ROUGHNESS = .86;
}

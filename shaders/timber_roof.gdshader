shader_type spatial;
render_mode specular_disabled;
varying float upward_face;
void vertex() { upward_face = abs(NORMAL.y); }
void fragment() {
	ALBEDO = upward_face > 0.18 ? vec3(0.43, 0.52, 0.35) : vec3(0.63, 0.43, 0.29);
	ROUGHNESS = 1.0;
}

shader_type spatial;
render_mode specular_disabled;
varying float upward_face;
varying vec3 local_position;
void vertex() { upward_face = abs(NORMAL.y); local_position = VERTEX; }
void fragment() {
	float variation = sin(local_position.x*7.0+sin(local_position.z*11.0))*sin(local_position.z*5.3)*0.012;
	ALBEDO = upward_face > 0.18 ? vec3(0.32,0.43,0.31)+variation : vec3(0.76,0.69,0.55);
	ROUGHNESS = 1.0;
}

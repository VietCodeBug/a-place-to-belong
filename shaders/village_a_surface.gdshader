shader_type spatial;
uniform vec4 base_tint : source_color = vec4(.66,.62,.51,1.);
uniform float snow = 0.;
uniform float texture_scale = 3.;
varying vec3 world_position;
varying float topness;
void vertex() {
	world_position=(MODEL_MATRIX*vec4(VERTEX,1.)).xyz;
	topness=normalize(MODEL_NORMAL_MATRIX* NORMAL).y;
}
void fragment() {
	float lines=sin(world_position.x*texture_scale + sin(world_position.z*2.3))*sin(world_position.y*4.3+world_position.z*2.1);
	float wear = .95 + lines*.045;
	ALBEDO= mix(base_tint.rgb*wear,vec3(.68,.80,.91),snow*smoothstep(.39,.78,topness));
	ROUGHNESS=.92;
}

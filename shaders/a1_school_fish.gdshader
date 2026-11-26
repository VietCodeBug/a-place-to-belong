shader_type spatial;
render_mode cull_disabled;

void vertex() {
	float tail = pow((1.0-smoothstep(-.48,.19,VERTEX.x)),1.6);
	float phase = TIME * mix(4.0,7.0,INSTANCE_CUSTOM.r) + 18.0 * INSTANCE_CUSTOM.g;
	VERTEX.z += tail * .095 * sin(phase + VERTEX.x * 5.9);
}

void fragment() {
	ALBEDO = COLOR.rgb;
	EMISSION = COLOR.rgb * .054;
	ROUGHNESS = .48;
	SPECULAR = .32;
}

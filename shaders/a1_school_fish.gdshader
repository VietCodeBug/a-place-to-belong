shader_type spatial;
render_mode cull_disabled;

varying float pearl;

void vertex() {
	float tail = pow((1.0-smoothstep(-.48,.19,VERTEX.x)),1.6);
	float phase = TIME * mix(4.0,7.0,INSTANCE_CUSTOM.r) + 18.0 * INSTANCE_CUSTOM.g;
	VERTEX.z += tail * .095 * sin(phase + VERTEX.x * 5.9);
	pearl = INSTANCE_CUSTOM.b;
}

void fragment() {
	ALBEDO = mix(COLOR.rgb,vec3(.58,.81,.79),pearl*.71);
	EMISSION = COLOR.rgb * .054 + vec3(.11,.21,.20)*pearl;
	ROUGHNESS = .48;
	SPECULAR = .32;
}

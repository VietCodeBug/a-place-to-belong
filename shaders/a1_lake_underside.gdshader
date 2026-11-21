shader_type spatial;
render_mode cull_front,unshaded;

varying vec3 world;
void vertex() {
	world = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float weave = .5+.5*sin(world.x*.46+world.z*.37+TIME*.81);
	float ripples = sin(world.x*.74-world.z*.83+TIME*1.25+weave*1.38);
	float glow = pow(.5+.5*ripples,4.0)*(.34+weave*.61);
	float depth = max(0.0,world.y-CAMERA_POSITION_WORLD.y);
	float reach = smoothstep(.72,1.0,UV.x);
	ALBEDO = mix(vec3(.026,.154,.221),vec3(.090,.375,.341),reach)*(1.0+glow*.32);
	ALBEDO *= 1.0-smoothstep(1.5,25.0,depth)*.77;
	ALPHA = .69*(1.0-smoothstep(.992,1.0,UV.x));
}

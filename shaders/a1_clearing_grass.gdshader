shader_type spatial;
render_mode cull_disabled, diffuse_burley, specular_disabled;
varying float blade_height;
varying vec2 patch;
void vertex() {
	blade_height = COLOR.r;
	patch = INSTANCE_CUSTOM.rg;
	vec3 root = MODEL_MATRIX[3].xyz;
	float gust = sin(dot(root.xz,vec2(.19,.13))-TIME*.91) * .5 + .5;
	float flutter = sin(dot(root.xz,vec2(.26,-.28))+TIME*1.37)*.012;
	vec3 push = vec3(.068*gust+flutter,0.0,.038*gust);
	VERTEX += transpose(mat3(MODEL_MATRIX))*push*blade_height*blade_height;
}
void fragment() {
	vec3 bottom = mix(vec3(.115,.171,.053), vec3(.175,.248,.073), patch.y);
	vec3 tip = mix(vec3(.27,.352,.103),vec3(.392,.437,.136),patch.x*.57+patch.y*.43);
	ALBEDO = mix(bottom,tip,blade_height);
	EMISSION = ALBEDO * .11 * blade_height;
	NORMAL=normalize(mix(NORMAL,normalize((VIEW_MATRIX*vec4(0,1,0,0)).xyz),.82));
	ROUGHNESS = .97;
}

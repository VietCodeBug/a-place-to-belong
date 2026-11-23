shader_type spatial;
render_mode cull_disabled, diffuse_burley;

uniform sampler2D petals : source_color,filter_linear_mipmap_anisotropic;
uniform vec4 tint : source_color = vec4(.95,.93,.85,1.0);

void fragment() {
	vec4 paint = texture(petals,UV);
	float cold = smoothstep(.06,.30,paint.b-paint.r) * smoothstep(.08,.31,paint.b-paint.g*.67);
	float luminance = dot(paint.rgb,vec3(.24,.61,.15));
	vec3 muted = mix(paint.rgb,vec3(luminance)*vec3(.89,.96,1.16),cold*.69);
	ALBEDO = muted * tint.rgb;
	ALPHA = paint.a;
	ALPHA_SCISSOR_THRESHOLD = .48;
	ROUGHNESS = .94;
}

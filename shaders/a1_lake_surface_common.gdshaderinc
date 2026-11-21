uniform vec3 sky_zenith : source_color = vec3(.37,.57,.71);
uniform vec3 sky_horizon : source_color = vec3(.62,.73,.75);
uniform float wind_strength = .18;
uniform float rain = 0.0;
varying vec3 world;

void vertex() {
	world = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float reach = UV.x;
	float swell = sin(world.x*.13+world.z*.26+TIME*.95);
	float ripple = cos(world.x*.48-world.z*.70+TIME*1.67+swell*1.4);
	float lean = .67 + .37 * wind_strength + .47 * rain;
	vec3 n = normalize(vec3(ripple*.049*lean,1.0,swell*.055*lean));
	vec3 eye = normalize(CAMERA_POSITION_WORLD-world);
	float grazing = 1.0-clamp(dot(eye,n),0.0,1.0);
	float fresnel = grazing*grazing*grazing;
	vec3 reflection = reflect(-eye,n);
	vec3 sky = mix(sky_horizon,sky_zenith,smoothstep(.06,.79,max(0.0,reflection.y)));
	float shallow = smoothstep(.80,1.0,reach);
	vec3 deep = vec3(.035,.142,.186);
	vec3 clear = vec3(.039,.235,.202);
	float streak = smoothstep(.93,1.0,ripple)*smoothstep(.18,.85,grazing)*(.019+.018*swell);
	float foam = smoothstep(.975,.996,reach)*(1.0-smoothstep(.996,1.0,reach));
	foam *= smoothstep(.38,.91,swell*.55+ripple*.45);
	ALBEDO = mix(mix(deep,clear,shallow),sky*.77,.11+fresnel*.75) + vec3(.65,.80,.80)*streak + foam*.10;
#ifndef A1_LAKE_DEEP
	float direct = smoothstep(.865,1.0,reach);
	ALPHA = (1.0-smoothstep(.999,1.0,reach)) * mix(1.0,.21+.36*fresnel,direct);
#endif
}

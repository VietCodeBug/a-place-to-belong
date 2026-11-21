shader_type spatial;
render_mode cull_disabled, diffuse_burley;

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
	float broad = world.x * .14 + world.z * .28 + TIME * 1.11 + sin(world.x*.115-world.z*.15)*1.6;
	float narrow = world.z * .77 - world.x * .42 - TIME * 1.43;
	float curl = cos(world.x * .44 + world.z * .58 + TIME * 1.67);
	vec2 slope = vec2(cos(broad) * .046 + cos(narrow) * .022, sin(broad) * .055 + curl * .027);
	slope *= .50 + wind_strength + rain*.65;
	vec3 surface_normal = normalize(vec3(slope.x, 1.0, slope.y));
	vec3 viewer = normalize(CAMERA_POSITION_WORLD - world);
	float fresnel = pow(1.0 - abs(dot(viewer, surface_normal)), 4.5);
	float rim = smoothstep(.81, 1.0, reach);
	float shore = smoothstep(.955, 1.0, reach);
	vec3 reflection = reflect(-viewer, surface_normal);
	vec3 sky = mix(sky_horizon.rgb, sky_zenith.rgb, smoothstep(.03, .63, abs(reflection.y)));
	float sun_glint = pow(max(0.0,dot(reflection,normalize(vec3(-.55,.51,-.65)))),64.0);
	vec3 basin = mix(vec3(.024,.117,.151),vec3(.057,.237,.227),rim);
	vec3 reflected = sky * (.40 + .038 * sin(broad*.67)) + vec3(.88,.75,.49)*sun_glint*.45;
	if (viewer.y < 0.0) {
		reflected = vec3(.15,.42,.48) * (.73 + curl*.13);
	}
	float lip = smoothstep(.97,.998,reach) * (1.0-smoothstep(.998,1.0,reach));
	lip *= .25+.45*smoothstep(.12,.64,cos(narrow*.60+sin(broad)));
	ALBEDO = mix(basin,reflected,.12+.74*fresnel) + lip*vec3(.20,.23,.20);
	NORMAL = (VIEW_MATRIX * vec4(surface_normal,0.0)).xyz;
	ROUGHNESS = .25 + rain*.20;
	SPECULAR = .45;
	ALPHA = (1.0-smoothstep(.996,1.0,reach)) * clamp(mix(.95,.30,shore)+.27*fresnel,0.0,1.0);
}

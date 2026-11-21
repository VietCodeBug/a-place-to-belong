shader_type spatial;
uniform int season = 1;
uniform bool panorama = false;
varying float tree_height;
varying float tree_distance;

void vertex() {
	tree_height = VERTEX.y;
	tree_distance = distance(MODEL_MATRIX[3].xz, CAMERA_POSITION_WORLD.xz);
}

void fragment() {
	if (panorama && tree_distance < 236.0 && CAMERA_POSITION_WORLD.y < 220.0) {
		discard;
	}
	float crown = smoothstep(.12,.60,tree_height);
	vec3 foliage = COLOR.rgb;
	if (season == 0) {
		foliage = mix(foliage, vec3(.34,.21,.079), .46);
	} else if (season == 3) {
		foliage = mix(foliage, vec3(.42,.52,.48), .44);
	} else if (season == 2) {
		foliage *= vec3(.82,.93,.82);
	}
	ALBEDO = mix(vec3(.088,.065,.044),foliage * mix(.61,1.08,tree_height),crown);
	ROUGHNESS = .94;
	SPECULAR = .10;
}

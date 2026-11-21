shader_type spatial;
uniform int season = 1;
uniform bool panorama = false;
uniform bool hidden_for_profile = false;
varying float tree_height;

void vertex() {
	tree_height = VERTEX.y;
	if (hidden_for_profile) {
		POSITION = vec4(2.0,2.0,2.0,1.0);
	} else if (panorama && CAMERA_POSITION_WORLD.y < 220.0) {
		vec2 offset = MODEL_MATRIX[3].xz-CAMERA_POSITION_WORLD.xz;
		float distance_sq = dot(offset,offset);
		if (distance_sq < 245.0*245.0 || distance_sq > 1600.0*1600.0) {
			POSITION = vec4(2.0,2.0,2.0,1.0);
		} else {
			POSITION = PROJECTION_MATRIX*MODELVIEW_MATRIX*vec4(VERTEX,1.0);
		}
	} else {
		POSITION = PROJECTION_MATRIX*MODELVIEW_MATRIX*vec4(VERTEX,1.0);
	}
}

void fragment() {
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

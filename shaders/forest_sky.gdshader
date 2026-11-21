shader_type sky;

uniform vec4 top_color : source_color = vec4(0.30, 0.56, 0.80, 1.0);
uniform vec4 horizon_color : source_color = vec4(0.93, 0.80, 0.64, 1.0);
uniform vec4 cloud_color : source_color = vec4(0.99, 0.95, 0.88, 1.0);
uniform vec4 cloud_shadow_color : source_color = vec4(0.62, 0.70, 0.80, 1.0);
uniform vec3 sun_direction = vec3(0.5, 0.3, 0.5);
uniform vec3 moon_direction = vec3(-0.5, 0.3, -0.5);
uniform float daylight = 1.0;
uniform float cloud_cover = 0.43;
uniform float cloud_clock = 0.0;
uniform vec2 wind_direction = vec2(0.85, 0.52);

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise2(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(
		mix(hash(i), hash(i + vec2(1.0, 0.0)), f.x),
		mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), f.x),
		f.y
	);
}

// Billowing rounded puff field for stylized cumulus silhouettes
float puff_noise(vec2 p) {
	float n = noise2(p);
	float billow = 1.0 - abs(n * 2.0 - 1.0);
	return mix(n, pow(billow, 0.75), 0.52);
}

float cumulus_field(vec2 p) {
	vec2 warp = vec2(noise2(p * 0.45 + 5.2), noise2(p * 0.45 + 13.7)) * 0.55;
	vec2 q = p + warp;
	float base = puff_noise(q) * 0.56;
	base += puff_noise(q * 2.05 + vec2(4.1, 7.3)) * 0.28;
	base += noise2(q * 4.15 + vec2(11.4, 2.9)) * 0.16;
	return base;
}

void sky() {
	float height = clamp(EYEDIR.y, 0.0, 1.0);
	vec3 sky_grad = mix(horizon_color.rgb, top_color.rgb, pow(height, 0.52));
	// Soft warm horizon glow band
	float horizon_band = exp(-max(EYEDIR.y, 0.0) * 7.5);
	sky_grad = mix(sky_grad, horizon_color.rgb * .97, horizon_band * 0.19);
	vec3 color = sky_grad;

	if (!AT_CUBEMAP_PASS) {
		vec3 sun_dir = normalize(sun_direction);
		vec3 moon_dir = normalize(moon_direction);
		float sun_dot = dot(EYEDIR, sun_dir);

		// Subtle nighttime starfield in clear sky above horizon
		if (daylight < 0.42 && EYEDIR.y > 0.04) {
			vec2 star_uv = EYEDIR.xz / (EYEDIR.y + 0.35) * 68.0;
			vec2 cell = floor(star_uv);
			vec2 local = fract(star_uv) - 0.5;
			float rnd = hash(cell);
			if (rnd > 0.962) {
				vec2 jitter = vec2(hash(cell + 7.1), hash(cell + 19.3)) - 0.5;
				float d = length(local - jitter * 0.55);
				float twinkle = 0.68 + 0.32 * sin(cloud_clock * (1.4 + rnd * 2.2) + rnd * 40.0);
				float star = smoothstep(0.085, 0.012, d) * twinkle * (1.0 - smoothstep(0.05, 0.40, daylight));
				star *= smoothstep(0.04, 0.22, EYEDIR.y) * (1.0 - smoothstep(0.55, 0.92, cloud_cover));
				color += vec3(0.92, 0.95, 1.0) * star * 0.78;
			}
		}

		// Perspective sky dome projection for clouds
		vec2 wind = normalize(wind_direction);
		vec2 dome = EYEDIR.xz / max(0.16, EYEDIR.y + 0.21) * 2.65;
		vec2 drift_main = wind * cloud_clock * 0.0085;
		vec2 drift_high = wind * cloud_clock * 0.0045;

		// High distant cirrus/altocumulus deck (adds depth behind main puffs)
		float high_raw = cumulus_field(dome * 0.58 + vec2(18.0, 9.0) - drift_high);
		float high_thresh = mix(0.80, 0.39, cloud_cover);
		float high_cloud = smoothstep(high_thresh, high_thresh + 0.14, high_raw) * 0.48;
		high_cloud *= smoothstep(0.02, 0.18, EYEDIR.y);

		// Main sculpted stylized cumulus deck
		float main_raw = cumulus_field(dome - drift_main);
		// Sample slightly offset toward sun & zenith for 3D puff self-lighting
		float lit_sample = cumulus_field(dome - drift_main - normalize(sun_dir.xz + vec2(0.001)) * 0.14 - vec2(0.0, 0.08));
		float thresh = mix(0.82, 0.31, cloud_cover);
		float main_cloud = smoothstep(thresh, thresh + 0.155, main_raw) * 0.76;
		main_cloud *= smoothstep(0.005, 0.15, EYEDIR.y);

		// 3-tone stylized cloud shading: shadow belly, soft body, sunlit crest + silver lining
		float crest_lit = clamp((main_raw - lit_sample) * 3.4 + 0.52, 0.0, 1.0);
		float thickness = smoothstep(thresh, thresh + 0.28, main_raw);
		vec3 belly = mix(cloud_shadow_color.rgb, top_color.rgb * 0.82, 0.43);
		vec3 crown = cloud_color.rgb * mix(1.02, 1.12, daylight);
		// Quantize gently into soft painterly bands while keeping smooth anti-aliased transitions
		float band = mix(crest_lit, smoothstep(0.25, 0.78, crest_lit), 0.65);
		vec3 main_col = mix(belly, cloud_color.rgb, smoothstep(0.08, 0.55, band));
		main_col = mix(main_col, crown, smoothstep(0.58, 0.92, band) * (1.0 - thickness * 0.22));

		// Warm silver-lining glow near sun
		float lining = pow(max(sun_dot, 0.0), 10.0) * (1.0 - thickness * 0.65) * daylight;
		main_col += vec3(1.0, 0.84, 0.56) * lining * 0.28;

		vec3 high_col = mix(belly, crown, 0.68);
		color = mix(color, high_col, high_cloud);
		color = mix(color, main_col, main_cloud);

		float total_cloud = clamp(max(main_cloud, high_cloud * 0.8), 0.0, 1.0);

		// Sun halo & crisp stylized disc
		color += vec3(1.0, 0.78, 0.46) * pow(max(sun_dot, 0.0), 72.0) * 0.18 * daylight * (1.0 - total_cloud * 0.85);
		float sun_disk = smoothstep(cos(0.010), cos(0.007), sun_dot) * daylight * (1.0 - total_cloud * 0.92);
		color = mix(color, vec3(1.0, 0.93, 0.76), sun_disk);

		// Moon soft silver halo & disc
		float moon_dot = dot(EYEDIR, moon_dir);
		color += vec3(0.58, 0.72, 0.92) * pow(max(moon_dot, 0.0), 90.0) * 0.12 * (1.0 - daylight) * (1.0 - total_cloud * 0.8);
		float moon_disk = smoothstep(cos(0.012), cos(0.009), moon_dot) * (1.0 - daylight) * (1.0 - total_cloud * 0.9);
		color = mix(color, vec3(0.86, 0.91, 0.98), moon_disk * 0.92);
	}

	COLOR = color;
}

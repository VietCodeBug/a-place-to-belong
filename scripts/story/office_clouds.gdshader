shader_type sky;

uniform float flash = 0.0;

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
	vec2 grid = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash(grid), hash(grid + vec2(1.0, 0.0)), f.x),
		mix(hash(grid + vec2(0.0, 1.0)), hash(grid + 1.0), f.x), f.y);
}

void sky() {
	float elevation = max(EYEDIR.y, 0.0);
	vec2 p = EYEDIR.xz / (0.31 + elevation) * 2.95;
	float storm = noise(p) * 0.62 + noise(p * 2.11) * 0.26 + noise(p * 4.24) * 0.12;
	float rim = 1.0 - smoothstep(0.0, 0.49, abs(EYEDIR.y));
	vec3 horizon = vec3(0.40, 0.47, 0.53);
	vec3 shelf = mix(vec3(0.16, 0.22, 0.29), vec3(0.29, 0.36, 0.43), storm);
	COLOR = mix(shelf, horizon, rim * 0.84) + flash * vec3(0.26, 0.32, 0.42);
}

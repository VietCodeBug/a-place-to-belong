float lake_caustic(vec2 p, float t) {
	vec2 a = sin(p * 1.34 + vec2(t * 1.08, -t * .81));
	vec2 b = cos(vec2(p.x + p.y, p.y - p.x) * .82 + a + vec2(-t, t * .78));
	return smoothstep(.78, .97, .55 * abs(b.x) + .45 * abs(b.y));
}

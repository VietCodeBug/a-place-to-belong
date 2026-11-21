float lake_caustic(vec2 p, float t) {
	vec2 curve = vec2(sin(p.x*.26+p.y*.31-t*.48),cos(p.y*.30-p.x*.24+t*.57));
	vec2 waves = p * 3.65 + curve*.46;
	float a = abs(sin(waves.x + cos(waves.y*.87 + t*.51)*1.29 + t*.55));
	float b = abs(cos(waves.y + sin(waves.x*.71-t*.43)*.93 - t*.47));
	return smoothstep(.66,.99,1.0-min(a,b))*(.35+.65*smoothstep(-.4,.74,curve.x));
}

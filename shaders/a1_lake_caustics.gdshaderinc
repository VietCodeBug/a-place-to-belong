float lake_caustic(vec2 p, float t) {
	// Closely spaced highlights break up under broad moving shadows.
	vec2 bend = vec2(sin(p.x*.51+p.y*.41-t*.49),cos(p.y*.37-p.x*.46+t*.58));
	vec2 wave = p * 6.45 + bend*.51;
	float a = abs(sin(wave.x+cos(wave.y*.79+t*.47)*1.41+t*.55));
	float b = abs(cos(wave.y+sin(wave.x*.68-t*.46)*1.17-t*.43));
	float fine = 1.0-smoothstep(.10,1.25,max(length(dFdx(wave)),length(dFdy(wave))));
	return smoothstep(.79,.99,1.0-min(a,b))*smoothstep(-.62,.85,bend.x)*fine;
}

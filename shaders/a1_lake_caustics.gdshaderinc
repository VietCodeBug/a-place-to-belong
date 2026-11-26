float lake_caustic(vec2 p, float t) {
	// Broad warped strands suggest refracted light without a fullscreen texture.
	vec2 bend = vec2(sin(p.x*.76+p.y*.49-t*.64),cos(p.y*.86-p.x*.53+t*.58));
	vec2 wave = p * 3.1 + bend*.74;
	float a = abs(sin(wave.x+cos(wave.y*.73+t*.48)*1.3+t*.49));
	float b = abs(cos(wave.y+sin(wave.x*.71-t*.51)*1.17-t*.58));
	float thread = 1.0-min(a,b);
	float soft = smoothstep(.64,.99,thread);
	float fine = 1.0-smoothstep(.16,1.6,max(length(dFdx(wave)),length(dFdy(wave))));
	return soft * (.53+.47*smoothstep(-.66,.86,bend.x)) * fine;
}

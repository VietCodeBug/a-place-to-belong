shader_type spatial;
uniform vec4 tint : source_color = vec4(.49,.30,.18,1.0);
uniform int finish = 0;
uniform bool vertical = false;
varying vec3 p;
void vertex(){p=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;}
float hash21(vec2 q){return fract(sin(dot(q,vec2(23.17,37.31)))*43758.54);}
float value_noise(vec2 q){
	vec2 i=floor(q); vec2 f=fract(q); f=f*f*(3.0-2.0*f);
	return mix(mix(hash21(i),hash21(i+vec2(1,0)),f.x),mix(hash21(i+vec2(0,1)),hash21(i+vec2(1,1)),f.x),f.y);
}
void fragment(){
	vec2 grain=vertical ? vec2(p.x+p.z*.31,p.y) : vec2(p.x+p.y*.53,p.z);
	float color_variation=1.0;
	if(finish==0){
		float bend=value_noise(grain*vec2(.8,1.6))*.085;
		float line=sin((grain.x+bend)*104.0+sin(grain.y*4.5)*.65);
		color_variation=.83+.24*value_noise(grain*vec2(33.0,2.1))+.051*line;
	}else if(finish==1){
		color_variation=.90+.16*value_noise(grain*3.7)+.055*value_noise(grain*28.0);
	}else{
		color_variation=.88+.17*value_noise(grain*7.0)+.09*value_noise(grain*54.0);
	}
	ALBEDO=tint.rgb*color_variation;
	ROUGHNESS=.92;
	SPECULAR=.19;
}

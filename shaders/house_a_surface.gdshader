shader_type spatial;

uniform vec4 tint : source_color = vec4(.49,.30,.18,1.0);
uniform int finish = 0;
uniform bool vertical = false;
uniform bool exterior = false;
uniform float wear : hint_range(0.0,1.0) = 0.0;
uniform float snow : hint_range(0.0,1.0) = 0.0;

varying vec3 p;
varying vec3 surface_normal;

void vertex() {
	// The GLB's vertices share shell coordinates. The room uses its own world coordinates.
	p = exterior ? VERTEX : (MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;
	surface_normal = exterior ? NORMAL : normalize(MODEL_NORMAL_MATRIX*NORMAL);
}

float hash21(vec2 q) { return fract(sin(dot(q,vec2(23.17,37.31)))*43758.54); }

float value_noise(vec2 q) {
	vec2 i = floor(q);
	vec2 f = fract(q);
	f = f*f*(3.0-2.0*f);
	return mix(mix(hash21(i),hash21(i+vec2(1,0)),f.x),mix(hash21(i+vec2(0,1)),hash21(i+vec2(1,1)),f.x),f.y);
}

float mottle(vec2 point) {
	return value_noise(point)*.68+value_noise(point*2.8+vec2(7.2,4.6))*.32;
}

float hearth_soot(vec3 spot) {
	return (1.0-smoothstep(0.09,.52,abs(spot.x+4.37)))
		* (1.0-smoothstep(.35,1.22,abs(spot.z-1.73))) * smoothstep(.98,1.76,spot.y);
}

vec3 aged_plaster(vec3 color, vec2 face) {
	float broad = mottle(face*2.35+vec2(3.0,0.0));
	float fine = value_noise(face*31.0);
	float runs = smoothstep(.57,.81,value_noise(face*vec2(12.0,1.48)+vec2(3.7,5.1)));
	float damp_height = (exterior ? .91 : .49)+broad*(exterior ? .64 : .41);
	float damp = (1.0-smoothstep(.12,damp_height,p.y))*smoothstep(.23,.72,broad+runs*.14);
	float sill_trace = 0.0;
	if (!exterior) {
		float window_distance = min(abs(p.x+2.84),min(abs(p.x-.37),abs(p.x-3.03)));
		sill_trace = (1.0-smoothstep(.10,.27,abs(p.z+3.64)))
			* (1.0-smoothstep(.21,.68,window_distance)) * (1.0-smoothstep(.89,1.05,p.y)) * runs*.46;
	}
	vec3 faded = mix(color,color*vec3(.81,.82,.76),.25+broad*.43);
	float lift = mottle(face*5.6+vec2(15.7,9.1))+(damp+sill_trace)*.32+runs*.025;
	float lift_edge = exterior ? .73 : .80;
	float chip = smoothstep(lift_edge,lift_edge+.066,lift);
	float chip_lip = smoothstep(lift_edge-.036,lift_edge,lift)-chip;
	vec3 base_coat = mix(color*.74,vec3(.196,.151,.103),.31)*(.87+fine*.23);
	faded = mix(faded,base_coat,chip*(exterior ? .60 : .48));
	faded += chip_lip*.014;
	float speckles = smoothstep(.51,.79,mottle(face*13.2+vec2(4.2,10.7)));
	vec3 moss = mix(vec3(.139,.145,.095),vec3(.101,.134,.078),speckles);
	vec3 marked = mix(faded,moss,(damp+sill_trace)*(.33+speckles*.32));
	return mix(marked,marked*vec3(.53,.48,.41),exterior ? 0.0 : hearth_soot(p)*.72);
}

vec3 aged_wood(vec3 color,vec2 grain) {
	float bleached = mottle(grain*vec2(5.7,2.7));
	float abrasion = smoothstep(.55,.82,value_noise(grain*vec2(39.0,3.8)));
	float dirt = smoothstep(.38,.78,mottle(grain*2.9+vec2(8.3,13.1)));
	vec3 worn = color*mix(vec3(.70,.71,.65),vec3(1.11,1.17,1.18),bleached);
	if (exterior) worn *= .83;
	worn = mix(worn,worn*.68,dirt*.29);
	float tread = 0.0;
	if (!exterior && p.y<.05) {
		float path = (1.0-smoothstep(.32,1.16,abs(p.x+.27)))*smoothstep(.8,3.3,p.z);
		float kitchen = (1.0-smoothstep(.23,.83,abs(p.x-3.12)))*(1.0-smoothstep(.74,1.95,abs(p.z+2.39)));
		tread = max(path,kitchen);
	}
	vec3 scuffed = mix(color*vec3(1.11,1.15,1.14),vec3(.349,.247,.158),.30);
	return mix(worn,scuffed,.19*abrasion+.40*tread*(.44+abrasion*.56));
}

vec3 chipped_paint(vec3 color,vec2 face) {
	float streak = mottle(face*vec2(30.0,7.3)+vec2(10.0,4.4));
	float uneven = mottle(face*4.7+vec2(.9,5.9));
	float loss = streak+smoothstep(.47,.79,uneven)*.16;
	float peel = smoothstep(.70,.835,loss);
	float rim = smoothstep(.65,.70,loss)-peel;
	vec3 washed_paint = mix(color,color*vec3(.78,.84,.75),uneven*.66);
	vec3 bare = mix(vec3(.167,.120,.080),vec3(.275,.185,.112),uneven);
	return mix(washed_paint+rim*.030,bare,peel*.76);
}

vec3 aged_stone(vec3 color,vec3 normal) {
	vec2 bank = p.xz+vec2(p.y*.28,p.y*.51);
	float growth = smoothstep(.51,.76,mottle(bank*2.63+vec2(7.8,1.4)));
	float speck = value_noise(bank*34.0);
	if (exterior) {
		float low = 1.0-smoothstep(.20,1.37,p.y);
		float eave = smoothstep(1.87,2.80,p.y)*(1.0-smoothstep(3.22,4.30,p.y))*smoothstep(.13,.52,normal.y);
		vec3 moss = mix(vec3(.111,.134,.072),vec3(.213,.241,.122),speck);
		return mix(color*vec3(.87,.86,.79),moss,growth*(low*.67+eave*.77));
	}
	float rings = smoothstep(.67,.83,mottle(bank*13.0))*growth;
	return mix(color*vec3(.90,.88,.79),color*vec3(.48,.42,.34),rings*.34+hearth_soot(p)*.64);
}

void fragment() {
	vec3 normal = normalize(surface_normal);
	vec2 face = vec2(abs(normal.x)>abs(normal.z) ? p.z : p.x,p.y);
	vec2 grain = vertical ? face : vec2(p.x+p.y*.53,p.z);
	float variation = 1.0;
	if (finish==0 || finish==4) {
		float bend = value_noise(grain*vec2(2.0,1.6))*.078;
		float band = value_noise(vec2((grain.x+bend)*24.0,grain.y*5.3));
		float line = sin((grain.x+bend)*143.0+sin(grain.y*5.2)*.81);
		variation = .88+.13*band+.02*line+.055*value_noise(grain*vec2(5.0,1.6));
	} else if (finish==1 || finish==5) {
		variation = .90+.16*value_noise(grain*3.7)+.055*value_noise(grain*28.0);
	} else if (finish==3) {
		vec2 cells = abs(fract(grain*11.0)-.5);
		float band = 1.0-smoothstep(.022,.089,abs(cells.x+cells.y-.33));
		float weave = sin(grain.x*580.0)*sin(grain.y*510.0);
		variation = .90+band*.11+weave*.027+value_noise(grain*8.0)*.07;
	} else {
		variation = .88+.17*value_noise(grain*7.0)+.09*value_noise(grain*54.0);
	}
	vec3 color = tint.rgb*variation;
	if (wear>.001) {
		vec3 worn = color;
		if (finish==0) worn = aged_wood(color,grain);
		else if (finish==1) worn = aged_plaster(color,face);
		else if (finish==4) worn = chipped_paint(color,face);
		else if (finish==5) worn = aged_stone(color,normal);
		else if (finish==6) {
			float oxidation = smoothstep(.35,.76,mottle(grain*17.0));
			worn = mix(color*.78,vec3(.230,.117,.063),oxidation*.59);
		} else {
			float stains = smoothstep(.39,.75,mottle(grain*6.4+vec2(14.3,1.2)));
			float weave_loss = smoothstep(.50,.81,value_noise(grain*vec2(35.0,6.0)));
			vec3 faded = mix(color,vec3(dot(color,vec3(.30,.56,.14))),.30);
			worn = faded*(.90-.24*stains+.10*weave_loss);
		}
		color = mix(color,worn,wear);
	}
	ALBEDO = mix(color,vec3(.68,.80,.91),snow*smoothstep(.39,.78,normal.y));
	ROUGHNESS = mix(.87,.98,wear);
	SPECULAR = .18;
}

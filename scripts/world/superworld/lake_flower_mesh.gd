extends RefCounted
## Thin curved leaves and petals share one surface and a height-weighted sway.

const OUTSIDE := [Vector2i(0,0),Vector2i(1,0),Vector2i(0,1),Vector2i(0,1),Vector2i(1,0),Vector2i(1,1)]
const INSIDE := [Vector2i(0,0),Vector2i(0,1),Vector2i(1,0),Vector2i(0,1),Vector2i(1,1),Vector2i(1,0)]
const STEM_COLORS := [Color("3F705D"),Color("365C71"),Color("585F5A"),Color("3C705E")]
const HEIGHTS := [.97,1.68,1.16,.54]

var mesh := SurfaceTool.new()
var height: float
var bulb_vertices: PackedVector3Array
var bulb_indices: PackedInt32Array

func build(kind: int) -> ArrayMesh:
	height = HEIGHTS[kind]
	mesh.begin(Mesh.PRIMITIVE_TRIANGLES)
	var seed_mesh := SphereMesh.new()
	seed_mesh.radial_segments = 6
	seed_mesh.rings = 2
	seed_mesh.radius = .5
	seed_mesh.height = 1.0
	var arrays := seed_mesh.surface_get_arrays(0)
	bulb_vertices = arrays[Mesh.ARRAY_VERTEX]
	bulb_indices = arrays[Mesh.ARRAY_INDEX]
	match kind:
		0: lily()
		1: bell_stalk()
		2: pearl_spike()
		3: rosette()
	mesh.generate_normals()
	mesh.index()
	return mesh.commit()

func heading(angle: float) -> Vector3:
	return Vector3(cos(angle),0,sin(angle))

func put(at: Vector3, tint: Color, uv: Vector2, glow: float, vein: float) -> void:
	tint.a = clampf(at.y/(height+.08),0,1)
	mesh.set_color(tint)
	mesh.set_uv(uv)
	mesh.set_uv2(Vector2(glow,vein))
	mesh.add_vertex(at)

func petal(root: Vector3, ray: Vector3, span: Vector3, throat: Color, rim: Color,
		curl: float, glow: float, rows := 9, columns := 4) -> void:
	var forward := ray.normalized()
	var side := forward.cross(Vector3.UP).normalized()
	var up := side.cross(forward).normalized()
	for row in rows:
		for col in columns:
			for corner: Vector2i in OUTSIDE:
				var t := .5-.5*cos(float(row+corner.x)*PI/rows)
				var across := (float(col+corner.y)/columns)*2.0-1.0
				var fullness := pow(maxf(0.0,sin(t*PI)),.52)
				var width := span.y*maxf(.016,fullness)*(.68+.58*t)
				var cup := span.z*t*t + span.x*.043*fullness
				cup += span.y*(.26*across*across+curl*across*.62)*fullness
				cup += span.y*.10*pow(absf(across),4.0)*sin(t*14.0+curl*9.0)*fullness
				var length := span.x*(t-.12*across*across*t*fullness)
				var sweep := across*width+span.y*curl*.76*t*fullness
				var at := root+forward*length+side*sweep+up*cup
				var edge := smoothstep(.45,1.0,absf(across))*smoothstep(.13,.90,t)
				var fade := smoothstep(.05,.94,t)
				var tint := throat.lerp(rim,fade*.86+edge*.14)
				var warm_edge := .15*edge+.12*smoothstep(.70,1.0,t)
				put(at,tint,Vector2(t,across*.5+.5),glow*warm_edge,1.0 if glow>0.0 else .53)

func bud(center: Vector3, size: Vector3, tint: Color, glow: float) -> void:
	for index in bulb_indices:
		var p := bulb_vertices[index]
		var face := smoothstep(-.4,.5,p.y)
		put(center+size*p,tint.lerp(tint.lightened(.13),face),Vector2(.61,.5),glow*(.50+face*.50),0)

func tube(from: Vector3, to: Vector3, r0: float, r1: float, tint: Color) -> void:
	var forward := from.direction_to(to)
	var axis := forward.cross(Vector3.RIGHT).normalized()
	var tangent := axis.cross(forward)
	for i in 7:
		for corner: Vector2i in OUTSIDE:
			var angle := float((i+corner.y)%7)*TAU/7.0
			var rim := axis*cos(angle)+tangent*sin(angle)
			var t := float(corner.x)
			var at := from.lerp(to,t)+rim*lerpf(r0,r1,t)
			put(at,tint,Vector2(t,.5),0,0)

func stem_point(t: float, lean: float) -> Vector3:
	return Vector3(lean*t*t,height*t,.15*sin(t*2.5)*t)

func stem(tint: Color, lean: float, leaf_count: int) -> void:
	for row in 8:
		for i in 8:
			for corner: Vector2i in INSIDE:
				var t := float(row+corner.x)/8.0
				var at := stem_point(t,lean)+heading(float((i+corner.y)%8)*TAU/8.0)*lerpf(.034,.014,t)
				put(at,tint.lerp(tint.lightened(.12),t),Vector2(t,.5),0,0)
	for i in leaf_count:
		var t := .20+float(i)*.55/maxi(1,leaf_count-1)
		var ray := heading(.69+float(i)*2.52).lerp(Vector3.UP,.23)
		var span := Vector3(.37-.023*i,.077-.007*i,.05)
		petal(stem_point(t,lean),ray,span,tint.darkened(.14),tint.lightened(.33),-.13,.0,6,3)

func lily() -> void:
	var green: Color = STEM_COLORS[0]
	stem(green,-.13,2)
	var top := stem_point(1.0,-.13)
	var throat := Color("68856B")
	for layer in 3:
		var count: int = [10,8,6][layer]
		var lengths: Vector3 = [Vector3(.62,.199,.12),Vector3(.47,.156,.158),Vector3(.29,.10,.18)][layer]
		var rim: Color = [Color("C3CDB2"),Color("E0D5B9"),Color("DAD8BB")][layer]
		var rows: int = [10,8,7][layer]
		var columns: int = [5,4,3][layer]
		for i in count:
			var ray := heading((float(i)+.42*layer)*TAU/count+.058*sin(i*3.2))
			var twist := .19*sin(i*2.96+layer)
			var span := lengths*Vector3(.89+.13*cos(i*2.76),.92+.09*sin(i*3.8),.98+.19*sin(i*1.8))
			petal(top+ray*(.043-layer*.009)+Vector3.UP*(.021*layer),ray,span,throat,rim,twist,.49,rows,columns)
	bud(top+Vector3.UP*.072,Vector3(.29,.141,.29),Color("9EAA76"),.20)
	for i in 14:
		var ray := heading(float(i)*TAU/14.0)
		var stem_start := top+ray*.076+Vector3.UP*.088
		var tip := top+ray*(.139+.021*cos(i*1.7))+Vector3.UP*(.122+.037*sin(i*2.9))
		tube(stem_start,tip,.009,.006,Color("9AAB6E"))
		bud(tip,Vector3(.037,.026,.031),Color("DBBD80"),.26)

func bell_stalk() -> void:
	var blue: Color = STEM_COLORS[1]
	stem(blue,.55,4)
	for i in 6:
		var t := .42+i*.105
		var ray := heading(i*2.22+.36)
		var joint := stem_point(t,.55)
		var crown := joint+ray*(.25-.024*i)+Vector3.UP*.074
		var axis := (ray*.64+Vector3.DOWN*.77).normalized()
		var size := 1.05-i*.066
		tube(joint,crown,.017,.010,blue.lightened(.17))
		bell(crown,axis,size)
	bud(stem_point(1.0,.55),Vector3(.091,.15,.08),Color("6F82AB"),.14)

func bell(root: Vector3, axis: Vector3, size: float) -> void:
	var spoke := axis.cross(Vector3.UP).normalized()
	var front := spoke.cross(axis)
	for row in 6:
		for i in 25:
			for corner: Vector2i in OUTSIDE:
				var t := float(row+corner.x)/6.0
				var turn := float((i+corner.y)%25)*TAU/25.0
				var ruffle := (.5-.5*cos(turn*5.0))*smoothstep(.53,1.0,t)
				var radius := .034+.084*sin(t*PI*.68)+.052*pow(t,5.0)+.019*ruffle
				var length := .329*t+.049*ruffle
				var ring := spoke*cos(turn)+front*sin(turn)
				var at := root+(ring*radius+axis*length)*size
				var tint := Color("596A9C").lerp(Color("A5B9DD"),smoothstep(.1,1.0,t))
				tint = tint.lerp(Color("BAC1DA"),ruffle*.19)
				var uv := Vector2(t,(float(i%5)+float(corner.y))/5.0)
				put(at,tint,uv,.01+.19*pow(t,5.0),.43)
	var heart := root+axis*(.279*size)
	tube(root+axis*.16*size,heart,.011*size,.009*size,Color("7898AF"))
	bud(heart,Vector3(.035,.050,.035)*size,Color("C4CEAD"),.29)

func pearl_spike() -> void:
	var rust: Color = STEM_COLORS[2]
	stem(rust,.35,3)
	for i in 10:
		var t := .35+i*.071
		var joint := stem_point(t,.35)
		var ray := heading(i*2.36)
		var tip := joint+ray*(.21*(1.1-t*.59))+Vector3.UP*.087
		tube(joint,tip,.014,.007,rust.lightened(.23))
		if i in [0,2,3,5,6,8]:
			var size := lerpf(1.04,.64,t)
			for j in 5:
				var petal_ray := heading(j*TAU/5.0+.14*i).lerp(Vector3.UP,.27)
				petal(tip,petal_ray,Vector3(.129,.054,.075)*size,Color("946D75"),Color("D3B3A2"),.13,.42,6,3)
			bud(tip+Vector3.UP*.037,Vector3(.056,.055,.056),Color("CFB77B"),.31)
		else:
			bud(tip,Vector3(.063,.097,.058),Color("AD9B91"),.16)

func rosette() -> void:
	for i in 9:
		var ray := heading(i*2.40)
		var root := ray*.025+Vector3.UP*.02
		var lean := .39+.13*sin(i*1.62)
		var span := Vector3(.52+.10*cos(i*2.6),.13+.017*sin(i*3.13),.03+.15*sin(i*1.99))
		petal(root,ray.lerp(Vector3.UP,lean),span,Color("315B4F"),Color("609480"),.15*cos(i*2.72),0,7,3)

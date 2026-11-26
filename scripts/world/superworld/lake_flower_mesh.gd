extends RefCounted
## Three shared meshes with gently cupped petals and a weighted sway from the stem.

const PETAL_ROWS := 8
const PETAL_COLUMNS := 4
const STEM_SIDES := 8

const RIM_COLORS := [Color("C4E5D5"), Color("91CDDD"), Color("A7DCCF")]
const THROAT_COLORS := [Color("508C82"), Color("426D93"), Color("3D877B")]
const STEM_COLORS := [Color("356F65"), Color("355F70"), Color("3D796A")]

var mesh := SurfaceTool.new()
var height: float

func build(kind: int) -> ArrayMesh:
	height = [1.58,1.51,1.25][kind]
	mesh.begin(Mesh.PRIMITIVE_TRIANGLES)
	stalk(kind)
	var top := stalk_point(1.0)
	var throat: Color = THROAT_COLORS[kind]
	var rim: Color = RIM_COLORS[kind]
	for i in [8,7,9][kind]:
		var ray := heading(float(i)*TAU/[8.0,7.0,9.0][kind])
		var length: float = [.65,.55,.58][kind]*(.93+.07*sin(i*2.7))
		var width: float = [.191,.198,.152][kind]*(.95+.09*cos(i*1.9))
		var rise: float = [.24,.35,.17][kind]+.044*sin(i*2.1)
		var span := Vector3(length,width,rise)
		petal(top+ray*.04,ray,span,throat,rim,.12*cos(i*2.8))
	for i in [5,6,5][kind]:
		var ray := heading((float(i)+.44)*TAU/[5.0,6.0,5.0][kind])
		var span: Vector3 = [Vector3(.37,.131,.31),Vector3(.27,.127,.37),Vector3(.35,.117,.27)][kind]
		petal(top+Vector3.UP*.035+ray*.025,ray,span,throat.lightened(.16),rim.lightened(.11),-.11*sin(i*2.2))
	blossom_center(top,kind)
	mesh.generate_normals()
	mesh.index()
	return mesh.commit()

func heading(angle: float) -> Vector3:
	return Vector3(cos(angle),0,sin(angle))

func stalk_point(t: float) -> Vector3:
	return Vector3(.22*t*t,height*t,.14*sin(t*2.2)*t)

func vertex(at: Vector3, tint: Color, glow: float, along: float) -> void:
	tint.a = clampf(at.y/(height+.06),0,1)
	mesh.set_color(tint)
	mesh.set_uv(Vector2(along,glow))
	mesh.add_vertex(at)

func stalk(kind: int) -> void:
	var teal: Color = STEM_COLORS[kind]
	for row in range(6):
		for side in range(STEM_SIDES):
			for corner: Vector2i in [Vector2i(0,0),Vector2i(0,1),Vector2i(1,0),Vector2i(0,1),Vector2i(1,1),Vector2i(1,0)]:
				var t := float(row+corner.x)/6.0
				var axis := heading(float((side+corner.y)%STEM_SIDES)*TAU/STEM_SIDES)
				var radius := lerpf(.050,.025,t)
				vertex(stalk_point(t)+axis*radius,teal.lerp(teal.lightened(.13),t),0.0,t)
	for i in 3:
		var t := .24+float(i)*.19
		var ray := heading(float(i)*2.38+float(kind)*.72)
		var span := Vector3(.41-.04*i,.098-.010*i,.28+.04*i)
		petal(stalk_point(t),ray,span,teal.darkened(.13),teal.lightened(.23),.15,false)

func petal(origin: Vector3, ray: Vector3, span: Vector3, base: Color, rim: Color, twist: float, bright := true) -> void:
	var wing := ray.cross(Vector3.UP)
	for row in PETAL_ROWS:
		for col in PETAL_COLUMNS:
			for corner: Vector2i in [Vector2i(0,0),Vector2i(1,0),Vector2i(0,1),Vector2i(0,1),Vector2i(1,0),Vector2i(1,1)]:
				# Place more samples at either end to keep the lip rounded in profile.
				var t := .5-.5*cos(float(row+corner.x)*PI/PETAL_ROWS)
				var side := (float(col+corner.y)/PETAL_COLUMNS)*2.0-1.0
				var shape := pow(maxf(0.0,sin(t*PI)),.60)
				var width := span.y*maxf(.018,shape)*(.72+.49*t)
				var curl := span.z*(.19*t+.81*t*t)+.041*shape
				curl += (.079*side*side+twist*side*.28)*shape
				curl += .014*sin(t*12.0+side*4.8)*shape*absf(side)
				var length := span.x*t - .068*side*side*t*t*shape
				var centerline := twist*.33*shape*t
				var at := origin+ray*length+wing*(side*width+centerline)+Vector3.UP*curl
				var blend := smoothstep(.03,.88,t)
				var edge := smoothstep(.48,1.0,absf(side))*smoothstep(.20,.80,t)
				var color := base.lerp(rim,clampf(blend*.84+edge*.16,0,1))
				var glow := (.028+.25*edge+.10*smoothstep(.72,1.0,t)) if bright else 0.0
				vertex(at,color,glow,t)

func blossom_center(top: Vector3, kind: int) -> void:
	var bead := SphereMesh.new()
	bead.radial_segments = 8
	bead.rings = 4
	bead.radius = .5
	bead.height = 1.0
	var arrays := bead.surface_get_arrays(0)
	var points: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
	var indices: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]
	var center_tint: Color = [Color("A9C5A4"),Color("85BAC2"),Color("91C9A5")][kind]
	for index in indices:
		var p := points[index]
		vertex(top+Vector3.UP*.09+p*Vector3(.245,.158,.245),center_tint,.20+.25*maxf(0,p.y),.34)
	bead.radial_segments = 6
	bead.rings = 2
	arrays = bead.surface_get_arrays(0)
	points = arrays[Mesh.ARRAY_VERTEX]
	indices = arrays[Mesh.ARRAY_INDEX]
	for i in range(7):
		var ray := heading(float(i)*TAU/7.0+.3)
		var center := top+ray*(.085+.014*sin(i*2.1))+Vector3.UP*(.153+.024*cos(i*2.4))
		var bead_tint := center_tint.lerp(Color("E0EBC9"),.59+.16*sin(i*1.8))
		for index in indices:
			var p := points[index]
			vertex(center+p*Vector3(.038,.066,.038),bead_tint,.57+.17*maxf(0,p.y),.67)

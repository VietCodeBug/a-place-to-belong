extends RefCounted
## Room props use meter-scale geometry with their origin on the supporting surface.

const S = preload("res://scripts/world/shapes.gd")
const SECTIONS := 24

static func profile(parent: Node3D, rings: Array, at := Vector3.ZERO, roughness := .63, uneven := .0) -> MeshInstance3D:
	var geometry := SurfaceTool.new()
	geometry.begin(Mesh.PRIMITIVE_TRIANGLES)
	for row in rings.size()-1:
		var lower: Array = rings[row]
		var upper: Array = rings[row+1]
		var slope := Vector2(upper[1]-lower[1],lower[0]-upper[0]).normalized()
		for segment in SECTIONS:
			var a := TAU*segment/SECTIONS
			var b := TAU*(segment+1)/SECTIONS
			vertex(geometry,lower,a,slope,uneven)
			vertex(geometry,upper,b,slope,uneven)
			vertex(geometry,upper,a,slope,uneven)
			vertex(geometry,lower,a,slope,uneven)
			vertex(geometry,lower,b,slope,uneven)
			vertex(geometry,upper,b,slope,uneven)
	geometry.index()
	var finish := StandardMaterial3D.new()
	finish.vertex_color_use_as_albedo = true
	finish.vertex_color_is_srgb = true
	finish.roughness = roughness
	var node := S.mesh(parent,geometry.commit(),at,"FFFFFF")
	node.material_override = finish
	return node

static func vertex(geometry: SurfaceTool, ring: Array, angle: float, slope: Vector2, uneven: float) -> void:
	var direction := Vector3(cos(angle),0,sin(angle))
	var radius: float = ring[0]*(1+uneven*sin(angle*3))
	geometry.set_normal(direction*slope.x+Vector3.UP*slope.y)
	geometry.set_color(Color(ring[2]))
	geometry.add_vertex(direction*radius+Vector3.UP*float(ring[1]))

static func ellipsoid(parent: Node3D, at: Vector3, size: Vector3, color: String) -> MeshInstance3D:
	var mesh := SphereMesh.new()
	mesh.radial_segments = 14
	mesh.rings = 7
	var node := S.mesh(parent,mesh,at,color)
	node.scale = size
	return node

static func tube(parent: Node3D, points: Array[Vector3], width: float, color: String) -> void:
	for index in points.size()-1:
		var a := points[index]
		var b := points[index+1]
		var stretch := b-a
		var shape := CylinderMesh.new()
		shape.radial_segments = 8
		shape.rings = 0
		shape.height = stretch.length()+width*.35
		shape.top_radius = width
		shape.bottom_radius = width
		var link := S.mesh(parent,shape,(a+b)*.5,color)
		link.quaternion = Quaternion(Vector3.UP,stretch.normalized())

static func mug(parent: Node3D, color := "648578") -> void:
	profile(parent,[[0,.004,"695448"],[.038,.004,"695448"],[.048,.012,"AA866A"],
		[.053,.038,color],[.050,.075,color],[.055,.099,"D9BE8B"],[.053,.106,"E4D7B6"],
		[.044,.106,"E4D7B6"],[.040,.097,"B99870"],[.040,.026,"AE906C"],[0,.020,"AE906C"]],Vector3.ZERO,.47,.035)
	tube(parent,[Vector3(.049,.079,0),Vector3(.069,.082,0),Vector3(.085,.068,0),Vector3(.083,.050,0),
		Vector3(.069,.033,0),Vector3(.050,.027,0)],.009,color)

static func bowl(parent: Node3D, color := "B66850") -> void:
	profile(parent,[[0,.005,"876248"],[.060,.005,"876248"],[.069,.017,color],[.102,.029,color],
		[.130,.060,color],[.135,.074,"D3A377"],[.129,.080,"F1DBAA"],[.119,.077,"C49161"],
		[.101,.048,"CCA66D"],[.061,.026,"DFC38F"],[0,.024,"DFC38F"]],Vector3.ZERO,.49,.03)

static func jug(parent: Node3D) -> void:
	profile(parent,[[0,.005,"776143"],[.061,.005,"776143"],[.078,.019,"878354"],
		[.093,.056,"9C9B64"],[.096,.111,"AAA571"],[.081,.153,"CDAD76"],[.050,.178,"DCC397"],
		[.047,.220,"DCC397"],[.058,.227,"EBD8AB"],[.057,.240,"F0DFB0"],[.045,.239,"AC9B6E"],
		[.037,.228,"7E7753"],[.040,.182,"77694B"],[.072,.135,"77694B"],[0,.032,"77694B"]],Vector3.ZERO,.56,.033)
	tube(parent,[Vector3(.044,.198,0),Vector3(.082,.197,0),Vector3(.113,.176,0),Vector3(.128,.139,0),
		Vector3(.121,.103,0),Vector3(.093,.083,0)],.013,"969662")

static func kettle(parent: Node3D) -> void:
	profile(parent,[[0,.007,"443A32"],[.087,.007,"443A32"],[.108,.023,"6A5241"],
		[.120,.057,"87624C"],[.115,.108,"AA7C57"],[.106,.143,"B18762"],[.079,.158,"70513D"],
		[.077,.172,"B0875B"],[.048,.184,"AA7953"],[0,.187,"AA7953"]],Vector3.ZERO,.40)
	ellipsoid(parent,Vector3(0,.205,0),Vector3(.043,.035,.043),"574137")
	tube(parent,[Vector3(-.097,.078,0),Vector3(-.127,.094,0),Vector3(-.148,.118,0),
		Vector3(-.160,.152,0),Vector3(-.182,.165,0)],.019,"966F53")
	tube(parent,[Vector3(.088,.129,0),Vector3(.116,.191,0),Vector3(.096,.240,0),Vector3(.047,.270,0),
		Vector3(0,.278,0),Vector3(-.057,.262,0),Vector3(-.092,.218,0),Vector3(-.093,.144,0)],.010,"5E4734")

static func book(parent: Node3D, color := "596F5F", factor := 1.0) -> void:
	S.box(parent,Vector3(0,.027,0)*factor,Vector3(.176,.039,.222)*factor,"D5BB93")
	for y in [.005,.051]:
		S.box(parent,Vector3(-.004,y,0)*factor,Vector3(.187,.011,.237)*factor,color)
	S.box(parent,Vector3(-.092,.029,0)*factor,Vector3(.016,.057,.238)*factor,color)
	for z in [-.092,.092]:
		S.box(parent,Vector3(.002,.058,z)*factor,Vector3(.131,.003,.005)*factor,"C6A975")
	for x in [-.064,.068]:
		S.box(parent,Vector3(x,.058,0)*factor,Vector3(.005,.003,.187)*factor,"C6A975")
	var diamond := S.box(parent,Vector3(.002,.058,0)*factor,Vector3(.042,.005,.042)*factor,"BE985F")
	diamond.rotation.y = PI*.25
	for y in [.017,.023,.037,.043]:
		S.box(parent,Vector3(.089,y,0)*factor,Vector3(.003,.001,.202)*factor,"B49770")

static func basket(parent: Node3D) -> void:
	var rings: Array = [[0,.004,"82603C"],[.115,.004,"82603C"]]
	for index in 7:
		var y := .014+index*.019
		var radius := .115+index*.007
		rings.append([radius,y,"9D7546"])
		rings.append([radius+.008,y+.009,"C3985C"])
	rings.append_array([[.171,.148,"CEA575"],[.146,.151,"B78A55"],[.140,.134,"966D42"],
		[.101,.020,"87643B"],[0,.019,"87643B"]])
	profile(parent,rings,Vector3.ZERO,.9,.027)
	for index in 19:
		var angle := index*TAU/19
		var outward := Vector3(cos(angle),0,sin(angle))
		tube(parent,[outward*.115+Vector3.UP*.013,outward*.139+Vector3.UP*.067,
			outward*.163+Vector3.UP*.142],.004,["D9AD72","AD804E"][index%2])
	tube(parent,[Vector3(-.161,.142,0),Vector3(-.145,.225,0),Vector3(-.100,.282,0),
		Vector3(-.035,.309,0),Vector3(.035,.309,0),Vector3(.100,.282,0),Vector3(.145,.225,0),
		Vector3(.161,.142,0)],.013,"BE955C")

static func bread_board(parent: Node3D) -> void:
	S.box(parent,Vector3(0,.018,0),Vector3(.35,.031,.23),"9F7248")
	S.box(parent,Vector3(-.199,.020,0),Vector3(.083,.020,.073),"9F7248")
	var loaf := ellipsoid(parent,Vector3(-.010,.075,-.02),Vector3(.260,.117,.142),"CE9153")
	loaf.rotation.y = -.15
	for index in 3:
		var score := ellipsoid(parent,Vector3(-.061+index*.057,.124,-.027),Vector3(.010,.018,.076),"E8B878")
		score.rotation.y = .42
	for index in 2:
		var slice := ellipsoid(parent,Vector3(.092+index*.034,.058,.045),Vector3(.025,.081,.102),"BA7643")
		slice.rotation.z = -.32
		var crumb := ellipsoid(parent,Vector3(.104+index*.034,.059,.045),Vector3(.011,.071,.087),"E8C595")
		crumb.rotation.z = -.32

static func apples(parent: Node3D) -> void:
	bowl(parent,"778171")
	for index in 4:
		var angle := index*TAU/4.0
		var at := Vector3(cos(angle)*.063,.069,sin(angle)*.063)
		ellipsoid(parent,at,Vector3(.068,.065,.064),["A75743","B86A4B","B2864D","987349"][index])
		tube(parent,[at+Vector3.UP*.029,at+Vector3(.004,.042,.004)],.003,"675337")

static func grip(parent: Node3D) -> Node3D:
	var hand := Node3D.new()
	parent.add_child(hand)
	var sleeve := CylinderMesh.new()
	sleeve.top_radius = .045
	sleeve.bottom_radius = .063
	sleeve.height = .23
	sleeve.radial_segments = 12
	sleeve.rings = 0
	var arm := S.mesh(hand,sleeve,Vector3(.096,-.091,.077),"753A37")
	arm.quaternion = Quaternion(Vector3.UP,Vector3(-.62,.65,-.45).normalized())
	var palm := ellipsoid(hand,Vector3(.015,-.011,.032),Vector3(.088,.053,.093),"BA876E")
	palm.rotation.z = -.35
	ellipsoid(hand,Vector3(.003,.014,.054),Vector3(.069,.028,.034),"C9957A").rotation.z = .40
	for index in 3:
		ellipsoid(hand,Vector3(-.020-index*.008,-.010,.019-index*.012),Vector3(.049,.021,.029),"BE8A70").rotation.z = -.29
	return hand

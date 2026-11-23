extends Node3D

const S = preload("res://scripts/world/shapes.gd")
const USE = preload("res://scripts/story/prototype/interaction.gd")
const SURFACE = preload("res://shaders/house_a_surface.gdshader")
const BOTANY = preload("res://scripts/world/a1_botany.gd")
const DETAILS = preload("res://scripts/story/prototype/house_a_details.gd")
const ITEMS = preload("res://scripts/story/prototype/house_a_items.gd")
const WAKE := Vector3(-2.60,.04,-1.16)
const ENTRY := Vector3(-.42,.04,2.93)
const WIDTH := 9.18
const DEPTH := 7.56
const H := 3.0
const LIMESTONE := "B49B79"
const OAK := "875B3E"
const TRIM := "563722"
var camera: Camera3D
var window_light: OmniLight3D
var sky_light: DirectionalLight3D
var environment: Environment
var rain: GPUParticles3D
var snow: MeshInstance3D
var targets: Dictionary = {}
var palette: Dictionary = {}
var wear := 0.0
var quilt_repair: Node3D
var door: Node3D
var stage: Node3D
var items: Node3D
var window_trees: Array[Node3D] = []
var window_season := -1

func setup(owner_stage: Node3D, on_exit: Callable) -> void:
	stage = owner_stage
	wear = stage.hub.get_node("ForestHouseA").wear
	build_room()
	build_furniture()
	build_window_view()
	lighting()
	point("bed_01","Vuốt phẳng chăn",Vector3(-3.28,.67,-1.73),.78,make_bed)
	point("front_door","Mở cửa ra sân",Vector3(-.42,1.22,3.65),.47,on_exit)
	camera = Camera3D.new()
	camera.name = "RoomCamera"
	camera.near = .045
	camera.far = 32.0
	camera.environment = environment
	add_child(camera)
	camera.make_current()
	build_household_items()

func point(id: String, label: String, focus: Vector3, radius: float, command: Callable) -> void:
	var target := USE.new()
	target.name = id
	target.position = Vector3(focus.x,0,focus.z)
	target.set_meta("focus_at",Vector3.UP*focus.y)
	target.set_meta("focus_radius",radius)
	target.interaction_name = label
	target.interaction_radius = 1.65
	target.action = command
	add_child(target)
	targets[id] = target

func surface(color: String, finish: int, vertical: bool) -> ShaderMaterial:
	var key := "%s/%d/%s" % [color,finish,vertical]
	if not palette.has(key):
		var material := ShaderMaterial.new()
		material.shader = SURFACE
		material.set_shader_parameter("tint",Color(color))
		material.set_shader_parameter("finish",finish)
		material.set_shader_parameter("vertical",vertical)
		material.set_shader_parameter("wear",wear)
		palette[key] = material
	return palette[key]

func set_wear(amount: float) -> void:
	wear = clampf(amount,0.0,1.0)
	for material: ShaderMaterial in palette.values():
		material.set_shader_parameter("wear",wear)
	quilt_repair.visible = wear>.15

func box(at: Vector3, size: Vector3, color: String, solid := false, finish := 0, vertical := false) -> MeshInstance3D:
	var mesh := S.box(self,at,size,color,solid)
	mesh.material_override = surface(color,finish,vertical)
	return mesh

func build_room() -> void:
	box(Vector3(0,-.13,0),Vector3(WIDTH,.26,DEPTH),"74523B",true)
	for i in 23:
		var x := (i-11)*.394
		for row in 3:
			box(Vector3(x,-.016,-2.5+row*2.5),Vector3(.388,.032,2.489),["7D5437","906244","885A3C","765235"][posmod(i+row*7,4)])
	box(Vector3(0,H+.19,0),Vector3(WIDTH,.16,DEPTH),"593A27",true)
	for i in 21:
		box(Vector3((i-10)*.434,H+.093,0),Vector3(.423,.11,DEPTH),["6A452B","785037","654128"][i%3])
	for z in [-3.62,-2.10,-.61,.90,2.40,3.66]:
		box(Vector3(0,H-.035,z),Vector3(WIDTH,.29,.19),TRIM)
	for side in [-1,1]:
		var x: float = side*WIDTH*.5
		box(Vector3(x,1.52,0),Vector3(.18,3.04,DEPTH),LIMESTONE,true,1)
		box(Vector3(x*.978,.10,0),Vector3(.08,.16,DEPTH),TRIM)
		box(Vector3(x*.977,1.20,0),Vector3(.09,.13,DEPTH),OAK)
		for z in [-3.63,-1.15,1.35,3.60]:
			box(Vector3(x*.974,1.51,z),Vector3(.18,3.01,.16),TRIM,false,0,true)
	var front := DEPTH*.5
	for span in [[-4.59,-1.12],[.31,4.59]]:
		box(Vector3((span[0]+span[1])*.5,1.51,front),Vector3(span[1]-span[0],3.02,.19),LIMESTONE,true,1)
	box(Vector3(-.405,2.66,front),Vector3(1.43,.74,.19),LIMESTONE,true,1)
	box(Vector3(-.40,1.12,front+.03),Vector3(1.40,2.24,.14),TRIM,true).hide()
	door = Node3D.new()
	door.position = Vector3(-1.09,0,front-.055)
	add_child(door)
	for i in 7:
		var plank := S.box(door,Vector3(.10+i*.185,1.125,0),Vector3(.18,2.24,.096),OAK)
		plank.material_override = surface(["68432B","805435","755035"][i%3],0,true)
	for level in [.42,1.71]:
		S.box(door,Vector3(.66,level,-.067),Vector3(1.25,.103,.073),"45392F")
	S.box(door,Vector3(1.12,1.13,-.129),Vector3(.113,.068,.105),"B99358")
	for side in [-1,1]:
		box(Vector3(-.40+side*.735,1.153,front-.12),Vector3(.13,2.31,.23),TRIM,false,0,true)
	box(Vector3(-.4,2.28,front-.10),Vector3(1.57,.17,.24),TRIM)
	var left := -4.59
	for x in [-2.84,.37,3.03]:
		var right: float = x-.70
		box(Vector3((right+left)*.5,1.52,-front),Vector3(right-left,3.04,.18),LIMESTONE,true,1)
		make_window(float(x),-front)
		left = x+.70
	box(Vector3((left+4.59)*.5,1.52,-front),Vector3(4.59-left,3.04,.18),LIMESTONE,true,1)
	# Recessed bedroom wall, with an open 1.30 m doorway at the end of the hall.
	box(Vector3(-1.77,1.43,-2.97),Vector3(.18,2.86,1.62),LIMESTONE,true,1)
	box(Vector3(-1.77,1.43,-.38),Vector3(.18,2.86,.94),LIMESTONE,true,1)
	box(Vector3(-3.19,1.43,.10),Vector3(2.86,2.86,.14),LIMESTONE,true,1)
	for z in [-2.11,-.89,.10]:
		box(Vector3(-1.77,1.43,z),Vector3(.22,2.88,.16),TRIM,false,0,true)
	box(Vector3(-1.77,2.48,-1.50),Vector3(.26,.18,1.30),TRIM)
	box(Vector3(1.31,1.52,-3.38),Vector3(.18,3.04,.78),TRIM,true,0,true)

func make_window(x: float, z: float) -> void:
	box(Vector3(x,.52,z),Vector3(1.40,1.04,.18),LIMESTONE,true,1)
	box(Vector3(x,2.66,z),Vector3(1.40,.76,.18),LIMESTONE,true,1)
	box(Vector3(x,1.02,z+.10),Vector3(1.57,.12,.39),OAK)
	box(Vector3(x,2.28,z+.07),Vector3(1.57,.13,.22),TRIM)
	var sash := Node3D.new()
	sash.position = Vector3(x-.65,1.03,z+.07)
	add_child(sash)
	for dx in [0.0,.65,1.30]:
		S.box(sash,Vector3(dx,.63,0),Vector3(.052,1.22,.090),TRIM).material_override = surface(TRIM,0,true)
	for y in [.035,.61,1.22]:
		S.box(sash,Vector3(.65,y,0),Vector3(1.35,.048,.080),TRIM).material_override = surface(TRIM,0,false)
	box(Vector3(x,1.63,z-.06),Vector3(1.40,1.16,.06),"FFFFFF",true).hide()
	box(Vector3(x,2.36,z+.23),Vector3(1.91,.031,.032),"5C4635")
	for side in [-1,1]:
		for i in 4:
			var offset: float = side*(.62+i*.07)
			box(Vector3(x+offset,1.82-i*.025,z+.23+i%2*.038),Vector3(.076,.93-i*.048,.067),["B6A47B","A38F65"][i%2],false,2)
		box(Vector3(x+side*.73,1.66,z+.26),Vector3(.30,.027,.079),"75553A",false,2)

func table(at: Vector3, width: float, depth: float) -> void:
	box(at+Vector3.UP*.37,Vector3(width-.06,.74,depth-.08),"FFFFFF",true).hide()
	box(at+Vector3.UP*.77,Vector3(width,.11,depth),OAK)
	for x in [-1.0,1.0]:
		for z in [-1.0,1.0]:
			box(at+Vector3(x*(width*.5-.14),.36,z*(depth*.5-.11)),Vector3(.115,.72,.115),TRIM,false,0,true)

func furnishing(at: Vector3,yaw: float,build: Callable) -> void:
	var model := Node3D.new()
	model.position = at
	model.rotation.y = yaw
	add_child(model)
	build.call(model)

func build_furniture() -> void:
	# Bedroom. Woven bedcover and bedside book occupy the opposite side of the hall.
	box(Vector3(-3.53,.26,-1.86),Vector3(1.50,.52,2.25),OAK,true)
	box(Vector3(-3.53,.65,-2.94),Vector3(1.53,1.02,.15),TRIM)
	for x in [-4.24,-2.82]:
		box(Vector3(x,.86,-2.94),Vector3(.12,.69,.16),"784A32",false,0,true)
		DETAILS.ellipsoid(self,Vector3(x,1.23,-2.94),Vector3(.14,.11,.14),"754A32")
	for x in [-3.96,-3.53,-3.10]:
		box(Vector3(x,.91,-2.849),Vector3(.36,.33,.036),"805339",false,0,true)
	box(Vector3(-3.53,.57,-1.86),Vector3(1.42,.19,2.13),"CBB897",false,2)
	var quilt := Node3D.new()
	quilt.name = "Duvet"
	quilt.position = Vector3(-3.53,.687,-1.61)
	quilt.rotation.y = .04
	add_child(quilt)
	var cover := S.box(quilt,Vector3.ZERO,Vector3(1.42,.115,1.49),"60775F")
	cover.material_override = surface("637D70",3,false)
	stitch_quilt(quilt)
	var hem := S.box(quilt,Vector3(0,.033,.72),Vector3(1.45,.095,.14),"87917A")
	hem.material_override = surface("BCA16D",2,false)
	for side in [-1,1]:
		var drape := S.box(quilt,Vector3(side*.71,-.116,.11),Vector3(.040,.27,1.27),"5B6C5F")
		drape.rotation.z = -.075*side
		drape.material_override = surface("526A5F",2,true)
	for index in 2:
		var pillow := DETAILS.ellipsoid(self,Vector3(-3.89+index*.72,.709,-2.55),Vector3(.68,.229,.49),"DECFAC")
		pillow.rotation.y = -.07+index*.18
		pillow.material_override = surface("DECFAC",2,false)
	box(Vector3(-2.37,.33,-3.22),Vector3(.67,.66,.62),TRIM,true)
	box(Vector3(-2.37,.573,-2.899),Vector3(.61,.15,.051),OAK)
	box(Vector3(-2.37,.573,-2.86),Vector3(.074,.025,.051),"AF8B54")
	box(Vector3(-4.25,.81,-.69),Vector3(.55,1.62,1.18),"765338",true,0,true)
	for z in [-.99,-.43]:
		box(Vector3(-3.96,.89,z),Vector3(.09,1.42,.47),OAK,false,0,true)
		box(Vector3(-3.905,.99,z),Vector3(.018,1.07,.34),"835E41",false,0,true)
		S.box(self,Vector3(-3.886,.83,z),Vector3(.06,.080,.042),"B99058")
	rug(Vector3(-2.49,.014,-1.21),Vector2(.73,1.45),"866449")
	# Dining table opens onto the cooking aisle. The cloth falls off both edges.
	var dining := Vector3(2.22,0,1.13)
	table(dining,1.68,.91)
	box(dining+Vector3(.01,.834,.00),Vector3(.51,.022,.94),"CDB186",false,3)
	for side in [-1,1]:
		box(dining+Vector3(.01,.73,side*.475),Vector3(.50,.21,.020),"C8A97D",false,2)
		box(dining+Vector3(.01,.64,side*.487),Vector3(.50,.024,.008),"A78455",false,2)
		chair(dining+Vector3(.06,0,side*.88),side)
	furnishing(Vector3(2.88,.826,1.29),-.20,DETAILS.bread_board)
	furnishing(Vector3(1.67,.826,.90),0.0,DETAILS.apples)
	lantern(Vector3(2.93,.826,.81))
	rug(Vector3(2.19,.014,1.13),Vector2(2.40,2.48),"6F795B")
	build_kitchen()
	build_hearth()

func stitch_quilt(quilt: Node3D) -> void:
	quilt_repair = Node3D.new()
	quilt_repair.name = "StitchedPatch"
	quilt_repair.position = Vector3(.33,.061,.30)
	quilt_repair.rotation.y = -.17
	quilt_repair.visible = wear>.15
	quilt.add_child(quilt_repair)
	var cloth := S.box(quilt_repair,Vector3.ZERO,Vector3(.28,.008,.18),"6A7A68")
	cloth.material_override = surface("7A7961",2,false)
	for seam in [-.078,.078]:
		for stitch in 6:
			var line := S.box(quilt_repair,Vector3((stitch-2.5)*.043,.006,seam),Vector3(.013,.004,.008),"BBAB83")
			line.rotation.y = -.34+stitch%3*.16

func rug(at: Vector3, size: Vector2, color: String) -> void:
	box(at,Vector3(size.x,.022,size.y),color,false,3)
	for side in [-1,1]:
		box(at+Vector3(0,.015,side*(size.y*.5-.09)),Vector3(size.x-.048,.007,.038),"B29769",false,2)
		for index in 9:
			var x := (index-4)*size.x*.104
			box(at+Vector3(x,.0,side*(size.y*.5+.021)),Vector3(.019,.010,.071),"B9A175",false,2)

func chair(at: Vector3, side: int) -> void:
	box(at+Vector3.UP*.25,Vector3(.46,.50,.42),OAK,true).hide()
	box(at+Vector3.UP*.456,Vector3(.49,.085,.44),OAK)
	for x in [-.184,.184]:
		box(at+Vector3(x,.21,-side*.156),Vector3(.073,.43,.075),TRIM,false,0,true)
		box(at+Vector3(x,.53,side*.177),Vector3(.073,1.03,.076),TRIM,false,0,true)
	for y in [.690,.925]:
		box(at+Vector3(0,y,side*.177),Vector3(.398,.092,.056),OAK)
	for x in [-.105,0,.105]:
		box(at+Vector3(x,.81,side*.177),Vector3(.034,.211,.029),TRIM,false,0,true)

func lantern(at: Vector3) -> void:
	var glass := StandardMaterial3D.new()
	glass.albedo_color = Color("DEAB68")
	glass.emission_enabled = true
	glass.emission = Color("FFD18A")
	glass.emission_energy_multiplier = .78
	box(at+Vector3.UP*.027,Vector3(.169,.048,.148),"6C4A32")
	var glow := box(at+Vector3.UP*.143,Vector3(.108,.197,.090),"DBA775")
	glow.material_override = glass
	for x in [-.068,.068]:
		for z in [-.055,.055]:
			box(at+Vector3(x,.154,z),Vector3(.018,.210,.018),"5F4330")
	box(at+Vector3.UP*.258,Vector3(.175,.042,.151),"69513C")
	DETAILS.tube(self,[at+Vector3(-.034,.266,0),at+Vector3(-.028,.300,0),at+Vector3(.025,.300,0),at+Vector3(.034,.266,0)],.007,"76593A")

func build_kitchen() -> void:
	box(Vector3(4.03,.46,-2.55),Vector3(.88,.92,1.93),"79563D",true)
	box(Vector3(4.04,.944,-2.55),Vector3(.98,.095,2.01),"AB9679",false,5)
	for z in [-3.16,-2.55,-1.94]:
		box(Vector3(3.58,.45,z),Vector3(.062,.66,.55),"526758",false,4,true)
		box(Vector3(3.542,.45,z),Vector3(.026,.51,.415),"627263",false,4,true)
		box(Vector3(3.518,.66,z),Vector3(.038,.035,.117),"B29059",false,6,true)
	for row in 3:
		for column in 11:
			box(Vector3(4.469,1.057+row*.115,-3.50+column*.188),Vector3(.034,.105,.178),
				["A79172","C1AB88","907B60","B6A088"][posmod(row+column*3,4)],false,5)
	DETAILS.profile(self,[[0,.006,"694D37"],[.226,.006,"765D49"],[.251,.036,"A97E56"],[.245,.076,"C49D72"],
		[.225,.078,"BE976A"],[.210,.058,"997854"],[.168,.017,"735E47"],[0,.015,"685543"]],Vector3(4.04,.995,-3.13),.42)
	DETAILS.tube(self,[Vector3(4.304,1.04,-3.13),Vector3(4.304,1.211,-3.13),Vector3(4.236,1.257,-3.13),
		Vector3(4.140,1.246,-3.13),Vector3(4.106,1.192,-3.13)],.019,"A68755")
	for y in [1.47,1.92,2.33]:
		box(Vector3(4.26,y,-2.63),Vector3(.44,.083,1.83),TRIM)
		for z in [-3.27,-1.97]:
			box(Vector3(4.39,y-.11,z),Vector3(.157,.23,.10),"70503A",false,0,true)
	furnishing(Vector3(4.23,1.961,-2.75),.18,DETAILS.jug)
	furnishing(Vector3(4.22,1.961,-2.12),2.17,DETAILS.bowl.bind("7B8E7E"))
	furnishing(Vector3(4.25,2.373,-3.18),.4,DETAILS.bowl.bind("AA8262"))
	furnishing(Vector3(4.27,2.373,-2.53),2.18,DETAILS.mug.bind("9B7961"))
	furnishing(Vector3(4.22,2.373,-2.20),1.75,DETAILS.mug.bind("839174"))
	# A hanging bundle gives the preparation wall a distinct silhouette.
	for bundle in 3:
		var z := -3.29+bundle*.15
		S.beam(self,Vector3(4.18,1.90,z),Vector3(4.15,1.70-bundle*.027,z+.05),.010,"8E7755")
		for leaf in 4:
			var tip := DETAILS.ellipsoid(self,Vector3(4.151,1.70-bundle*.024+leaf*.038,z+.02+leaf%2*.046),
				Vector3(.027,.067,.042),["827F4E","726B46","96955F"][bundle])
			tip.rotation.x = .56 if leaf%2==0 else -.56

func build_hearth() -> void:
	box(Vector3(-4.05,.15,1.73),Vector3(1.04,.30,1.48),"77695A",true,5)
	box(Vector3(-4.49,1.59,1.73),Vector3(.23,2.77,1.16),"6F6050",false,5)
	for row in 4:
		for side in [-1,1]:
			box(Vector3(-4.19,.35+row*.203,1.73+side*(.51+row%2*.023)),Vector3(.58,.192,.31+row%2*.055),
				["817361","9A856C","756957","94826D"][posmod(row+side,4)],false,5)
	for row in 9:
		var amount := 4 if row%2==0 else 3
		for index in amount:
			var z := 1.73+(index-(amount-1)*.5)*(1.11/amount)
			var stone := box(Vector3(-4.31,1.32+row*.179,z),Vector3(.42+(index%2)*.017,.167,1.10/amount-.012),
				["8D7D67","786A5A","978571","89775F"][posmod(row*5+index,4)],false,5)
			stone.rotation.x = (index-1)*.025
	box(Vector3(-4.24,1.19,1.73),Vector3(.68,.114,1.59),"6B4830")
	box(Vector3(-4.22,1.279,1.73),Vector3(.72,.068,1.68),"886444")
	for index in 5:
		var log_at := Vector3(-4.20,.337+index%2*.071,1.41+index*.128)
		DETAILS.tube(self,[log_at+Vector3(-.259,0,.00),log_at+Vector3(.197,0,.08-index*.019)],.053,"684E35")
		DETAILS.tube(self,[log_at+Vector3(.194,0,.08-index*.019),log_at+Vector3(.214,0,.08-index*.019)],.047,"A07A53")
	for index in 4:
		DETAILS.ellipsoid(self,Vector3(-4.045,.339,1.55+.12*index),Vector3(.085,.031,.062),"974C37")
	furnishing(Vector3(-4.14,1.315,1.2),-.65,DETAILS.mug.bind("927356"))
	furnishing(Vector3(-4.14,1.315,2.21),-.23,DETAILS.bowl.bind("6F806B"))
	box(Vector3(-3.89,.52,3.01),Vector3(1.13,1.04,.54),"725235",true)
	box(Vector3(-3.89,1.043,3.01),Vector3(1.19,.070,.61),"916542")
	for x in [-4.15,-3.63]:
		box(Vector3(x,.56,2.721),Vector3(.48,.83,.047),"835D41",false,0,true)
		box(Vector3(x,.59,2.692),Vector3(.37,.68,.021),"936C4D",false,0,true)
	for x in [-3.97,-3.81]:
		box(Vector3(x,.65,2.664),Vector3(.031,.089,.043),"AB8C5F")
	box(Vector3(-3.89,1.72,3.656),Vector3(1.05,.075,.18),OAK)
	for x in [-4.16,-3.55]:
		box(Vector3(x,1.62,3.65),Vector3(.083,.18,.14),TRIM,false,0,true)
	furnishing(Vector3(-4.09,1.758,3.59),.17,DETAILS.mug.bind("9C7255"))
	furnishing(Vector3(-3.84,1.758,3.59),-.48,DETAILS.jug)
	DETAILS.tube(self,[Vector3(-3.60,1.69,3.61),Vector3(-3.57,1.62,3.55),Vector3(-3.56,1.39,3.55)],.010,"8D6140")
	DETAILS.ellipsoid(self,Vector3(-3.56,1.37,3.55),Vector3(.071,.124,.034),"9B714A")
	box(Vector3(-2.79,.34,2.82),Vector3(.61,.68,.58),"7A583E",true)
	box(Vector3(-2.79,.71,2.82),Vector3(.65,.078,.62),"976949")
	furnishing(Vector3(-4.19,1.080,3.06),.34,DETAILS.book.bind("87634D",.94))
	rug(Vector3(-2.26,.014,1.55),Vector2(1.71,1.89),"7B6C50")

func build_household_items() -> void:
	items = ITEMS.new()
	items.name = "HouseholdItems"
	add_child(items)
	items.setup(stage,camera)
	items.add_slot("table_cup","bàn ăn",Vector3(2.49,.845,.862),.26)
	items.add_slot("table_bowl","bàn ăn",Vector3(1.69,.825,1.30),.40)
	items.add_slot("table_free","bàn ăn",Vector3(2.40,.845,1.42),.40)
	items.add_slot("basin_side","mặt bếp",Vector3(3.80,.992,-2.55),.41)
	items.add_slot("stove_side","mặt bếp",Vector3(4.08,.992,-1.83),.43)
	items.add_slot("shelf_jug","kệ bếp",Vector3(4.24,1.512,-3.13),.25)
	items.add_slot("shelf_free","kệ bếp",Vector3(4.20,1.512,-2.28),.30)
	items.add_slot("nightstand","tủ cạnh giường",Vector3(-2.38,.663,-3.15),.41)
	items.add_slot("cupboard","tủ cạnh lò",Vector3(-3.71,1.078,3.00),.43)
	items.add_slot("hearth_table","bàn cạnh lò",Vector3(-2.79,.751,2.82),.49)
	items.add_prop("mug","cốc gốm","table_cup",.154,.106,.33,Vector3(.076,.052,-.017),DETAILS.mug)
	items.add_prop("bowl","bát đất nung","table_bowl",.274,.083,.13,Vector3(.104,.003,.051),DETAILS.bowl)
	items.add_prop("jug","bình gốm","shelf_jug",.244,.240,-.70,Vector3(.093,.068,.034),DETAILS.jug)
	items.add_prop("kettle","ấm đồng","stove_side",.333,.280,-.72,Vector3(.098,.044,.049),DETAILS.kettle)
	items.add_prop("book","sách bìa vải","nightstand",.242,.059,.24,Vector3(.068,-.001,.062),DETAILS.book)
	items.add_prop("basket","giỏ đan","cupboard",.354,.319,.32,Vector3(.136,.009,.076),DETAILS.basket)

func build_window_view() -> void:
	box(Vector3(0,-.41,-10),Vector3(26,.56,14),"596F43",false,1)
	snow = box(Vector3(0,-.118,-9.5),Vector3(26,.014,14),"CDDCE0",false,1)
	var grove := [["BirchTree_2",-3.8,-7.6,7.2],["NormalTree_3",2.9,-8.9,7.2],["PineTree_2",-1.6,-11.9,8.9],
		["NormalTree_4",5.5,-12.8,7.1],["PineTree_3",-5.2,-14.7,10.0],["BirchTree_3",.85,-16.3,8.1]]
	for spec in grove:
		var tree := BOTANY.place_tree(self,spec[0],Vector3(spec[1],-.13,spec[2]),spec[3],float(spec[1]))
		window_trees.append(tree)
	for spot in [Vector3(-2,-.13,-6.0),Vector3(2.9,-.13,-6.7),Vector3(4.3,-.13,-9.3),Vector3(-4.4,-.13,-8.9)]:
		BOTANY.place(self,"Bush_Large",spot,.82,spot.x)
		BOTANY.place_stone(self,spot+Vector3(.73,-.05,.24),.52,spot.x)
	rain = GPUParticles3D.new()
	rain.position = Vector3(0,4,-7.3)
	rain.amount = 72
	rain.lifetime = .65
	var drops := ParticleProcessMaterial.new()
	drops.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	drops.emission_box_extents = Vector3(6,.2,3)
	drops.direction = Vector3(.10,-1,0)
	drops.spread = 6.0
	drops.initial_velocity_min = 6.2
	drops.initial_velocity_max = 8.4
	rain.process_material = drops
	var streak := BoxMesh.new()
	streak.size = Vector3(.017,.22,.017)
	streak.material = S.material("A1BCC4")
	rain.draw_pass_1 = streak
	rain.emitting = false
	add_child(rain)

func lamp(at: Vector3, reach: float, energy: float) -> void:
	var fixture := OmniLight3D.new()
	fixture.position = at
	fixture.omni_range = reach
	fixture.light_color = Color("FFD495")
	fixture.light_energy = energy
	add_child(fixture)

func lighting() -> void:
	environment = Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("CBBEAA")
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	sky_light = DirectionalLight3D.new()
	sky_light.rotation_degrees = Vector3(-25,161,0)
	sky_light.light_color = Color("FAE5BD")
	sky_light.shadow_enabled = true
	sky_light.directional_shadow_max_distance = 21.0
	add_child(sky_light)
	window_light = OmniLight3D.new()
	window_light.position = Vector3(.50,1.87,-3.28)
	window_light.omni_range = 6.2
	window_light.light_color = Color("F6DFB9")
	add_child(window_light)
	lamp(Vector3(2.93,1.01,.81),4.6,1.16)
	lamp(Vector3(-3.83,.70,1.76),4.6,1.29)
	lamp(Vector3(-2.45,1.16,-3.20),3.6,.53)
	lamp(Vector3(3.87,1.88,-2.93),2.8,.36)

func update_climate(hour: float, wet: float, season: int) -> void:
	var daylight := smoothstep(0.0,.44,sin((hour-6.0)*TAU/24.0))
	environment.background_color = Color("243345").lerp(Color("9DAEB3"),daylight*(1.0-wet*.34))
	environment.ambient_light_energy = (.29+daylight*.37)*(1.0-wear*.13)
	sky_light.light_energy = .13+daylight*.8*(1.0-wet*.61)
	window_light.light_energy = (.16+daylight*.58*(1.0-wet*.47))*(1.0-wear*.09)
	rain.emitting = wet>.14
	snow.visible = season==3
	if window_season!=season:
		window_season = season
		for tree in window_trees:
			BOTANY.season_tree(tree,season)

func make_bed() -> void:
	if stage.session.objects.get("bed_01")=="made":
		return
	create_tween().tween_property(get_node("Duvet"),"rotation:y",0.0,.25)
	stage.session.object_state("bed_01","made")
	stage.session.flag("ch01_bed_seen")
	targets.bed_01.set_available(false)

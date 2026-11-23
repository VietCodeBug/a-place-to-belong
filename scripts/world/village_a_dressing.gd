extends Node3D
## Small facade and courtyard groups share instance batches across Village A.

const S = preload("res://scripts/world/shapes.gd")
const LAND = preload("res://scripts/world/landscape.gd")
const WOOD := "906445"
const END_GRAIN := "B48859"
const FRAME := "664A39"
const BRACE := "A57A50"

var batches := {"Planks":[],"Crocks":[],"Fruit":[],"WinterCaps":[]}
var winter_caps: MultiMeshInstance3D
var base := Vector3.ZERO
var turn := Basis.IDENTITY

func setup() -> void:
	stand(Vector2(9.12,127.35),-PI*.5)
	awning("A6755E")
	produce(Vector3(-.72,0,.90),"AB6549")
	crate(Vector3(.78,0,.82),Vector3(.49,.35,.39))
	barrel(Vector3(1.33,0,.24),.57)
	crate(Vector3(.53,.35,.77),Vector3(.29,.19,.25))
	stopper(Vector3(-1.47,0,.12),.36,"A77956")

	stand(Vector2(3.03,125.85),1.25)
	crate(Vector3.ZERO,Vector3(.66,.38,.46))
	produce(Vector3(0,.38,0),"A18C4D")
	barrel(Vector3(-.63,0,0),.55)
	stopper(Vector3(.56,0,.12),.32,"6F8779")

	stand(Vector2(18.55,124.96),-1.55)
	wood_rack()
	crate(Vector3(1.03,0,.25),Vector3(.52,.38,.43))
	crate(Vector3(1.06,.38,.24),Vector3(.38,.25,.35))
	barrel(Vector3(1.59,0,.07),.57)

	stand(Vector2(-5.2,117.62),1.68)
	bench()
	crate(Vector3(.89,0,.24),Vector3(.48,.31,.40))
	produce(Vector3(.90,.31,.24),"7C8A4E")
	stopper(Vector3(-.88,0,.20),.42,"B38864")

	for site in [[Vector2(8.5,108.85),-1.10],[Vector2(9.45,133.43),-1.56],
			[Vector2(2.1,135.63),1.33],[Vector2(-10.79,145.92),1.64],[Vector2(8.51,157.97),-1.55]]:
		stand(site[0],site[1])
		barrel(Vector3.ZERO,.52)
		stopper(Vector3(.43,0,.13),.35,"936C52")
		crate(Vector3(-.58,0,.13),Vector3(.45,.25,.34))

	var timber := BoxMesh.new()
	var clay := CylinderMesh.new()
	clay.top_radius = .43
	clay.bottom_radius = .49
	clay.radial_segments = 11
	clay.rings = 0
	var fruit := SphereMesh.new()
	fruit.radial_segments = 8
	fruit.rings = 4
	build_batch("Planks",timber)
	build_batch("Crocks",clay)
	build_batch("Fruit",fruit)
	winter_caps = build_batch("WinterCaps",timber)
	batches.clear()

func stand(p: Vector2,yaw: float) -> void:
	base = Vector3(p.x,LAND.height_at(p.x,p.y),p.y)
	turn = Basis(Vector3.UP,yaw)

func add_piece(batch: String, at: Vector3, size: Vector3, color: String, tilt := Vector3.ZERO) -> void:
	var transform_at := Transform3D((turn*Basis.from_euler(tilt)).scaled_local(size),base+turn*at)
	batches[batch].append([transform_at,Color(color)])

func solid(at: Vector3,size: Vector3) -> void:
	var prop := S.box(self,base+turn*at,size,"FFFFFF",true)
	prop.basis = turn
	prop.hide()

func awning(canvas: String) -> void:
	for x in [-1.12,1.12]:
		for z in [-.50,.50]:
			add_piece("Planks",Vector3(x,.095,z),Vector3(.24,.19,.23),"918070")
			var height := 2.26 if z>0.0 else 2.64
			add_piece("Planks",Vector3(x,height*.5+.08,z),Vector3(.095,height,.095),FRAME)
	for i in 8:
		var x := (i-3.5)*.318
		var tint := canvas if i in [1,2,5,6] else "CEB18B"
		add_piece("Planks",Vector3(x,2.54,0),Vector3(.321,.048,1.38),tint,Vector3(.34,0,0))
		add_piece("Planks",Vector3(x,2.249,.663),Vector3(.311,.137+float(i%2)*.026,.038),tint)
		add_piece("WinterCaps",Vector3(x,2.582,0),Vector3(.319,.031,1.20),"D7E5E8",Vector3(.34,0,0))
	add_piece("Planks",Vector3(0,2.39,.56),Vector3(2.37,.094,.094),WOOD)
	for x in [-.97,.97]:
		add_piece("Planks",Vector3(x,.43,.32),Vector3(.118,.83,.58),FRAME)
	for i in 4:
		add_piece("Planks",Vector3(0,.20+i*.145,.59),Vector3(1.98,.130,.050),[WOOD,BRACE,"795337",WOOD][i])
	add_piece("Planks",Vector3(0,.84,.29),Vector3(2.18,.115,.77),END_GRAIN)
	add_piece("Planks",Vector3(0,.414,.625),Vector3(1.70,.080,.052),BRACE,Vector3(0,0,.28))
	produce(Vector3(-.63,.894,.24),"9C5843")
	produce(Vector3(.45,.894,.36),"CF984E")
	stopper(Vector3(.84,.894,.31),.25,"697F71")
	solid(Vector3(0,.425,.31),Vector3(2.16,.91,.70))

func wood_rack() -> void:
	for x in [-.77,.77]:
		add_piece("Planks",Vector3(x,.80,0),Vector3(.16,1.60,.54),FRAME)
	add_piece("Planks",Vector3(0,.16,0),Vector3(1.73,.13,.64),WOOD)
	add_piece("Planks",Vector3(0,1.63,0),Vector3(1.96,.11,.91),"775342",Vector3(.20,0,0))
	add_piece("WinterCaps",Vector3(0,1.70,0),Vector3(1.90,.049,.84),"DCE9EC",Vector3(.20,0,0))
	for i in 11:
		var x := (i%5-2)*.236+.08*floorf(i/5.0)
		var level := .35+floorf(i/5.0)*.214
		add_piece("Crocks",Vector3(x,level,0),Vector3(.211,.61,.205),"725139",Vector3(PI*.5,0,.06*(i%3)))
		add_piece("Crocks",Vector3(x,level,.319),Vector3(.183,.032,.177),END_GRAIN,Vector3(PI*.5,0,.06*(i%3)))
	solid(Vector3(0,.84,.0),Vector3(1.68,1.70,.60))

func bench() -> void:
	for x in [-.51,.51]:
		add_piece("Planks",Vector3(x,.235,0),Vector3(.14,.47,.28),FRAME)
	add_piece("Planks",Vector3(0,.477,0),Vector3(1.41,.11,.42),END_GRAIN)
	add_piece("WinterCaps",Vector3(0,.552,0),Vector3(1.37,.035,.37),"DCE8EC")
	solid(Vector3(0,.25,0),Vector3(1.40,.54,.38))

func crate(at: Vector3,size: Vector3) -> void:
	add_piece("Planks",at+Vector3.UP*(size.y*.5),size*Vector3(.91,.90,.91),"77553B")
	for i in 3:
		var slat := Vector3(size.x,size.y*.26,size.z*.99)
		add_piece("Planks",at+Vector3.UP*(size.y*(.17+i*.33)),slat,[WOOD,BRACE,"886047"][i])
	for x in [-.40,.40]:
		add_piece("Planks",at+Vector3(x*size.x,size.y*.52,size.z*.515),Vector3(size.x*.11,size.y,.030),END_GRAIN)

func barrel(at: Vector3,height: float) -> void:
	var width := height*.79
	add_piece("Crocks",at+Vector3.UP*(height*.5),Vector3(width,height,width),WOOD)
	for y in [.23,.79]:
		add_piece("Crocks",at+Vector3.UP*(height*y),Vector3(width*1.04,.044,width*1.04),"4D5048")
	add_piece("Crocks",at+Vector3.UP*(height*.99),Vector3(width*.79,.024,width*.79),END_GRAIN)

func stopper(at: Vector3,height: float,tint: String) -> void:
	add_piece("Crocks",at+Vector3.UP*(height*.38),Vector3(height*.70,height*.73,height*.70),tint)
	add_piece("Crocks",at+Vector3.UP*(height*.80),Vector3(height*.43,height*.26,height*.43),tint)
	add_piece("Crocks",at+Vector3.UP*(height*.95),Vector3(height*.47,.049,height*.47),"C3A178")

func produce(at: Vector3,color: String) -> void:
	add_piece("Crocks",at+Vector3.UP*.075,Vector3(.38,.145,.35),"A88452")
	add_piece("Crocks",at+Vector3.UP*.133,Vector3(.396,.031,.366),"C0A171")
	for i in 7:
		var angle := float(i)*TAU/6.0
		var offset := Vector3(cos(angle)*.115,.157,sin(angle)*.093) if i<6 else Vector3.UP*.19
		add_piece("Fruit",at+offset,Vector3(.109,.100,.107),color if i%3!=0 else "C29558")

func build_batch(name_in_scene: String, mesh: Mesh) -> MultiMeshInstance3D:
	var batch := MultiMesh.new()
	batch.transform_format = MultiMesh.TRANSFORM_3D
	batch.use_colors = true
	batch.mesh = mesh
	batch.instance_count = batches[name_in_scene].size()
	for i in batch.instance_count:
		var data: Array = batches[name_in_scene][i]
		batch.set_instance_transform(i,data[0])
		batch.set_instance_color(i,data[1])
	var instance := MultiMeshInstance3D.new()
	instance.name = name_in_scene
	instance.multimesh = batch
	var finish := StandardMaterial3D.new()
	finish.vertex_color_use_as_albedo = true
	finish.vertex_color_is_srgb = true
	finish.roughness = .89
	instance.material_override = finish
	add_child(instance)
	return instance

func set_season(index: int) -> void:
	winter_caps.visible = index==3

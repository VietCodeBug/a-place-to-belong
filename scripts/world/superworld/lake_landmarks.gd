extends "res://scripts/world/superworld/lake_masonry.gd"
## Separate mesh and collision batches keep the three sites independently cullable.

const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
const SITES := [FIELD.STAIR_GATE, FIELD.COLONNADE, FIELD.BROKEN_TOWER]
const SITE_NAMES := ["StairGate", "Colonnade", "BrokenTower"]
const STONE_TONES := ["7C877E", "657975", "526867", "8D8E7D", "6B807C"]

var field: FIELD
var boulder := SphereMesh.new()

func setup(source: FIELD, site: int) -> void:
	field = source
	var center: Vector2 = SITES[site]
	var origin := Vector3(center.x, field.height(center)+.65, center.y)
	begin_site(SITE_NAMES[site],origin,55709+site*311)
	boulder.radial_segments = 8
	boulder.rings = 3
	match site:
		0: build_gate()
		1: build_colonnade()
		2: build_tower()
	scatter_foundations(site)
	stone_visual("Limestone")

func masonry_color() -> Color:
	return Color(STONE_TONES[rng.randi_range(0,STONE_TONES.size()-1)]).lerp(Color("9AA594"),rng.randf()*.21)

func solid_block(at: Vector3, size: Vector3, yaw := 0.0) -> void:
	block(at,size,masonry_color(),yaw)
	var shape := BoxShape3D.new()
	shape.size = size
	collide(shape,at,yaw)

func paving(length: int, width: int) -> void:
	for x in range(-length,length+1):
		for z in range(-width,width+1):
			var at := Vector3(x*.96,-.015,z*.93)
			if abs(z)==width and rng.randf()<.34:
				continue
			var size := Vector3(rng.randf_range(.86,.94),rng.randf_range(.12,.21),rng.randf_range(.83,.91))
			block(at,size,masonry_color(),rng.randf_range(-.07,.07))

func build_gate() -> void:
	solid_block(Vector3(0,-.46,0),Vector3(12.0,.78,8.45))
	paving(6,4)
	for i in 5:
		var x := -6.3-float(i)*.54
		solid_block(Vector3(x,-.31-float(i)*.17,0),Vector3(.60,.24,5.1-i*.16))
	for side: float in [-1.0,1.0]:
		for course in 4:
			solid_block(Vector3(0,.42+course*.66,side*2.26),Vector3(1.56-course*.08,.65,.90-course*.06))
			for brick in (3 if course<2 else 2):
				var z := side*(3.08+float(brick)*.98)
				block(Vector3(.10,.32+course*.47,z),Vector3(1.25,.44,.93),masonry_color(),rng.randf_range(-.06,.06))
		block(Vector3(0,2.77,side*2.33),Vector3(1.78,.29,1.22),Color("8C9A8C"))
	# Set individual wedge-like blocks along the crown, leaving a full swim opening.
	for step in 11:
		var theta := (float(step)+.5)*PI/11.0
		var center := Vector3(0,2.67+sin(theta)*2.25,cos(theta)*2.25)
		var basis := Basis(Vector3.RIGHT,-theta).scaled_local(Vector3(1.58,.71,.63))
		stamp(cube,Transform3D(basis,center),masonry_color())
	var crown := BoxShape3D.new()
	crown.size = Vector3(1.47,.70,2.6)
	collide(crown,Vector3(0,4.72,0))
	for side: float in [-1.0,1.0]:
		for step in 3:
			var z := side*(1.64+step*.34)
			var cap := BoxShape3D.new()
			cap.size = Vector3(1.38,.75,.45)
			collide(cap,Vector3(0,4.15-step*.52,z))

func build_colonnade() -> void:
	solid_block(Vector3(0,-.65,0),Vector3(16.4,1.16,7.75))
	paving(8,3)
	for side: float in [-1.0,1.0]:
		for bay in 5:
			var x := -6.45+bay*3.19
			var at := Vector3(x,0,side*2.86)
			var full := not (side<0 and bay in [2,4]) and not (side>0 and bay==1)
			var courses := 4 if full else 1+bay%2
			var total := .33+float(courses)*.69
			block(at+Vector3.UP*.15,Vector3(1.35,.30,1.31),masonry_color())
			drum(.43,.62,.22,at+Vector3.UP*.38,masonry_color(),.26)
			for ring in courses:
				drum(.33-ring*.015,.43-ring*.015,.67,at+Vector3.UP*(.82+.69*ring),masonry_color(),.28)
			var column := CylinderShape3D.new()
			column.radius = .54
			column.height = total+.18
			collide(column,at+Vector3.UP*(total*.5))
			if full:
				block(at+Vector3.UP*3.39,Vector3(1.10,.30,1.11),Color("8E9584"))
	for x in [-4.86,4.73]:
		solid_block(Vector3(x,3.71,-2.86 if x<0 else 2.86),Vector3(4.20,.39,.79))
	solid_block(Vector3(-6.45,3.73,0),Vector3(.96,.46,6.73))
	block(Vector3(3.80,.25,-1.55),Vector3(2.45,.51,1.07),masonry_color(),.18)
	block(Vector3(3.80,.62,-1.55),Vector3(2.27,.25,.93),Color("718581"),.18)

func build_tower() -> void:
	drum(4.93,5.20,.64,Vector3(0,-.53,0),Color("586C6D"),.33)
	drum(4.62,4.91,.38,Vector3(0,-.08,0),Color("84918B"),.33)
	var stage := CylinderShape3D.new()
	stage.radius = 4.62
	stage.height = .38
	collide(stage,Vector3(0,-.08,0))
	paving(3,3)
	# A low foundation on one side and a jagged tower wall on the other.
	var tops := [3,6,9,10,7,4,1,2,5,7,6,3]
	for i in tops.size():
		var theta := (float(i)+.5)*TAU/tops.size()
		var axis := Vector2.from_angle(theta)
		var yaw := -theta
		for course in tops[i]:
			if i in [0,6] and course<3:
				continue
			if i==3 and course in [3,4]:
				continue
			var at := Vector3(axis.x*3.64,.40+course*.67,axis.y*3.64)
			var drift := rng.randf_range(-.08,.08)
			block(at,Vector3(.83,.66,1.88),masonry_color(),yaw+drift)
			var wall := BoxShape3D.new()
			wall.size = Vector3(.79,.61,1.84)
			collide(wall,at,yaw)
		if tops[i]>5:
			block(Vector3(axis.x*3.56,2.06,axis.y*3.56),Vector3(.94,.14,1.95),Color("7B9389"),yaw)
	for i in 4:
		var x := 4.7+float(i)*.56
		solid_block(Vector3(x,-.09-i*.16,.8),Vector3(.65,.21,2.55-i*.18))

func scatter_foundations(site: int) -> void:
	for i in 23:
		var angle := rng.randf()*TAU
		var offset := Vector2.from_angle(angle)*rng.randf_range(8.9,17.0)
		if absf(offset.y) < 3.6:
			continue
		var height := field.height(Vector2(position.x,position.z)+offset)-position.y
		var size := rng.randf_range(.38,1.63)
		var at := Vector3(offset.x,height-.12,offset.y)
		if i%3==0:
			block(at+Vector3.UP*.23,Vector3(size*1.41,.40+size*.35,size*.79),
				masonry_color(),angle+.51)
		else:
			var shape := Vector3(size*1.15,size*(.70+site*.11),size*1.68)
			var basis := Basis(Vector3.UP,angle).rotated(Vector3.RIGHT,.21).scaled_local(shape)
			stamp(boulder,Transform3D(basis,at),Color("516D70").lerp(Color("799084"),rng.randf()*.44))

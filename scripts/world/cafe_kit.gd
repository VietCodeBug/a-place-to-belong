extends Node3D
## Human-scale kitbash from Kenney Fantasy Town + Furniture + Nature (CC0).
const A = preload("res://scripts/world/field_assets.gd")
const S = preload("res://scripts/world/shapes.gd")
const WALL_HEIGHT := 3.0
const DOOR_HEIGHT := 2.25
const ROOF_HEIGHT := 5.25

func _ready() -> void:
	# Three 3 m frontage modules, two depth modules. Imported doorway is 0.75 of a wall.
	for x in [-3.0,0.0,3.0]:
		var asset := "wall-wood-door" if x == 0 else "wall-wood-window-glass"
		var front := part(asset,Vector3(x,0.3,0),WALL_HEIGHT,-PI/2)
		if x == 0:
			var door := front.find_child("door",true,false)
			if door != null:
				A.recolor(door,"C4A357")
		else:
			var pane := S.box(self,Vector3(x,1.95,0),Vector3(1.05,1.3,0.025),"EAD3A4")
			var glass := S.material("EAD3A4").duplicate()
			glass.emission_enabled = true
			glass.emission = Color("D5B373")
			glass.emission_energy_multiplier = 0.15
			pane.material_override = glass
		part("wall-wood",Vector3(x,0.3,-6),WALL_HEIGHT,PI/2)
	for z in [-1.5,-4.5]:
		part("wall-wood-window-glass",Vector3(4.35,0.3,z),WALL_HEIGHT)
		part("wall-wood",Vector3(-4.35,0.3,z),WALL_HEIGHT,PI)
	var roof := part("roof-gable",Vector3(0,3.3,-3),1.95,PI/2)
	fit(roof,Vector3(7,1.95,9.8))
	var roof_mat := ShaderMaterial.new()
	roof_mat.shader = preload("res://shaders/timber_roof.gdshader")
	A.override_material(roof,roof_mat)
	S.box(self,Vector3(0,5.25,-3),Vector3(0.2,0.14,7.1),"BA785B")
	part("chimney",Vector3(-2.8,4.1,-4.6),1.6)
	# A simple structural deck supports imported walls/props; no placeholder wall used as a floor.
	var deck := S.box(self,Vector3(0,0.13,1.5),Vector3(9,0.26,3),"B48A61")
	deck.name = "PorchDeck"
	for i in range(18):
		S.box(self,Vector3(-4.25+i*0.5,0.275,1.5),Vector3(0.47,0.03,3),"B48A61" if i%3 else "A77C55")
	for side in [-1,1]:
		part("pillar-wood",Vector3(side*4.3,0.25,1.3),2.75)
		var rail := part("fence",Vector3(side*4.25,0.3,1.5),0.9,PI/2)
		fit(rail,Vector3(2.7,0.9,0.15))
	var awning := part("roof",Vector3(0,3.0,0.6),0.32,PI/2)
	fit(awning,Vector3(1.6,0.32,9.6))
	A.recolor(awning,"657D58")
	for x in [-2.0,2.0]:
		part("lantern",Vector3(x,2.4,1.1),0.55)
	for x in [-3.5,3.5]:
		var pot := A.place(self,"furniture","pottedPlant",Vector3(x,0.29,2.1),1.0)
		A.style(pot)
	# Exterior remains solid for this slice; invisible simple colliders are independent of art.
	collision(Vector3(0,1.8,-3),Vector3(9,3,6))
	collision(Vector3(0,0.13,1.5),Vector3(9,0.26,3))
	var ramp := S.box(self,Vector3(0,0.075,3.4),Vector3(2.4,0.15,1.1),"B48A61",true)
	ramp.rotation.x = 0.20
	# Postal parcels live on one side; the central 2.4 m entrance stays clear.
	for i in range(3):
		var parcel := A.place(self,"furniture","cardboardBoxClosed",Vector3(2.5+i*0.45,0.3,0.9),0.4+i*0.12,i*0.2)
		A.style(parcel)
	S.box(self,Vector3(0,3.65,0.57),Vector3(2.15,0.68,0.12),"496B59")
	var plaque := Label3D.new()
	plaque.text = "FOREST POST\n& CAFÉ"
	plaque.font_size = 48
	plaque.pixel_size = 0.0045
	plaque.position = Vector3(0,3.65,0.64)
	plaque.modulate = Color("F6E8D0")
	add_child(plaque)

func part(asset: String, at: Vector3, height: float, yaw := 0.0) -> Node3D:
	var n := A.place(self,"fantasy-town",asset,at,height,yaw)
	A.style(n)
	return n

func fit(node: Node3D, size: Vector3) -> void:
	# Work in model-local space so a rotated component keeps its intended axis sizes.
	var saved := node.transform
	node.transform = Transform3D.IDENTITY
	var b := A.bounds(node)
	node.transform = saved
	node.scale = size/b.size

func collision(at: Vector3, size: Vector3) -> void:
	var body := StaticBody3D.new()
	var c := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	c.shape = shape
	body.add_child(c)
	add_child(body)
	body.position = at

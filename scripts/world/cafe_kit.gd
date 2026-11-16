extends Node3D
## V04: a main café hall, a lower postal wing and an occupied, deep veranda.
const A = preload("res://scripts/world/field_assets.gd")
const S = preload("res://scripts/world/shapes.gd")
const WALL_HEIGHT := 3.25
const DOOR_HEIGHT := 2.25
const ROOF_HEIGHT := 7.0
var roof_material: ShaderMaterial

func _ready() -> void:
	roof_material = ShaderMaterial.new()
	roof_material.shader = preload("res://shaders/timber_roof.gdshader")
	# Hall: 9 x 11 m; postal wing: 6 x 8 m, stepped back at the rear.
	for z in [-1.375,-4.125,-6.875,-9.625]:
		panel(Vector3(-7.5,0.35,z),2.75,3.25,PI)
	for x in [-6.0,-3.0,0.0]:
		panel(Vector3(x,0.35,-11),3,3.25,PI/2)
	for z in [-1.33,-4.0,-6.67]:
		panel(Vector3(7.5,0.35,z),2.67,3.0,0)
	for x in [3.0,6.0]:
		panel(Vector3(x,0.35,-8),3,3.0,PI/2)
	# Exposed upper hall wall beyond the lower service wing.
	panel(Vector3(1.5,0.35,-9.5),3,3.25,0)
	var entrance := part("wall-wood-door",Vector3(0,0.35,0),3.0,-PI/2)
	var door := entrance.find_child("door",true,false)
	if door != null:
		A.recolor(door,"C2A051")
	panel(Vector3(0,3.35,0),3,0.25,-PI/2)
	bay_window(-4.5,6.0,true)
	bay_window(4.5,6.0,false)
	# Cream lintels and visible heavy timber unify the two volumes.
	for x in [-7.5,-1.5,1.5,7.5]:
		var post := part("pillar-wood",Vector3(x,0.3,0),3.35)
		fit(post,Vector3(0.24,3.35,0.24))
	var main_roof := roof("MainHallRoof",Vector3(-3,3.6,-5.5),Vector3(12.2,3.4,10.4),PI/2)
	main_roof.set_meta("ridge_height",7.0)
	roof("PostalWingRoof",Vector3(4.5,3.35,-4),Vector3(7,2.4,9.2))
	# A real cross-gabled dormer breaks the long hall roof silhouette.
	var dormer := part("wall-wood-window-glass",Vector3(0.75,4.35,-5.5),1.6)
	fit(dormer,Vector3(0.22,1.6,2.15))
	roof("DormerRoof",Vector3(-0.3,5.9,-5.5),Vector3(3.1,1.0,2.7))
	part("chimney",Vector3(-5.3,5.35,-8.2),2.0)
	# Large veranda with a covered seating wing and a separate postal queue.
	var deck := S.box(self,Vector3(0,0.18,2),Vector3(15.6,0.36,4),"9D7956")
	deck.name = "PorchDeck"
	for i in range(32):
		S.box(self,Vector3(-7.55+i*0.487,0.375,2),Vector3(0.465,0.03,4),"B28D65" if i%4 else "A5805C")
	for x in [-7.3,-3.9,3.9,7.3]:
		var post := part("pillar-wood",Vector3(x,0.35,3.3),2.8)
		fit(post,Vector3(0.21,2.8,0.21))
	var canopy := part("roof",Vector3(0,2.9,1.25),0.55,PI/2)
	fit(canopy,Vector3(2.55,0.55,16.0))
	A.recolor(canopy,"667C57")
	# Entry canopy gable reads independently from the veranda shed roof.
	roof("EntranceGable",Vector3(0,3.05,2.4),Vector3(3.9,1.25,3.7),PI/2)
	for x in [-6.5,6.5]:
		var railing := part("fence",Vector3(x,0.4,3.7),0.85)
		fit(railing,Vector3(2.3,0.85,0.16))
	collision(Vector3(-3,1.95,-5.5),Vector3(9,3.2,11))
	collision(Vector3(4.5,1.85,-4),Vector3(6,3.0,8))
	collision(Vector3(0,0.18,2),Vector3(15.6,0.36,4))
	# Two shallow ramps allow walk-on access without adding a step controller.
	var ramp := S.box(self,Vector3(0,0.11,4.6),Vector3(2.8,0.18,1.6),"A5835E",true)
	ramp.rotation.x = 0.22
	for x in [-6.3,-1.9,2.0,6.3]:
		part("lantern",Vector3(x,2.55,0.8),0.5)
		var glass := S.box(self,Vector3(x,2.78,0.85),Vector3(0.1,0.18,0.1),"FFD29B")
		var lit := S.material("FFD29B").duplicate()
		lit.emission_enabled = true
		lit.emission = Color("FFD29B")
		lit.emission_energy_multiplier = 0.7
		glass.material_override = lit
		var lamp := OmniLight3D.new()
		lamp.position = Vector3(x,2.3,0.85)
		lamp.light_color = Color("FFD39C")
		lamp.light_energy = 0.5
		lamp.omni_range = 2.8
		add_child(lamp)
	signage(Vector3(-4.5,3.1,0.2),"WOODLAND CAFÉ",1.0)
	signage(Vector3(4.5,3.1,0.2),"FOREST POST",1.0)
	signage(Vector3(0,3.45,4.42),"FOREST POST CAFÉ",0.65)
	timber_details()
	furnish_veranda()

func bay_window(x: float, width: float, cafe_side: bool) -> void:
	# A 4.2 x 2.1 m aperture has 1.3 m of actual room depth behind it.
	panel(Vector3(x,0.35,0),width,0.55,-PI/2)
	panel(Vector3(x,3.0,0),width,0.6,-PI/2)
	for side in [-1,1]:
		panel(Vector3(x+side*2.58,0.9,0),0.84,2.1,-PI/2)
		S.box(self,Vector3(x+side*2.14,1.95,-0.45),Vector3(0.12,2.2,1.0),"B38B61")
	var window_light := OmniLight3D.new()
	window_light.position = Vector3(x,2.2,-0.5)
	window_light.light_color = Color("FFC986")
	window_light.light_energy = 1.25
	window_light.omni_range = 3.2
	add_child(window_light)
	# Recessed cream interior, floor and furnishing can be seen through the opening.
	S.box(self,Vector3(x,1.9,-1.55),Vector3(4.25,2.25,0.12),"BAA78A")
	S.box(self,Vector3(x,0.88,-0.75),Vector3(4.3,0.12,1.7),"B28D65")
	for dx in [-2.15,0,2.15]:
		S.box(self,Vector3(x+dx,1.95,0.08),Vector3(0.095,2.24,0.1),"6E8C80")
	for y in [0.86,3.04]:
		S.box(self,Vector3(x,y,0.1),Vector3(4.45,0.12,0.18),"6E8C80")
	var interior := A.place(self,"furniture","tableRound" if cafe_side else "bookcaseOpenLow",Vector3(x,0.95,-0.9),0.8)
	A.style(interior)
	if cafe_side:
		A.place(self,"furniture","pottedPlant",Vector3(x-1.4,0.95,-0.9),0.7)
	else:
		for i in range(4):
			A.place(self,"furniture","cardboardBoxClosed",Vector3(x-1.4+i*0.85,0.95,-1),0.4+i%2*0.15)

func furnish_veranda() -> void:
	for x in [-5.8,-3.6]:
		var table := A.place(self,"furniture","tableRound",Vector3(x,0.4,2.3),0.78)
		A.style(table)
		A.solid(table)
		for z in [1.35,3.25]:
			var chair := A.place(self,"furniture","chair",Vector3(x,0.4,z),1.0,PI if z>2 else 0)
			A.style(chair)
			A.solid(chair)
	for x in [-7.0,7.0]:
		A.place(self,"furniture","pottedPlant",Vector3(x,0.4,3.1),0.85)
	for i in range(4):
		var parcel := A.place(self,"furniture","cardboardBoxClosed",Vector3(3.8+i*0.6,0.4,1.6),0.45+i%2*0.2,i*0.12)
		A.style(parcel)

func signage(at: Vector3, text: String, size: float) -> void:
	S.box(self,at,Vector3(3.8*size,0.5,0.12),"3C5F50")
	var label := Label3D.new()
	label.text = text
	label.pixel_size = 0.004*size
	label.font_size = 44
	label.position = at+Vector3(0,0,0.075)
	label.modulate = Color("F6E8D0")
	add_child(label)

func roof(label: String, at: Vector3, size: Vector3, yaw := 0.0) -> Node3D:
	var n := part("roof-gable",at,size.y,yaw)
	n.name = label
	fit(n,size)
	A.override_material(n,roof_material)
	return n

func panel(at: Vector3, width: float, height: float, yaw: float) -> Node3D:
	var n := part("wall-wood",at,height,yaw)
	fit(n,Vector3(0.22,height,width))
	return n

func part(asset: String, at: Vector3, height: float, yaw := 0.0) -> Node3D:
	var n := A.place(self,"fantasy-town",asset,at,height,yaw)
	A.style(n)
	return n

func fit(node: Node3D, size: Vector3) -> void:
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

func timber_details() -> void:
	# Visible joinery, eave fascias, gable struts and board courses, at human scale.
	for z in [0.66,-11.66]:
		S.beam(self,Vector3(-8.05,3.65,z),Vector3(-3,6.95,z),0.15,"76553B")
		S.beam(self,Vector3(-3,6.95,z),Vector3(2.05,3.65,z),0.15,"76553B")
		S.beam(self,Vector3(-3,3.65,z),Vector3(-3,6.85,z),0.12,"76553B")
		S.beam(self,Vector3(-6.7,3.8,z),Vector3(-3,5.8,z),0.09,"94714E")
		S.beam(self,Vector3(-3,5.8,z),Vector3(0.7,3.8,z),0.09,"94714E")
	S.box(self,Vector3(-3,3.5,0.68),Vector3(9.9,0.17,0.14),"A8855C")
	for x in [-7.3,-3.9,3.9,7.3]:
		for side in [-1,1]:
			S.beam(self,Vector3(x,2.35,3.3),Vector3(x+side*0.5,3.05,3.3),0.1,"9D7954")
	for x in [-4.5,4.5]:
		for row in range(3):
			S.box(self,Vector3(x,0.43+row*0.15,0.145),Vector3(5.8,0.135,0.055),"A48059" if row%2 else "B28D65")

	for z in [-9.5,-7.0,-4.5,-2.0]:
		S.box(self,Vector3(1.85,3.58,z),Vector3(0.7,0.12,0.13),"8B6947")
		S.box(self,Vector3(-7.85,3.58,z),Vector3(0.7,0.12,0.13),"8B6947")

extends Node3D
const S = preload("res://scripts/world/shapes.gd")
const A = preload("res://scripts/world/field_assets.gd")
const L = preload("res://scripts/world/landscape.gd")
var player: CharacterBody3D
var mailbox: Node3D
var ui: CanvasLayer
var cafe_base := L.CAFE_LEVEL
var collision_probe := Vector3(0,L.CAFE_LEVEL+0.65,2)

func _ready() -> void:
	configure_inputs()
	lighting()
	var landscape := L.new()
	add_child(landscape)
	var cafe := Node3D.new()
	cafe.name = "Cafe"
	cafe.position.y = cafe_base
	cafe.set_script(preload("res://scripts/world/cafe_kit.gd"))
	add_child(cafe)
	mailbox = preload("res://scenes/props/mailbox.tscn").instantiate()
	mailbox.name = "Mailbox"
	add_child(mailbox)
	mailbox.position = Vector3(3.6,0.4,3.5)
	build_bicycle(Vector3(-1.9,cafe_base+0.4,2.3))
	landmarks()
	var forest := Node3D.new()
	forest.name = "LicensedWoodland"
	forest.set_script(preload("res://scripts/world/woodland.gd"))
	add_child(forest)
	var floor_cover := preload("res://scripts/world/ground_cover.gd").new()
	floor_cover.name = "CuratedGroundCover"
	add_child(floor_cover)
	var eggeght := preload("res://scenes/npc/eggeght.tscn").instantiate()
	eggeght.name = "Eggeght"
	add_child(eggeght)
	eggeght.position = ground(-5.4,6.8)
	player = preload("res://scenes/player/postal_worker.tscn").instantiate()
	player.name = "Player"
	add_child(player)
	player.position = ground(1,13,0.15)
	player.floor_snap_length = 0.45
	var camera := Camera3D.new()
	camera.name = "GameplayCamera"
	camera.set_script(preload("res://scripts/player/follow_camera.gd"))
	camera.target = player
	add_child(camera)
	ui = CanvasLayer.new()
	ui.set_script(preload("res://scripts/interactions/interaction_controller.gd"))
	ui.player = player
	add_child(ui)

func ground(x: float, z: float, extra := 0.0) -> Vector3:
	return Vector3(x,L.height_at(x,z)+extra,z)

func lighting() -> void:
	var world := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_SKY
	var sky := Sky.new()
	var atmosphere := ProceduralSkyMaterial.new()
	atmosphere.sky_top_color = Color("789794")
	atmosphere.sky_horizon_color = Color("DDCCAD")
	atmosphere.ground_horizon_color = Color("BFC6B4")
	atmosphere.ground_bottom_color = Color("7A8E82")
	atmosphere.sky_energy_multiplier = 0.65
	sky.sky_material = atmosphere
	env.sky = sky
	env.background_color = Color("AABCB7")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("A8B5AC")
	env.ambient_light_energy = 0.85
	# Godot 4.6 Compatibility supports SSAO; validated with frozen-camera A/B.
	env.ssao_enabled = true
	env.ssao_radius = 0.55
	env.ssao_intensity = 0.65
	env.ssao_power = 1.1
	env.fog_enabled = true
	env.fog_light_color = Color("B3BFAF")
	env.fog_light_energy = 0.45
	env.fog_mode = Environment.FOG_MODE_DEPTH
	env.fog_depth_begin = 38
	env.fog_depth_end = 155
	world.environment = env
	add_child(world)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-32,-44,0)
	sun.light_color = Color("FFD0A1")
	sun.light_energy = 0.82
	sun.shadow_enabled = true
	sun.shadow_normal_bias = 1.1
	sun.shadow_bias = 0.09
	sun.shadow_blur = 2
	sun.directional_shadow_max_distance = 100
	add_child(sun)

func landmarks() -> void:
	# Same Map 01 postal corner beside the existing mailbox.
	A.place(self,"furniture","bookcaseOpenLow",ground(9.0,1.4),1.15,PI/2)
	for i in range(3):
		A.place(self,"furniture","cardboardBoxClosed",ground(9.0+i*0.5,3.0),0.4+i*0.12,i*0.12)
	for x in [8.5,10.5]:
		A.place(self,"furniture","pottedPlant",ground(x,4.6),0.75)
	A.place(self,"nature","sign",ground(6.0,7.3),1.4,-0.3)

func configure_inputs() -> void:
	var bindings := {"move_left":KEY_A,"move_right":KEY_D,"move_up":KEY_W,"move_down":KEY_S,"jog":KEY_SHIFT,"interact":KEY_E}
	for action in bindings:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
			var key := InputEventKey.new()
			key.physical_keycode = bindings[action]
			InputMap.action_add_event(action,key)

func build_bicycle(p: Vector3) -> void:
	var bike := Node3D.new()
	bike.name = "DeliveryBicycle"
	add_child(bike)
	bike.position = p
	for x in [-0.7,0.7]:
		var wheel := TorusMesh.new()
		wheel.inner_radius = 0.34
		wheel.outer_radius = 0.45
		wheel.rings = 12
		wheel.ring_segments = 6
		var n := S.mesh(bike,wheel,Vector3(x,0.46,0),"343C38")
		n.rotation.x = PI/2
		for j in range(6):
			var a := j*PI/3
			S.beam(bike,Vector3(x,0.46,0),Vector3(x+cos(a)*0.36,0.46+sin(a)*0.36,0),0.025,"B6B8AA")
	var a := Vector3(-0.7,0.46,0)
	var b := Vector3(0,0.46,0)
	var c := Vector3(-0.25,1.05,0)
	var d := Vector3(0.55,1.05,0)
	for pair in [[a,b],[b,c],[c,a],[c,d],[d,b],[d,Vector3(0.7,0.46,0)]]:
		S.beam(bike,pair[0],pair[1],0.07,"C85E55")
	S.box(bike,Vector3(-0.25,1.15,0),Vector3(0.4,0.12,0.24),"92633F")
	S.beam(bike,d,Vector3(0.55,1.4,0),0.06,"B6B8AA")
	S.box(bike,Vector3(0.55,1.4,0),Vector3(0.1,0.08,0.6),"343C38")
	S.box(bike,Vector3(0.85,1.16,0),Vector3(0.45,0.35,0.46),"D3AF76")
	S.box(bike,Vector3(0,0.5,0),Vector3(2.1,1,0.5),"C85E55").visible = false
	var body := StaticBody3D.new()
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(2.1,1,0.5)
	collision.shape = shape
	bike.add_child(body)
	body.add_child(collision)
	collision.position.y = 0.5

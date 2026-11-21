extends Node3D
const S = preload("res://scripts/world/shapes.gd")
const A = preload("res://scripts/world/field_assets.gd")
const L = preload("res://scripts/world/landscape.gd")
const MAPS = preload("res://scripts/story/map_flow.gd")
const VILLAGE = preload("res://scripts/world/village_a_layout.gd")
const SUPERWORLD = preload("res://scripts/world/superworld/a1_superworld.gd")
const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
const EYES = preload("res://scripts/player/a1_eyes.gd")
const StoryNode = preload("res://scripts/interactions/story_interactable.gd")

var eyes: RefCounted
var story_prototype: Node
var superworld: SUPERWORLD
var player: CharacterBody3D
var mailbox: Node3D
var ui: CanvasLayer
var cafe_base := L.CAFE_LEVEL
var collision_probe := Vector3(0,L.CAFE_LEVEL+0.65,2)

func _ready() -> void:
	var story_mode := has_meta("story_prototype") or "--story-prototype" in OS.get_cmdline_user_args()
	if story_mode:
		set_meta("a1_superworld",true)
		set_meta(MAPS.SHOW_TITLE,false)
	configure_inputs()
	if has_meta("a1_superworld") or "--a1-superworld" in OS.get_cmdline_user_args():
		superworld = SUPERWORLD.new()
		superworld.name = "A1Superworld"
		superworld.field = FIELD.new(Callable(L,"height_at"))
	else:
		var backdrop := preload("res://scripts/world/forest_backdrop.gd").new()
		backdrop.name = "ForestBackdrop"
		add_child(backdrop)
	lighting()
	var landscape := L.new()
	if superworld != null:
		landscape.expansion = superworld.field
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
	var life := preload("res://scripts/environment/forest_life.gd").new()
	life.name = "ForestLife"
	add_child(life)
	var eggeght := preload("res://scenes/npc/eggeght.tscn").instantiate()
	eggeght.name = "Eggeght"
	add_child(eggeght)
	eggeght.position = ground(-5.4,6.8)
	setup_eggeght(eggeght)
	player = preload("res://scenes/player/postal_worker.tscn").instantiate()
	player.name = "Player"
	add_child(player)
	if story_mode or "--a1-superworld" in OS.get_cmdline_user_args():
		eyes = EYES.new()
		eyes.sensitivity = get_tree().get_meta(&"a1_sensitivity",1.0)
		eyes.head_bob = get_tree().get_meta(&"a1_head_bob",true)
		eyes.fov = get_tree().get_meta(&"a1_fov",68.0)
		player.eyes = eyes
		for mesh: MeshInstance3D in player.model.find_children("*","MeshInstance3D",true,false):
			mesh.layers = EYES.AVATAR_LAYER
	place_house_a(story_mode)
	var spawn: Vector2 = VILLAGE.HOUSE_APPROACH[0]
	player.position = ground(spawn.x,spawn.y,0.15)
	player.floor_snap_length = 0.45
	var valley := preload("res://scripts/world/a1_valley.gd").new()
	valley.name = "A1RiverValley"
	add_child(valley)
	if superworld != null:
		add_child(superworld)
		superworld.start(player,get_node("ForestWeather"),valley.current_season)
	var camera := Camera3D.new()
	camera.name = "GameplayCamera"
	camera.set_script(preload("res://scripts/player/follow_camera.gd"))
	camera.target = player
	camera.eyes = eyes
	if superworld != null:
		camera.superworld = superworld
	add_child(camera)
	ui = CanvasLayer.new()
	ui.set_script(preload("res://scripts/interactions/interaction_controller.gd"))
	ui.player = player
	# The existing local Thomas pass can coexist with the village PR.
	var thomas_path := "res://scripts/npc/thomas.gd"
	if not story_mode and ResourceLoader.exists(thomas_path):
		var thomas: Node3D = load(thomas_path).new()
		thomas.name = "Thomas"
		thomas.position = ground(VILLAGE.THOMAS.x,VILLAGE.THOMAS.y)
		thomas.rotation.y = 1.24
		thomas.viewer = player
		thomas.dialogue = ui
		add_child(thomas)
	add_child(ui)
	if story_mode:
		story_prototype = preload("res://scripts/story/prototype/chapter_01.gd").new()
		story_prototype.name = "Chapter01Prototype"
		add_child(story_prototype)
		story_prototype.setup(self)

func place_house_a(expanded: bool) -> void:
	var root := Node3D.new()
	root.name = "ForestHouseA"
	add_child(root)
	root.position = ground(VILLAGE.HOUSE_A.x,VILLAGE.HOUSE_A.y)
	root.rotation.y = -PI*.48
	var home := preload("res://assets/a1_house_gate/hewn_eaves_cottage.glb").instantiate() as Node3D
	home.name = "CottageShell"
	root.add_child(home)
	home.scale = Vector3(1.77,1.25,1.74) if expanded else Vector3.ONE*.79
	if expanded:
		var threshold := Vector3(-.49,.48,2.76)
		home.position = threshold*(Vector3.ONE*.79-home.scale)
	if expanded:
		S.box(home,Vector3(-.44,1.6,-.05),Vector3(5.14,3.2,4.34),"FFFFFF",true).hide()
		S.box(home,Vector3(1.04,.38,2.92),Vector3(.11,.1,.2),"34271C")
		for i in 3:
			var level := .11+float(i)*.082
			S.box(home,Vector3(-.49,level*.5,3.43-float(i)*.24),Vector3(1.38,level,.28),"FFFFFF",true).hide()
	else:
		S.box(home,Vector3(-.40,1.6,0),Vector3(6.22,3.2,4.12),"FFFFFF",true).hide()

func ground(x: float, z: float, extra := 0.0) -> Vector3:
	return Vector3(x,L.height_at(x,z)+extra,z)

func lighting() -> void:
	var rig=preload("res://scripts/lighting/lighting_rig.gd")
	var preset: Resource=null
	if has_meta("lighting_preset"): preset=get_meta("lighting_preset")
	if preset==null: preset=rig.from_arguments()
	rig.apply(self,preset)
	var weather=preload("res://scripts/environment/forest_weather.gd").new()
	weather.name="ForestWeather"
	add_child(weather)

func setup_eggeght(npc: Node3D) -> void:
	var pose := Node3D.new()
	pose.name = "EggeghtPose"
	pose.set_script(preload("res://scripts/npc/eggeght_pose.gd"))
	npc.add_child(pose)
	var chat := StoryNode.new()
	chat.name = "EggeghtChat"
	chat.interaction_name = "Talk to Eggeght"
	chat.interaction_radius = 2.05
	chat.category = "WOODLAND NEIGHBOR  •  PORCH SIDE"
	chat.title = "Eggeght — Morning Regular"
	chat.message = "\"Nothing beats cinnamon drip coffee while watching clouds drift over the northern pines. Have you seen how the lanterns glow along the path at dusk? Even rainy afternoons feel cozy out here.\""
	npc.add_child(chat)

func landmarks() -> void:
	# 1. Porch entrance warm spill lights matching HeroBuilding's front porch lanterns
	for lx in [-1.55, 1.55]:
		add_story_light(Vector3(lx, cafe_base + 2.52, 3.25), 0.95, 6.2)
	add_story_light(Vector3(3.6, cafe_base + 1.85, 4.1), 0.55, 4.2)

	# 2. Porch & mailbox flagstone stepping stones (visual-only, flush with ground)
	var stepping := [
		[Vector2(-0.35, 5.15), 0.16, 0.2],
		[Vector2(0.42, 5.45), 0.14, 1.1],
		[Vector2(-0.12, 5.88), 0.13, 2.3],
		[Vector2(2.85, 4.45), 0.13, 0.7],
		[Vector2(3.55, 4.65), 0.15, 1.8],
	]
	for st in stepping:
		var sp: Vector2 = st[0]
		var stone := A.model("nature", "rock_smallC", float(st[1]))
		A.recolor(stone, "958C7C")
		add_child(stone)
		stone.scale = Vector3(1.85, 0.45, 1.55)
		stone.position = ground(sp.x, sp.y, -0.03)
		stone.rotation.y = float(st[2])

	# 3. Vignette A: Roadside Trail Signpost & Lantern Nook (guides eye from spawn to cafe)
	A.place(self,"nature","sign",ground(6.0,7.3),1.45,-0.32)
	build_lantern_post(ground(5.35, 7.85), 2.15, 0.90, 6.0)
	A.place(self,"nature","fence_planksDouble",ground(7.15,8.35),0.72,-0.52)
	A.place(self,"quaternius","Rock_Moss_1",ground(6.55,7.65,-0.05),0.48,0.8)
	var sign_info := StoryNode.new()
	sign_info.name = "TrailSignpostNote"
	sign_info.position = ground(6.0, 7.3)
	sign_info.interaction_name = "Read trail signpost"
	sign_info.interaction_radius = 1.95
	sign_info.category = "TRAIL & CAFÉ GUIDE"
	sign_info.title = "Forest Post Café — Clearing Directory"
	sign_info.message = "←  Porch Counter & Espresso Hearth\n↑  Mailbox Dispatch Box (Check before heading out!)\n↘  South Meadow Trailhead (%s)\n\nToday's Special: Honey-Oak Roast & Warm Berry Tart." % MAPS.label(MAPS.FOREST)
	add_child(sign_info)

	# 4. Vignette B: Organized Postal Sorting & Firewood Side Yard (right of cafe)
	A.place(self,"furniture","bookcaseOpenLow",ground(9.0,1.4),1.15,PI/2)
	for i in range(3):
		A.place(self,"furniture","cardboardBoxClosed",ground(9.0+i*0.5,3.0),0.4+i*0.12,i*0.12)
	A.place(self,"furniture","cardboardBoxOpen",ground(9.4,2.15),0.44,0.4)
	A.place(self,"fantasy-town","cart",ground(10.7,2.1),1.05,-0.48)
	A.place(self,"nature","log_stack",ground(9.3,-0.65),0.78,1.45)
	for x in [8.5,10.5]:
		A.place(self,"furniture","pottedPlant",ground(x,4.6),0.78)
	build_lantern_post(ground(8.35, 4.95), 2.05, 0.72, 5.2)

	# 5. Vignette C: Cozy Birch-Shade Reading & Tea Bench Nook (left clearing edge)
	var bench := A.place(self,"furniture","bench",ground(-8.8,8.7),0.88,0.58)
	A.solid(bench)
	var side_table := A.place(self,"furniture","tableRound",ground(-7.75,9.35),0.68,0.2)
	A.solid(side_table)
	A.place(self,"furniture","pottedPlant",ground(-7.75,9.35,0.66),0.36,0.9)
	A.place(self,"nature","fence_planksDouble",ground(-9.85,8.15),0.74,0.58)
	A.place(self,"quaternius","Rock_Moss_1",ground(-9.55,9.55,-0.05),0.56,1.7)
	build_lantern_post(ground(-8.15, 7.85), 2.10, 0.82, 5.6)

func build_lantern_post(at: Vector3, height: float, energy: float, light_range: float) -> void:
	var post := Node3D.new()
	post.name = "WoodlandLanternPost"
	post.position = at
	add_child(post)
	S.box(post, Vector3(0, height * 0.5, 0), Vector3(0.13, height, 0.13), "896044", true)
	S.box(post, Vector3(0.20, height - 0.08, 0), Vector3(0.46, 0.09, 0.11), "896044")
	var lantern := A.model("fantasy-town", "lantern", 0.42)
	A.style(lantern)
	post.add_child(lantern)
	lantern.position = Vector3(0.36, height - 0.50, 0)
	var bulb := MeshInstance3D.new()
	var sphere := SphereMesh.new()
	sphere.radius = 0.085
	sphere.height = 0.16
	sphere.radial_segments = 8
	sphere.rings = 4
	bulb.mesh = sphere
	var bulb_mat := StandardMaterial3D.new()
	bulb_mat.albedo_color = Color("FFE3B3")
	bulb_mat.emission_enabled = true
	bulb_mat.emission = Color("FFB969")
	bulb_mat.emission_energy_multiplier = 0.4
	bulb.material_override = bulb_mat
	bulb.set_meta("lantern_bulb", true)
	bulb.position = Vector3(0.36, height - 0.30, 0)
	post.add_child(bulb)
	add_story_light(at + Vector3(0.36, height - 0.32, 0), energy, light_range)

func add_story_light(at: Vector3, energy: float, light_range: float) -> void:
	var light := OmniLight3D.new()
	light.position = at
	light.light_color = Color("FFC987")
	light.light_energy = energy
	light.omni_range = light_range
	light.set_meta("story_lantern", true)
	add_child(light)

func configure_inputs() -> void:
	var bindings := {"move_left":KEY_A,"move_right":KEY_D,"move_up":KEY_W,"move_down":KEY_S,"jog":KEY_SHIFT,"interact":KEY_E}
	if superworld != null or has_meta("a1_superworld") or "--a1-superworld" in OS.get_cmdline_user_args():
		bindings["a1_surface"] = KEY_SPACE
		bindings["a1_dive"] = KEY_CTRL
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

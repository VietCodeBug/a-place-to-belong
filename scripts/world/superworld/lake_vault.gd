extends "res://scripts/world/superworld/lake_masonry.gd"
## A swim-through chamber whose slab opens when the pavilion chime is rung.

const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
const FLOW = preload("res://scripts/story/map_flow.gd")
const SHAPES = preload("res://scripts/world/shapes.gd")
const NOTE = preload("res://scripts/interactions/story_interactable.gd")
const BRONZE := Color("718D8C")
const STONE_BASE := Color("566C74")

var door: AnimatableBody3D
var chime: StoryInteractable
var relic: StoryInteractable
var relic_mesh: MeshInstance3D
var chime_sound: AudioStreamPlayer3D
var opened := false
var relic_found := false

func setup(field: FIELD) -> void:
	var at := FIELD.LAKE_VAULT
	begin_site("MemoryVault",Vector3(at.x,field.height(at)+.55,at.y),48031)
	build_chamber()
	stone_visual("WeatheredChamber")
	build_gate()
	build_relic()
	build_chime(field)

func structure(at: Vector3, size: Vector3, shade: Color) -> void:
	block(at,size,shade)
	var shape := BoxShape3D.new()
	shape.size = size
	collide(shape,at)

func build_chamber() -> void:
	structure(Vector3(0,-.45,0),Vector3(12.0,.78,9.6),STONE_BASE)
	structure(Vector3(5.7,2.66,0),Vector3(.8,5.8,9.7),STONE_BASE)
	for side: float in [-1.0,1.0]:
		structure(Vector3(0,2.66,side*4.55),Vector3(12.0,5.8,.78),STONE_BASE)
		structure(Vector3(-5.7,2.66,side*3.31),Vector3(.83,5.8,3.27),STONE_BASE)
		for bay in 5:
			var x := -4.79+2.04*bay
			block(Vector3(x,2.15,side*4.05),Vector3(.65,4.4,.48),Color("829696"))
			block(Vector3(x,4.48,side*4.02),Vector3(.94,.36,.95),BRONZE)
		for row in 6:
			for bay in 9:
				if row in [2,3] and bay%3==1:
					continue
				var x := -5.59+1.34*bay+float(row%2)*.19
				block(Vector3(x,.41+row*.80,side*4.90),Vector3(1.28,.77,.26),
					Color("647D82").lerp(Color("8E988F"),rng.randf()*.61))
	structure(Vector3(0,5.04,0),Vector3(12.2,.85,9.92),STONE_BASE)
	for bay in 6:
		block(Vector3(-5.16+bay*2.03,4.49,0),Vector3(.47,.53,8.4),Color("6D8F92"))
		block(Vector3(-5.16+bay*2.03,5.45,0),Vector3(1.84,.37,10.0),Color("617883"),rng.randf_range(-.04,.04))
	structure(Vector3(-5.72,4.12,0),Vector3(1.18,1.89,4.08),Color("7D9293"))
	for side: float in [-1.0,1.0]:
		structure(Vector3(-6.02,1.50,side*1.75),Vector3(1.36,3.0,.49),Color("8A9D9A"))
		block(Vector3(-6.16,3.24,side*1.73),Vector3(1.55,.35,.83),BRONZE)
	for x in range(-5,6):
		for z in range(-4,5):
			block(Vector3(x*.99,-.02,z*.98),Vector3(.93,.18,.93),tint("768986",rng.randf()*.72),rng.randf_range(-.045,.045))
	drum(.72,1.03,.60,Vector3(1.45,.40,0),Color("74888D"))
	drum(.92,.84,.18,Vector3(1.45,.77,0),Color("A0AD9E"))
	for i in 5:
		block(Vector3(-6.35-i*.65,-.37-i*.19,0),Vector3(.68,.29,4.25-i*.18),Color("6F8588"))

func build_gate() -> void:
	door = AnimatableBody3D.new()
	door.name = "StoneGate"
	door.sync_to_physics = false
	door.position = Vector3(-5.78,1.58,0)
	add_child(door)
	var shape := BoxShape3D.new()
	shape.size = Vector3(.52,3.28,3.22)
	var collision := CollisionShape3D.new()
	collision.shape = shape
	door.add_child(collision)
	SHAPES.box(door,Vector3.ZERO,shape.size,"486571")
	for x: float in [-.29,.29]:
		for band in 3:
			var rail := SHAPES.box(door,Vector3(x,-1.14+band*1.14,0),Vector3(.16,.13,3.22),"79948F")
			rail.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		var plaque := SHAPES.box(door,Vector3(x,.18,0),Vector3(.12,.87,.87),"A3B9A8")
		plaque.rotation.x = PI*.25

func make_note(label: String, prompt: String, title_text: String, text: String, at: Vector3) -> StoryInteractable:
	var note := NOTE.new()
	note.name = label
	note.position = at
	note.interaction_name = prompt
	note.interaction_radius = 2.6
	note.category = FLOW.text("UNDER THE LAKE","DƯỚI LÒNG HỒ")
	note.title = title_text
	note.message = text
	note.set_meta("focus_radius",.60)
	note.set_meta("physical_prop",true)
	add_child(note)
	return note

func build_relic() -> void:
	relic = make_note("PotteryShard",FLOW.text("Pick up the pottery shard","Nhặt mảnh gốm"),
		FLOW.text("A shard of pottery","Mảnh gốm"),FLOW.text("A thin ivory glaze follows the curve of the clay.",
		"Một vệt men màu ngà còn bám theo đường cong của mảnh gốm."),Vector3(1.45,.93,0))
	var shard := PrismMesh.new()
	shard.size = Vector3(.39,.13,.41)
	relic_mesh = MeshInstance3D.new()
	relic_mesh.mesh = shard
	relic_mesh.rotation.y = -.46
	var porcelain := StandardMaterial3D.new()
	porcelain.albedo_color = Color("BAD8CE")
	porcelain.emission_enabled = true
	porcelain.emission = Color("87DCD4")
	porcelain.emission_energy_multiplier = .32
	relic_mesh.material_override = porcelain
	relic.add_child(relic_mesh)
	relic.activated.connect(collect_relic)

func build_chime(field: FIELD) -> void:
	var p := FIELD.PAVILION+Vector2(1.8,2.3)
	var bell_y := field.height(FIELD.PAVILION)+2.46
	chime = make_note("WaterChime",FLOW.text("Ring the submerged chime","Rung chuông chìm"),
		FLOW.text("The submerged chime","Chuông chìm"),FLOW.text(
			"A low note carries past the garden. Then stone scrapes against stone.",
			"Một tiếng ngân trầm vọng qua khu vườn. Sau đó là tiếng đá chuyển."),
		Vector3(p.x,bell_y,p.y)-position)
	builder = SurfaceTool.new()
	builder.begin(Mesh.PRIMITIVE_TRIANGLES)
	drum(.18,.40,.44,Vector3.ZERO,Color("81ABA0"))
	drum(.40,.48,.12,Vector3.DOWN*.23,Color("B0BCA0"))
	drum(.072,.072,.49,Vector3.UP*.40,Color("527C79"))
	block(Vector3.UP*.68,Vector3(.16,.15,1.16),Color("678480"))
	var mesh := stone_visual("BronzeChime")
	mesh.position = chime.position
	chime_sound = AudioStreamPlayer3D.new()
	chime_sound.max_distance = 26.0
	chime_sound.unit_size = 4.0
	chime_sound.volume_db = -15.0
	chime.add_child(chime_sound)
	chime.activated.connect(ring_chime)

func ring_chime(_title: String, _message: String) -> void:
	if chime_sound.stream == null:
		chime_sound.stream = make_bell_audio()
	chime_sound.play()
	if opened:
		return
	opened = true
	create_tween().tween_property(door,"position:y",4.91,1.12).set_trans(Tween.TRANS_SINE)
	chime.message = FLOW.text("The note fades through the water.",
		"Tiếng chuông ngân rồi tan trong nước.")

func make_bell_audio() -> AudioStreamWAV:
	const RATE := 22050
	var frames := roundi(RATE*1.5)
	var wave := PackedByteArray()
	wave.resize(frames*2)
	for sample in frames:
		var t := float(sample)/RATE
		var attack := smoothstep(0.0,.008,t)
		var bell := (.61*sin(t*TAU*277.0) + .23*sin(t*TAU*411.0)*exp(-t*2.9)
			+ .16*sin(t*TAU*693.0)*exp(-t*4.1))
		wave.encode_s16(2*sample,int(bell*attack*exp(-t*3.45)*27000.0))
	var audio := AudioStreamWAV.new()
	audio.format = AudioStreamWAV.FORMAT_16_BITS
	audio.mix_rate = RATE
	audio.data = wave
	return audio

func collect_relic(_title: String, _message: String) -> void:
	if not opened or relic_found:
		return
	relic_found = true
	relic_mesh.hide()
	relic.remove_from_group("interactables")

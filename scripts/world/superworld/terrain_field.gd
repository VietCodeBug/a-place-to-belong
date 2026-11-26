extends RefCounted
## The authored corridor remains in game coordinates. The rest is a deterministic field.
const REGISTRY = preload("res://assets/world/superworld_regions.json")
const CORE := Rect2(-64, -384, 128, 576)
const LAKE := Vector2(650, -455)
const RADII := Vector2(430, 310)
const WATER := 5.0
const SHORE := Vector2(217, -455)
const SHELF := Vector2(269, -473)
const ARCH := Vector2(305, -471)
const PAVILION := Vector2(336, -456)
const STAIR_GATE := Vector2(380, -416)
const COLONNADE := Vector2(418, -474)
const BROKEN_TOWER := Vector2(478, -402)
const WEST_TRENCH := Vector2(456, -447)
const EAST_TRENCH := Vector2(524, -478)
const TRENCH_BOUNDS := Rect2(413, -546, 158, 155)
const MAX_TRENCH_CUT := 25.0
const TRENCHES := [
	[WEST_TRENCH, Vector2(16.0, 36.0), .26, 22.0],
	[EAST_TRENCH, Vector2(21.0, 42.0), -.47, MAX_TRENCH_CUT],
]
const MEADOW := Vector2(330, 138)
const OVERLOOK := Vector2(270, -825)
const BIOMES := [
	["ancient_woodland",Vector2(5,-320),"Ancient woodland","Rừng cổ thụ"],
	["wildflower_meadow",MEADOW,"Wildflower meadow","Đồng cỏ hoa"],
	["river_valley",Vector2(0,74),"River and bridge","Sông và cầu"],
	["village_a",Vector2(5.2,128),"Village A","Làng A"],
	["highland",OVERLOOK,"Highland overlook","Điểm ngắm cao nguyên"],
	["underwater",ARCH,"Underwater arch","Vòm đá dưới hồ"],
	["pavilion",PAVILION,"Sunken pavilion","Đình đá chìm"],
	["stair_gate",STAIR_GATE,"Stair gate","Cổng bậc đá"],
	["colonnade",COLONNADE,"Colonnade","Hành lang cột"],
	["broken_tower",BROKEN_TOWER,"Broken tower","Tháp vỡ"],
]
const TRAILS := [
	[Vector2(4,-274),Vector2(28,-293),Vector2(64,-309),Vector2(96,-330),Vector2(124,-360),Vector2(159,-407),Vector2(187,-439),SHORE],
	[Vector2(6.6,178),Vector2(47,177),Vector2(83,172),Vector2(123,158),Vector2(162,119),
		Vector2(186,62),Vector2(176,-2),Vector2(170,-91),Vector2(177,-181),Vector2(194,-276),
		Vector2(195,-355),Vector2(204,-420),Vector2(206,-442),Vector2(206,-455),SHORE],
	[Vector2(162,119),Vector2(224,142),Vector2(272,151),MEADOW,Vector2(391,114),
		Vector2(381,62),Vector2(326,28),Vector2(256,29),Vector2(186,62)],
	[SHORE,Vector2(187,-476),Vector2(183,-547),Vector2(201,-620),Vector2(230,-688),
		Vector2(223,-746),Vector2(239,-796),OVERLOOK],
	[Vector2(381,62),Vector2(410,44),Vector2(428,16),Vector2(425,-21),
		Vector2(390,-61),Vector2(340,-81),Vector2(298,-87),Vector2(247,-67),Vector2(213,-31),Vector2(176,-2)],
	[Vector2(204,-420),Vector2(185,-408),Vector2(165,-423),Vector2(164,-447),
		Vector2(174,-472),Vector2(187,-476)]
]
const STEP := 8.0
enum Habitat { OLD_GROVE, CONIFER, BROADLEAF, FLOWER_MEADOW, GLADE, SHORE, ROCK, HIGHLAND }
const PEAKS := [
	Vector4(-1280,-1310,590,136),Vector4(-745,-1595,470,165),Vector4(440,-1600,540,155),
	Vector4(1070,-1310,480,122),Vector4(1530,-885,490,151),Vector4(1530,410,640,132),
	Vector4(-1390,790,670,180),Vector4(-640,1560,680,127)
]
const RESTS := [Vector2(422,10),Vector2(299,-80),Vector2(172,-452),Vector2(271,-829)]
const MEADOW_COURSE := Vector2(325,114)
var bounds: Rect2
var chunk_size: int
var regions: Array
var legacy_height: Callable
var broad := FastNoiseLite.new()
var folds := FastNoiseLite.new()
var detail := FastNoiseLite.new()
var ecology := FastNoiseLite.new()
var trail_segments: Array[Vector4] = []

func _init(sample_core: Callable) -> void:
	legacy_height = sample_core
	regions = REGISTRY.data.regions
	var a1: Dictionary = regions[0]
	var width := Vector2(a1.extent_m[0],a1.extent_m[1])
	bounds = Rect2(Vector2(a1.origin[0],a1.origin[1])-width*.5,width)
	chunk_size = a1.chunk_m
	broad.seed = a1.seed
	broad.frequency = .00105
	folds.seed = a1.seed + 170
	folds.frequency = .0031
	detail.seed = a1.seed + 360
	detail.frequency = .012
	ecology.seed = a1.seed+744
	ecology.frequency = .007
	for path in TRAILS:
		for i in range(path.size()-1):
			var a: Vector2 = path[i]
			var b: Vector2 = path[i+1]
			trail_segments.append(Vector4(a.x,a.y,b.x,b.y))

func lake_ratio(p: Vector2) -> float:
	var axis := (p-LAKE)/RADII
	return axis.length()/shore_shape(axis.angle())

func shore_shape(angle: float) -> float:
	# Retain the west landing and the existing swim corridor. Wide lobes shape the far shore.
	var west := smoothstep(-.97,-.66,cos(angle))
	var coves := .090*sin(angle*2.0+.9)+.048*sin(angle*5.0-.7)+.027*cos(angle*8.0)
	return 1.0+coves*west

func lake_outline(angle: float) -> Vector2:
	return LAKE+Vector2.from_angle(angle)*RADII*shore_shape(angle)

func shore_rockiness(p: Vector2) -> float:
	var wetland := sin((p.y+455.0)*.034 + p.x*.009)*.42
	var grain := ecology.get_noise_2d(p.x+73,p.y-520)*.66
	return clampf(.40+wetland+grain,0.0,1.0)

func trench_distance(p: Vector2, channel: Array) -> float:
	var center: Vector2 = channel[0]
	var radii: Vector2 = channel[1]
	var axis := (p-center).rotated(channel[2])
	axis.x += sin(axis.y*.137) * 2.8
	return (axis/radii).length()

func trench_influence(p: Vector2) -> float:
	if not TRENCH_BOUNDS.has_point(p):
		return 0.0
	var influence := 0.0
	for channel: Array in TRENCHES:
		influence = maxf(influence,1.0-smoothstep(.63,1.31,trench_distance(p,channel)))
	return influence

func trench_cut(p: Vector2) -> float:
	if not TRENCH_BOUNDS.has_point(p):
		return 0.0
	var cut := 0.0
	for channel: Array in TRENCHES:
		var d := trench_distance(p,channel)
		var rim := 1.0-smoothstep(.34,1.05,d)
		cut = maxf(cut,float(channel[3])*rim)
	return cut

func forest_cover(p: Vector2) -> float:
	var hills := ecology.get_noise_2d(p.x,p.y)
	var lobes := broad.get_noise_2d(p.x+1440,p.y-272)
	return clampf(.58+hills*.56+lobes*.46,.06,.96)

func habitat(p: Vector2, height_m: float, slope: float = 0.0) -> Habitat:
	var shore := lake_ratio(p)
	if shore >= .997 and shore < 1.073:
		return Habitat.SHORE
	if p.distance_squared_to(MEADOW_COURSE)<166.0*166.0:
		return Habitat.FLOWER_MEADOW
	if p.distance_squared_to(OVERLOOK)<111.0*111.0:
		return Habitat.HIGHLAND
	if slope > .77 or height_m > 151.0:
		return Habitat.ROCK
	if p.y < -185.0 and p.y > -470.0 and absf(p.x)<230.0:
		return Habitat.OLD_GROVE
	if forest_cover(p) < .39:
		return Habitat.GLADE
	if height_m > 52.0 or (p.y < -750.0 and p.x<420.0):
		return Habitat.CONIFER
	return Habitat.BROADLEAF

func tile(p: Vector2) -> Vector2i:
	return Vector2i(floori(p.x/chunk_size),floori(p.y/chunk_size))

func is_core(p: Vector2) -> bool:
	return CORE.has_point(p)

func is_core_tile(id: Vector2i) -> bool:
	return is_core(Vector2(id)*chunk_size + Vector2.ONE*chunk_size*.5)

func tile_valid(id: Vector2i) -> bool:
	return bounds.has_point(Vector2(id)*chunk_size+Vector2.ONE)

func trail_distance(p: Vector2) -> float:
	if p.x > 452.0 or p.x < 18.0 or p.y < -854.0 or p.y > 201.0:
		return INF
	var nearest_squared := INF
	for seam in trail_segments:
		if p.y < minf(seam.y,seam.w)-23.0 or p.y > maxf(seam.y,seam.w)+23.0:
			continue
		if p.x < minf(seam.x,seam.z)-23.0 or p.x > maxf(seam.x,seam.z)+23.0:
			continue
		var a := Vector2(seam.x,seam.y)
		var b := Vector2(seam.z,seam.w)
		var nearest := Geometry2D.get_closest_point_to_segment(p,a,b)
		nearest_squared = minf(nearest_squared,p.distance_squared_to(nearest))
	return sqrt(nearest_squared)

func outside_shape(p: Vector2) -> float:
	var roll := broad.get_noise_2d(p.x,p.y)
	var fold := folds.get_noise_2d(p.x,p.y)
	var ridges := smoothstep(360.0,1800.0,absf(p.x+75.0)) * .8
	ridges = maxf(ridges,smoothstep(460.0,1920.0,absf(p.y)))
	var h := 17.0 + 21.0*roll + 12.0*fold + detail.get_noise_2d(p.x,p.y)*2.1
	h += ridges*ridges*(58.0+52.0*absf(fold))
	var crest := 0.0
	for massif: Vector4 in PEAKS:
		var local := Vector2(p.x-massif.x,p.y-massif.y)
		var extent := local.length_squared()/(massif.z*massif.z)
		if extent < 3.0:
			var striation := .84+.13*fold+.095*sin(local.x*.018-local.y*.013)
			crest = maxf(crest,massif.w*exp(-extent*1.65)*striation)
	h += crest
	var pass_weight := 1.0 - smoothstep(4.0,23.0,trail_distance(p))
	var highland := (1.0-smoothstep(0.0,180.0,p.distance_to(OVERLOOK)))
	h += 52.0*highland
	var meadow := 1.0-smoothstep(30.0,125.0,p.distance_to(MEADOW))
	var meadow_rise := 13.0 + 4.8*sin(p.x*.041+p.y*.018) + 2.9*cos(p.y*.049)+roll*5.5
	h = lerpf(h,meadow_rise,meadow*.83)
	var pass_grade := 7.0 + 9.0*sin(clampf((p.y+455.0)/635.0,0,1)*PI)
	pass_grade += 53.0*(1.0-smoothstep(-825.0,-520.0,p.y))
	h = lerpf(h,pass_grade,pass_weight*.87)
	# A traversable, wide crest on the lake-facing side of the ridge.
	var plateau := 1.0-smoothstep(19.0,88.0,p.distance_to(OVERLOOK))
	h = lerpf(h,61.0+(p.y-OVERLOOK.y)*.032,plateau)
	if p.distance_squared_to(OVERLOOK)<420.0*420.0:
		var downhill := (LAKE-OVERLOOK).normalized()
		var at := p-OVERLOOK
		var lead := at.dot(downhill)
		var flank := absf(at.cross(downhill))
		var face := smoothstep(6.0,22.0,lead)*(1.0-smoothstep(215.0,390.0,lead))
		face *= 1.0-smoothstep(42.0,105.0,flank)
		h = lerpf(h,minf(h,61.0-.29*maxf(0.0,lead-12.0)),face)
	var d := lake_ratio(p)
	if d < 1.20:
		# Shore is the zero contour of the bathymetry. A shallow western shelf
		# leads into a deeper central basin a few dozen metres offshore.
		var shelf := exp(-pow((p.y+471.0)/54.0,2))*(1.0-smoothstep(270.0,650.0,p.x))
		var depth := 30.0*pow(maxf(0.0,1.0-d),.88)
		depth *= 1.0 - shelf*.50*smoothstep(.45,.98,d)
		var waterbed := WATER - depth + maxf(0.0,d-1.0)*56.0
		var ripple := detail.get_noise_2d(p.x,p.y)*1.0
		var cauldron := smoothstep(322.0,426.0,p.x)*(1.0-smoothstep(705.0,880.0,p.x))
		ripple += cauldron*(1.7*sin(p.y*.043+.75*sin(p.x*.033))+fold*2.8)
		var channel := smoothstep(346.0,450.0,p.x)*(1.0-smoothstep(810.0,935.0,p.x))
		var axis := p.y+468.0-22.0*sin(p.x*.015)
		ripple -= channel*3.8*exp(-axis*axis/3550.0)
		var bank := shore_rockiness(p)*(1.0-smoothstep(.025,.13,absf(d-1.0)))
		ripple += bank*2.65*smoothstep(1.005,1.07,d)
		waterbed += ripple*smoothstep(0.0,.13,absf(d-1.0))
		waterbed -= trench_cut(p)
		h = lerpf(waterbed,h,smoothstep(1.055,1.20,d))
	return h

func vertex(p: Vector2) -> float:
	var inset := minf(minf(p.x-CORE.position.x,CORE.end.x-p.x),
		minf(p.y-CORE.position.y,CORE.end.y-p.y))
	if inset > 0.01:
		return legacy_height.call(p.x,p.y)
	if inset >= -.01:
		# Linear coarse samples on the four shared edges. The finer corridor
		# mesh uses these exact positions so there are no edge T-junction gaps.
		var along_x := p.y == CORE.position.y or p.y == CORE.end.y
		var axis := Vector2.RIGHT if along_x else Vector2.DOWN
		var span := p.dot(axis)
		var offset := fposmod(span,STEP)
		var a := p-axis*offset
		var b := a+axis*STEP
		return lerpf(legacy_height.call(a.x,a.y),legacy_height.call(b.x,b.y),offset/STEP)
	var edge := p.clamp(CORE.position,CORE.end)
	var dist := p.distance_to(edge)
	var outer := outside_shape(p)
	if dist > 56.0:
		return outer
	var datum: float = legacy_height.call(edge.x,edge.y)
	return lerpf(datum,outer,smoothstep(0.0,56.0,dist))

func height(p: Vector2) -> float:
	var step := 2.0 if is_core(p) else STEP
	var a := (p/step).floor()*step
	var uv := (p-a)/step
	var b := a+Vector2(step,0)
	var c := a+Vector2(0,step)
	if uv.x+uv.y <= 1.0:
		var y := vertex(a)
		return y+(vertex(b)-y)*uv.x+(vertex(c)-y)*uv.y
	var y := vertex(a+Vector2.ONE*step)
	return y+(vertex(c)-y)*(1.0-uv.x)+(vertex(b)-y)*(1.0-uv.y)

func ground_color(p: Vector2, y: float) -> Color:
	var d := lake_ratio(p)
	var n := clampf(ecology.get_noise_2d(p.x,p.y)*1.15+.5,0,1)
	if d < 1.056:
		var shore := shore_rockiness(p)
		var sand := Color("B2A17A").lerp(Color("7F6B4B"),n*.63)
		var bank := sand.lerp(Color("6B7063").lerp(Color("535647"),n),smoothstep(.29,.82,shore))
		var silt := bank.lerp(Color("47594B"),smoothstep(1.2,12.0,WATER-y))
		silt = silt.lerp(Color("293E39"),smoothstep(11.0,28.0,WATER-y))
		if y < WATER-14.0:
			silt = silt.lerp(Color("142A37").lerp(Color("2A4353"),n),trench_influence(p))
		return silt.lerp(Color("4D6537").lerp(Color("65634A"),shore),smoothstep(1.008,1.056,d))
	var band := habitat(p,y)
	var color := [Color("4D6039"),Color("435941"),Color("557243"),Color("788444"),
		Color("76834F"),Color("6B7147"),Color("686961"),Color("666C49")][band] as Color
	var cover := forest_cover(p)
	color = color.lerp(Color("293F34"),smoothstep(.50,.86,cover)*.48)
	color = color.lerp(Color("857461"),smoothstep(65.0,161.0,y)*.47)
	return color.darkened(n*.18).lightened((1.0-n)*.12)

func map_color(p: Vector2, y: float) -> Color:
	if lake_ratio(p)<1.0:
		var water := Color("72ABB0").lerp(Color("37757F"),smoothstep(0.0,25.0,WATER-y))
		return water.lerp(Color("1B455F"),trench_influence(p)*.82)
	return ground_color(p,y)

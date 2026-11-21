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
const MEADOW := Vector2(330, 138)
const OVERLOOK := Vector2(270, -825)
const BIOMES := [
	["ancient_woodland",Vector2(5,-320),"Ancient woodland","Rừng cổ thụ"],
	["wildflower_meadow",MEADOW,"Wildflower meadow","Đồng cỏ hoa"],
	["river_valley",Vector2(0,74),"River and bridge","Sông và cầu"],
	["village_a",Vector2(5.2,128),"Village A","Làng A"],
	["highland",OVERLOOK,"Highland overlook","Điểm ngắm cao nguyên"],
	["underwater",ARCH,"Underwater arch","Vòm đá dưới hồ"]
]
const TRAILS := [
	[Vector2(4,-274),Vector2(28,-293),Vector2(64,-309),Vector2(96,-330),Vector2(124,-360),Vector2(159,-407),Vector2(187,-439),SHORE],
	[Vector2(6.6,178),Vector2(47,177),Vector2(83,172),Vector2(123,158),Vector2(162,119),
		Vector2(186,62),Vector2(176,-2),Vector2(170,-91),Vector2(177,-181),Vector2(194,-276),
		Vector2(195,-355),Vector2(204,-420),SHORE],
	[Vector2(162,119),Vector2(224,142),Vector2(272,151),MEADOW,Vector2(391,114),
		Vector2(381,62),Vector2(326,28),Vector2(256,29),Vector2(186,62)],
	[SHORE,Vector2(187,-476),Vector2(183,-547),Vector2(201,-620),Vector2(230,-688),
		Vector2(223,-746),Vector2(239,-796),OVERLOOK]
]
const STEP := 8.0
var bounds: Rect2
var chunk_size: int
var regions: Array
var legacy_height: Callable
var broad := FastNoiseLite.new()
var folds := FastNoiseLite.new()
var detail := FastNoiseLite.new()

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

func lake_ratio(p: Vector2) -> float:
	return ((p-LAKE)/RADII).length()

func tile(p: Vector2) -> Vector2i:
	return Vector2i(floori(p.x/chunk_size),floori(p.y/chunk_size))

func is_core(p: Vector2) -> bool:
	return CORE.has_point(p)

func is_core_tile(id: Vector2i) -> bool:
	return is_core(Vector2(id)*chunk_size + Vector2.ONE*chunk_size*.5)

func tile_valid(id: Vector2i) -> bool:
	return bounds.has_point(Vector2(id)*chunk_size+Vector2.ONE)

func trail_distance(p: Vector2) -> float:
	if p.x > 414.0 or p.x < 20.0 or p.y < -854.0 or p.y > 201.0:
		return INF
	var distance := INF
	for path in TRAILS:
		for i in range(path.size()-1):
			var a: Vector2 = path[i]
			var b: Vector2 = path[i+1]
			if p.y < minf(a.y,b.y)-23 or p.y > maxf(a.y,b.y)+23:
				continue
			var nearest := Geometry2D.get_closest_point_to_segment(p,a,b)
			distance = minf(distance,p.distance_to(nearest))
	return distance

func outside_shape(p: Vector2) -> float:
	var roll := broad.get_noise_2d(p.x,p.y)
	var fold := folds.get_noise_2d(p.x,p.y)
	var ridges := smoothstep(360.0,1800.0,absf(p.x+75.0)) * .8
	ridges = maxf(ridges,smoothstep(460.0,1920.0,absf(p.y)))
	var h := 17.0 + 21.0*roll + 12.0*fold + detail.get_noise_2d(p.x,p.y)*2.1
	h += ridges*ridges*(110.0+98.0*absf(fold))
	var pass_weight := 1.0 - smoothstep(4.0,23.0,trail_distance(p))
	var highland := (1.0-smoothstep(0.0,180.0,p.distance_to(OVERLOOK)))
	h += 52.0*highland
	var meadow := 1.0-smoothstep(30.0,125.0,p.distance_to(MEADOW))
	h = lerpf(h,12.0 + 8.0*roll + 3.5*fold,meadow*.72)
	var pass_grade := 7.0 + 9.0*sin(clampf((p.y+455.0)/635.0,0,1)*PI)
	pass_grade += 53.0*(1.0-smoothstep(-825.0,-520.0,p.y))
	h = lerpf(h,pass_grade,pass_weight)
	# A traversable, wide crest on the lake-facing side of the ridge.
	var plateau := 1.0-smoothstep(19.0,88.0,p.distance_to(OVERLOOK))
	h = lerpf(h,61.0+(p.y-OVERLOOK.y)*.032,plateau)
	var d := lake_ratio(p)
	if d < 1.20:
		# Shore is the zero contour of the bathymetry. A shallow western shelf
		# leads into a deeper central basin a few dozen metres offshore.
		var shelf := exp(-pow((p.y+471.0)/54.0,2))*(1.0-smoothstep(270.0,650.0,p.x))
		var depth := 30.0*pow(maxf(0.0,1.0-d),.88)
		depth *= 1.0 - shelf*.50*smoothstep(.45,.98,d)
		var waterbed := WATER - depth + maxf(0.0,d-1.0)*56.0
		var ripple := detail.get_noise_2d(p.x,p.y)*1.1
		waterbed += ripple*smoothstep(0.0,.13,absf(d-1.0))
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
	if d < 1.043:
		var silt := Color("8C8265").lerp(Color("395950"),smoothstep(1.5,19.0,WATER-y))
		return silt.lerp(Color("65754F"),smoothstep(.998,1.043,d))
	var noise := (folds.get_noise_2d(p.x,p.y)+1.0)*.5
	var grassy := Color("608163").lerp(Color("A2AB73"),noise)
	grassy = grassy.lerp(Color("8D948B"),smoothstep(68.0,140.0,y))
	return grassy

func map_color(p: Vector2, y: float) -> Color:
	if lake_ratio(p)<1.0:
		return Color("72ABB0").lerp(Color("37757F"),smoothstep(0.0,25.0,WATER-y))
	return ground_color(p,y)

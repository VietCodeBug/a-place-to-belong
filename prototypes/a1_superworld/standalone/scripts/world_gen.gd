class_name A1WorldGen
extends RefCounted
## Deterministic height field. All terrain, lake bottom and gameplay collision use it.
const HALF := 2048.0
const SIZE := 4096.0
const WATER_LEVEL := 5.0
const LAKE_CENTER := Vector2(780.0, -530.0)
const LAKE_RADIUS := Vector2(430.0, 310.0)
const HOUSE := Vector2(-115.0, 15.0)
const VILLAGE := Vector2(50.0, 455.0)
const BRIDGE := Vector2(0.0, 240.0)
const PIER := Vector2(360.0, -530.0)
const UNDERWATER := Vector2(795.0, -535.0)

var broad := FastNoiseLite.new()
var ridges := FastNoiseLite.new()
var detail := FastNoiseLite.new()

func _init() -> void:
	broad.seed = 320615
	broad.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	broad.frequency = 0.0010
	ridges.seed = 20261121
	ridges.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	ridges.frequency = 0.0034
	detail.seed = 78122
	detail.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	detail.frequency = 0.0120

func lake_ratio(x: float, z: float) -> float:
	return Vector2((x-LAKE_CENTER.x)/LAKE_RADIUS.x, (z-LAKE_CENTER.y)/LAKE_RADIUS.y).length()

func river_z(x: float) -> float:
	return 239.0 - x * .94 + 73.0 * sin(x * .0037)

func terrain_height(x: float, z: float) -> float:
	var low := broad.get_noise_2d(x,z)
	var fold := absf(ridges.get_noise_2d(x,z))
	var fine := detail.get_noise_2d(x,z)
	var hills := 13.0 + low * 44.0 + (fold - .35) * 32.0 + fine * 4.0
	var mx := smoothstep(680.0,1800.0,absf(x))
	var mz := smoothstep(950.0,1950.0,absf(z))
	var mountain := maxf(mx,mz)
	hills += mountain*mountain*(90.0+210.0*absf(broad.get_noise_2d(x+1333.0,z-500.0)))
	# Existing story spine stays easy to walk; outer world is much more rugged.
	var spine_distance := absf(x - 23.0*sin(z*.013))
	var spine_factor := (1.0-smoothstep(60.0,165.0,spine_distance)) * (1.0-smoothstep(590.0,760.0,z)) * smoothstep(-150.0,-40.0,z)
	hills = lerpf(hills, 11.0 + .022*z + low*2.5, spine_factor*.86)
	# Connected river, from distant watershed through bridge to the big lake.
	var river_dist := absf(z-river_z(x))
	var river_carve := 1.0 - smoothstep(14.0,66.0,river_dist)
	hills = lerpf(hills, WATER_LEVEL-6.0 + fine*1.3, river_carve*.95)
	# Real, walkable lake bed, not an opaque lake painted over flat terrain.
	var lake_d := lake_ratio(x,z)
	if lake_d < 1.27:
		var bed := WATER_LEVEL-2.0 - maxf(0.0,1.0-lake_d)*29.0 + fine*2.0
		var lake_blend := 1.0-smoothstep(.92,1.27,lake_d)
		hills = lerpf(hills,bed,lake_blend)
	return hills

func surface_color(x: float, z: float) -> Color:
	var h := terrain_height(x,z)
	var d := lake_ratio(x,z)
	if d < .99 and h < WATER_LEVEL:
		return Color("2f839c")
	if absf(z-river_z(x)) < 14.0 and h < WATER_LEVEL + 1.0:
		return Color("589fb4")
	if d < 1.20 and h < WATER_LEVEL+8.0:
		return Color("c9be8a")
	if h > 145.0:
		return Color("a3a8a0")
	if h > 95.0:
		return Color("8b9a84")
	if h > 50.0:
		return Color("64836d")
	if near_story_spine(x,z):
		return Color("85ad72")
	var lush := broad.get_noise_2d(x+900.0,z-2200.0)
	return Color("6b9875") if lush > .04 else Color("83ad78")

func near_story_spine(x:float,z:float) -> bool:
	return z > -120.0 and z < 700.0 and absf(x)<185.0

func biome(x: float,z: float) -> String:
	if lake_ratio(x,z)<1.20:
		return "Hồ Ánh Sao"
	if x < -950.0 or z > 1280.0:
		return "Rừng thông cao nguyên"
	if x < -480.0 and z > 630.0:
		return "Thung lũng hoa"
	if x < -750.0 and z < -650.0:
		return "Rừng cổ thụ"
	if x > 1000.0 and z > 200.0:
		return "Đồi cỏ phía đông"
	if z > 290.0 and z < 670.0 and absf(x)<210.0:
		return "Làng A"
	return "Rừng xanh A1"

func can_plant_tree(x:float,z:float) -> bool:
	if absf(x)>HALF-25.0 or absf(z)>HALF-25.0:
		return false
	if lake_ratio(x,z)<1.27 or absf(z-river_z(x))<37.0:
		return false
	if near_story_spine(x,z) and absf(x-23.0*sin(z*.013))<30.0:
		return false
	if (Vector2(x,z)-HOUSE).length()<54.0 or (Vector2(x,z)-VILLAGE).length()<235.0:
		return false
	return terrain_height(x,z)<170.0

func deterministic(key:int, n:int) -> float:
	var f := sin(float(key)*18.27819+float(n)*113.0673)*43758.5453
	return f-floorf(f)

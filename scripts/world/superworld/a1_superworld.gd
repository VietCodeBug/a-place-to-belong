extends Node3D

const FLOW = preload("res://scripts/story/map_flow.gd")
const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
const STREAM = preload("res://scripts/world/superworld/terrain_chunks.gd")
const LAKE = preload("res://scripts/world/superworld/lake.gd")
var field: FIELD
var streamer: STREAM
var lake: LAKE
var player: CharacterBody3D
var weather: Node
var wetness := 0.0
var swim_hint: Label
var trail_material: ShaderMaterial
var ridge_camera: Camera3D
var ridge_environment: Environment

func start(actor: CharacterBody3D, climate: Node, initial_season: int) -> void:
	player = actor
	weather = climate
	streamer = STREAM.new()
	streamer.name = "StreamedTerrain"
	add_child(streamer)
	streamer.setup(field,player)
	lake = LAKE.new()
	lake.name = "ExplorableLake"
	add_child(lake)
	lake.setup(field)
	player.superworld = self
	build_trails()
	set_season(initial_season)
	var overlay := CanvasLayer.new()
	add_child(overlay)
	swim_hint = Label.new()
	swim_hint.position = Vector2(29,152)
	swim_hint.add_theme_font_size_override("font_size",16)
	swim_hint.add_theme_color_override("font_outline_color",Color("153C42"))
	swim_hint.add_theme_constant_override("outline_size",5)
	overlay.add_child(swim_hint)

func set_season(index: int) -> void:
	if streamer != null:
		streamer.set_season(index)
		lake.set_season(index)
		trail_material.set_shader_parameter("village_snow",.9 if index==3 else 0.0)

func terrain_height(x: float,z: float) -> float:
	return field.height(Vector2(x,z))

func _process(_delta: float) -> void:
	var camera := get_viewport().get_camera_3d()
	if camera != null:
		lake.update_view(camera)
		update_ridge_view(camera)
	swim_hint.visible = not player.blocked and lake.contains(player.position)
	if swim_hint.visible:
		lake.depth = maxf(0.0,FIELD.WATER-player.position.y-1.2)
		swim_hint.text = "%s %.1f m   ·   SPACE %s   ·   CTRL %s" % [
			FLOW.text("Depth","Độ sâu"),lake.depth,
			FLOW.text("surface","nổi"),FLOW.text("dive","lặn")]
	if not is_equal_approx(wetness,weather.wetness):
		wetness = weather.wetness
		streamer.material.set_shader_parameter("wetness",wetness)
		trail_material.set_shader_parameter("wetness",wetness)

func update_ridge_view(camera: Camera3D) -> void:
	var eye := Vector2(camera.global_position.x,camera.global_position.z)
	var at_ridge := eye.distance_squared_to(FIELD.OVERLOOK)<76.0*76.0
	if at_ridge and not lake.underwater:
		if ridge_camera != camera or camera.environment != ridge_environment:
			clear_ridge_view()
			ridge_camera = camera
			ridge_environment = camera.get_world_3d().environment.duplicate() as Environment
			camera.environment = ridge_environment
		ridge_environment.fog_density = lerpf(.00055,.004,weather.weather_value.y)
	elif ridge_camera != null:
		clear_ridge_view()

func clear_ridge_view() -> void:
	if is_instance_valid(ridge_camera) and ridge_camera.environment==ridge_environment:
		ridge_camera.environment = null
	ridge_camera = null

func prepare_at(p: Vector2) -> void:
	streamer.prepare_at(p)

func build_trails() -> void:
	var builder := SurfaceTool.new()
	builder.begin(Mesh.PRIMITIVE_TRIANGLES)
	for path in FIELD.TRAILS:
		var sections: Array[PackedVector3Array] = []
		for i in range(path.size()-1):
			var a: Vector2 = path[i]
			var b: Vector2 = path[i+1]
			var prev: Vector2 = path[maxi(0,i-1)]
			var next: Vector2 = path[mini(path.size()-1,i+2)]
			var steps := ceili(a.distance_to(b)/.92)
			for j in range(steps+1):
				var t := float(j)/steps
				var p := a.cubic_interpolate(b,prev,next,t)
				var previous := a.cubic_interpolate(b,prev,next,t-.004)
				var right := (p-previous).normalized().orthogonal()
				var section := PackedVector3Array()
				for lateral in [-1.9,-1.0,0.0,1.0,1.9]:
					var edge: Vector2 = p+lateral*right
					section.append(Vector3(edge.x,field.height(edge)+.075,edge.y))
				sections.append(section)
		for i in range(sections.size()-1):
			for col in 4:
				for vertex in [[i,col],[i+1,col],[i,col+1],[i,col+1],[i+1,col],[i+1,col+1]]:
					var lateral: float = [-1.9,-1.0,0.0,1.0,1.9][vertex[1]]
					builder.set_uv(Vector2(lateral,1.4))
					builder.add_vertex(sections[vertex[0]][vertex[1]])
	builder.generate_normals()
	var trails := MeshInstance3D.new()
	trails.name = "LakeApproaches"
	trails.mesh = builder.commit()
	trail_material = ShaderMaterial.new()
	trail_material.shader = preload("res://shaders/forest_path.gdshader")
	trail_material.set_shader_parameter("continuous_trail",true)
	trail_material.set_shader_parameter("potholes",ForestLandscape.road_potholes())
	trails.material_override = trail_material
	trails.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(trails)

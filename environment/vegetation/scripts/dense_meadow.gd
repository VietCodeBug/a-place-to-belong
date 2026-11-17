@tool
extends Node3D
const M=preload("res://environment/vegetation/scripts/meadow_meshes.gd")
const D=preload("res://scripts/world/forest_floor_design.gd")
@export var settings: MeadowSettings=preload("res://environment/vegetation/presets/high.tres")
@export var area:=Rect2(-23.6,-23.6,47.2,47.2)
@export var isolated_test:=false
@export var valid_area:=Rect2(-24,-24,48,48)
@export var exclusion_circles:=PackedVector3Array()
@export var density_mask: Texture2D
@export var mask_rect:=Rect2(-24,-24,48,48)
var mask_image: Image
var height_sampler: Callable
var normal_sampler: Callable
@export_tool_button("Generate / regenerate") var generate_action=regenerate
@export_tool_button("Clear generated grass") var clear_action=clear_generated
var counts: Dictionary={}
var material_pool: Array[ShaderMaterial]=[]
var meshes: Dictionary={}
var batches: Dictionary={}
var clock:=0.
var generation_ms:=0
func _ready() -> void:
	if not Engine.is_editor_hint():
		for arg in OS.get_cmdline_user_args():
			if arg.begins_with("--grass-quality="):
				var quality:=arg.trim_prefix("--grass-quality=")
				if quality in ["low","medium","high","ultra"]: settings=load("res://environment/vegetation/presets/"+quality+".tres")
		regenerate()
func clear_generated() -> void:
	for child in get_children():
		if child.get_meta("dense_meadow",false):
			remove_child(child);child.queue_free()
	counts.clear();batches.clear();material_pool.clear();meshes.clear()
func regenerate() -> void:
	clear_generated()
	if settings==null: return
	var start:=Time.get_ticks_msec()
	mask_image=density_mask.get_image() if density_mask!=null else null
	if mask_image!=null and mask_image.is_compressed():mask_image.decompress()
	var rng:=RandomNumberGenerator.new();rng.seed=settings.seed
	for layer in range(5):
		for variant in range(2 if layer<3 else 1):
			for lod in range(2 if layer<3 else 1):
				var key:="%d:%d:%d"%[layer,variant,lod]
				meshes[key]=M.grass(layer,variant,lod==1) if layer<3 else M.flower(layer==4)
				var mat:=ShaderMaterial.new();mat.shader=preload("res://environment/vegetation/shaders/dense_meadow.gdshader")
				mat.set_shader_parameter("lod_level",lod if layer<3 else -1)
				mat.set_shader_parameter("lod_begin",settings.lod_begin)
				mat.set_shader_parameter("lod_end",settings.lod_end)
				mat.set_shader_parameter("wind_direction",settings.wind_direction)
				mat.set_shader_parameter("wind_strength",settings.wind_strength)
				mat.set_shader_parameter("wind_speed",settings.wind_speed)
				if layer>=3:
					mat.set_shader_parameter("flower",true)
					mat.set_shader_parameter("root_color",Color("668949"))
					mat.set_shader_parameter("tip_color",Color("EEEBCF") if layer==3 else Color("B777C9"))
				material_pool.append(mat)
	var densities: Array[float]=[settings.carpet_density,settings.tuft_density,settings.accent_density,settings.flower_density*.7,settings.flower_density*.3]
	for layer in range(5):
		var density: float=densities[layer]
		if density<=0.: continue
		var step:=1./sqrt(density)
		for ix in range(ceili(area.size.x/step)):
			for iz in range(ceili(area.size.y/step)):
				var p:=area.position+Vector2((ix+rng.randf())*step,(iz+rng.randf())*step)
				if not area.has_point(p) or not valid_area.has_point(p):continue
				if excluded(p):continue
				if not isolated_test and D.reserved(p,.20 if layer==0 else .42):continue
				var woods:=0. if isolated_test else D.forest(p)
				var bed:=.65 if isolated_test else D.bed(p)
				var patch:=.5+.25*sin(p.x*.30+sin(p.y*.24))+.25*cos(p.y*.33-p.x*.13)
				var acceptance: float=1.
				if layer==0:acceptance=lerpf(.92,.30,woods)*lerpf(.90,1.,patch)
				elif layer==1:acceptance=smoothstep(.28,.68,patch)*lerpf(.45,1.,bed)*(1.-woods*.4)
				elif layer==2:acceptance=bed*smoothstep(.55,.86,patch)*.8
				else:acceptance=(.14+bed*.86)*smoothstep(.30,.65,patch)*.8
				if rng.randf()>acceptance*mask_weight(p,layer):continue
				var h:=height(p)
				if not is_finite(h):continue
				var n:=normal(p)
				if not n.is_finite():continue
				if rad_to_deg(acos(clampf(n.y,-1.,1.)))>settings.max_slope_angle:continue
				var up:=Vector3.UP.lerp(n,settings.normal_alignment).normalized()
				var basis:=Basis(Quaternion(Vector3.UP,up))*Basis(Vector3.UP,rng.randf()*TAU)
				basis=basis.scaled(Vector3.ONE*rng.randf_range(.85,1.15))
				var transform:=Transform3D(basis,Vector3(p.x,h-.004,p.y))
				var variant:=rng.randi_range(0,1) if layer<3 else 0
				var tile:=Vector2i(floori(p.x/settings.chunk_size),floori(p.y/settings.chunk_size))
				var key:="%d:%d:%s"%[layer,variant,str(tile)]
				if not batches.has(key):batches[key]={"layer":layer,"variant":variant,"transforms":[],"seeds":[]}
				batches[key].transforms.append(transform);batches[key].seeds.append(rng.randf())
				var label: String=["grass_carpet","grass_main","grass_accent","flowers_white","flowers_purple"][layer]
				counts[label]=counts.get(label,0)+1
	flush()
	generation_ms=Time.get_ticks_msec()-start
	print("Dense meadow: ",counts," generation_ms=",generation_ms)
func height(p: Vector2) -> float:
	if height_sampler.is_valid(): return height_sampler.call(p)
	return .07*sin(p.x*.8)*cos(p.y*.6) if isolated_test else ForestLandscape.height_at(p.x,p.y)
func normal(p: Vector2) -> Vector3:
	if normal_sampler.is_valid(): return normal_sampler.call(p)
	var e:=.03
	return Vector3(height(p-Vector2(e,0))-height(p+Vector2(e,0)),2.*e,height(p-Vector2(0,e))-height(p+Vector2(0,e))).normalized()
func flush() -> void:
	for batch in batches.values():
		for lod in range(2 if batch.layer<3 else 1):
			var key:="%d:%d:%d"%[batch.layer,batch.variant,lod]
			var mm:=MultiMesh.new();mm.transform_format=MultiMesh.TRANSFORM_3D;mm.use_custom_data=true;mm.mesh=meshes[key];mm.instance_count=batch.transforms.size()
			for i in range(mm.instance_count):mm.set_instance_transform(i,batch.transforms[i]);mm.set_instance_custom_data(i,Color(1,1,1,batch.seeds[i]))
			var node:=MultiMeshInstance3D.new();node.multimesh=mm
			var material_index: int=batch.layer*4+batch.variant*2+lod if batch.layer<3 else 12+batch.layer-3
			node.material_override=material_pool[material_index]
			node.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
			node.extra_cull_margin=.35
			node.visibility_range_end=settings.lod_end+settings.chunk_size if lod==0 and batch.layer<3 else settings.render_distance
			if lod==1:node.visibility_range_begin=maxf(0.,settings.lod_begin-settings.chunk_size)
			node.set_meta("dense_meadow",true);add_child(node)
	batches.clear()
func _process(delta: float) -> void:
	clock+=delta
	for mat in material_pool:
		if not mat.get_meta("external_wind",false):mat.set_shader_parameter("wind_clock",clock)

func excluded(p: Vector2) -> bool:
	for circle in exclusion_circles:
		if p.distance_to(Vector2(circle.x,circle.y))<circle.z:return true
	if not isolated_test:
		for center in [Vector2(-11,5),Vector2(11,5),Vector2(-8,15),Vector2(10,12),Vector2(-15,-4),Vector2(16,-9)]:
			if p.distance_to(center+Vector2(.8,.6))<.55:return true
		if p.distance_to(Vector2(8,12))<.55 or p.distance_to(Vector2(-10,0))<.65:return true
	return false

func mask_weight(p: Vector2,layer: int) -> float:
	if mask_image==null:return 1.
	if mask_rect.size.x<=0. or mask_rect.size.y<=0. or not mask_rect.has_point(p):return 0.
	var uv: Vector2=(p-mask_rect.position)/mask_rect.size
	var x:=clampi(floori(uv.x*mask_image.get_width()),0,mask_image.get_width()-1)
	var y:=clampi(floori(uv.y*mask_image.get_height()),0,mask_image.get_height()-1)
	var color:=mask_image.get_pixel(x,y)
	return [color.r,color.g,color.b,color.a,color.a][layer]

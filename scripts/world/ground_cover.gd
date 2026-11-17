extends Node3D
## Curated floor: short carpet, longer meadow pockets, sedges, ferns and wind-gathered litter.
const D = preload("res://scripts/world/forest_floor_design.gd")
const A = preload("res://scripts/world/field_assets.gd")
const ASSETS := ["short_blades","soft_fan","meadow_sweep","tall_sedge","fern_rosette","fallen_leaf","twig"]
var rng := RandomNumberGenerator.new()
var field := FastNoiseLite.new()
var meshes: Dictionary = {}
var materials: Dictionary = {}
var batches: Dictionary = {}
var instance_counts: Dictionary = {}
func _ready() -> void:
	rng.seed=50317
	field.seed=50317
	field.frequency=0.19
	field.fractal_type=FastNoiseLite.FRACTAL_NONE
	for asset in ASSETS:
		var source: Node3D=load("res://assets/vegetation/forest_floor/"+asset+".glb").instantiate()
		meshes[asset]=extract_mesh(source,Transform3D.IDENTITY)
		source.free()
		var mat:=ShaderMaterial.new()
		mat.shader=preload("res://shaders/forest_grass.gdshader")
		if asset=="fern_rosette":
			mat.set_shader_parameter("root_color",Color("556843"))
			mat.set_shader_parameter("tip_color",Color("84975D"))
			mat.set_shader_parameter("wind_strength",0.006)
		elif asset=="fallen_leaf":
			mat.set_shader_parameter("root_color",Color("8B734E"))
			mat.set_shader_parameter("tip_color",Color("A08A62"))
			mat.set_shader_parameter("wind_strength",0.0)
		elif asset=="twig":
			mat.set_shader_parameter("root_color",Color("61503D"))
			mat.set_shader_parameter("tip_color",Color("756047"))
			mat.set_shader_parameter("wind_strength",0.0)
		elif asset=="tall_sedge":
			mat.set_shader_parameter("tip_color",Color("A1A165"))
		materials[asset]=mat
	carpet()
	accents()
	litter()
	flush()

func extract_mesh(node: Node, inherited: Transform3D) -> ArrayMesh:
	var transform:=inherited
	if node is Node3D: transform*=node.transform
	if node is MeshInstance3D:
		var arrays: Array=node.mesh.surface_get_arrays(0)
		var positions: PackedVector3Array=arrays[Mesh.ARRAY_VERTEX]
		var normals: PackedVector3Array=arrays[Mesh.ARRAY_NORMAL]
		for i in range(positions.size()):
			positions[i]=transform*positions[i]
			normals[i]=(transform.basis*normals[i]).normalized()
		arrays[Mesh.ARRAY_VERTEX]=positions
		arrays[Mesh.ARRAY_NORMAL]=normals
		var result:=ArrayMesh.new()
		result.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
		return result
	for child in node.get_children():
		var result:=extract_mesh(child,transform)
		if result!=null: return result
	return null

func plant(asset: String,p: Vector2,scale_value: float,yaw: float, offset := -0.012) -> void:
	var tile:=Vector2i(floori(p.x/8.0),floori(p.y/8.0))
	var key:=asset+":"+str(tile)
	if not batches.has(key): batches[key]={"asset":asset,"transforms":[],"tints":[]}
	var basis:=Basis(Vector3.UP,yaw).scaled(Vector3.ONE*scale_value)
	var position:=Vector3(p.x,ForestLandscape.height_at(p.x,p.y)+offset,p.y)
	batches[key].transforms.append(Transform3D(basis,position))
	var tone:=rng.randf_range(0.9,1.08)
	batches[key].tints.append(Color(tone,tone*rng.randf_range(.97,1.03),tone*rng.randf_range(.92,1.02),rng.randf()))
	instance_counts[asset]=instance_counts.get(asset,0)+1

func carpet() -> void:
	# Jittered candidates accepted through habitat fields: continuous short grass and resting lawns.
	for x in range(-99,100):
		for z in range(-99,100):
			var p:=Vector2(x*0.24+rng.randf_range(-.1,.1),z*0.24+rng.randf_range(-.1,.1))
			if D.reserved(p,0.05): continue
			var woods:=D.forest(p)
			var bed:=D.bed(p)
			var meadow:=clampf(field.get_noise_2dv(p)*.8+.5,0,1)
			var density:=clampf(lerpf(.05,.75,smoothstep(.3,.75,meadow))+bed*.35-woods*.35,.04,.95)
			# Trim the entrance lawn without emptying every foreground area.
			if p.y<8.0 and absf(p.x)<8.4: density*=.3
			if rng.randf()>density: continue
			var asset: String="short_blades"
			if bed>.3 and meadow>.45 and rng.randf()<.5: asset="soft_fan"
			if bed>.6 and rng.randf()<.2: asset="meadow_sweep"
			plant(asset,p,rng.randf_range(.4,.82) if asset=="short_blades" else rng.randf_range(.75,1.2),rng.randf()*TAU)

func accents() -> void:
	for patch in D.BEDS:
		var center:=Vector2(patch.x,patch.y)
		for i in range(64):
			var a:=rng.randf()*TAU
			var p:=center+Vector2(cos(a),sin(a))*(.4+sqrt(rng.randf())*1.5)
			if not D.reserved(p,.3): plant("meadow_sweep",p,rng.randf_range(.75,1.15),a)
		for i in range(7):
			var p:=center+Vector2(rng.randf_range(-.85,.85),rng.randf_range(-.65,.65))
			if not D.reserved(p,.4): plant("tall_sedge",p,rng.randf_range(.7,1.15),rng.randf()*TAU)
	for grove in D.GROVES:
		for i in range(9):
			var a:=rng.randf()*TAU
			var p:=Vector2(grove.x,grove.y)+Vector2(cos(a),sin(a))*rng.randf_range(1.6,4.8)
			if absf(p.x)<23.6 and absf(p.y)<23.6 and not D.reserved(p,.3): plant("fern_rosette",p,rng.randf_range(.75,1.25),a)
	# Small stones embedded in the existing path; visual-only, no gameplay obstacles.
	for i in range(18):
		var p:=ForestLandscape.road_point(rng.randf())
		p.x+=rng.randf_range(-.8,.8)*ClearingLayout.path_half_width(p.y)
		var rock:=A.model("nature","rock_smallC",rng.randf_range(.055,.095))
		A.recolor(rock,"675F4B")
		add_child(rock)
		rock.scale.x*=1.5
		rock.position=Vector3(p.x,ForestLandscape.height_at(p.x,p.y)-.055,p.y)
		rock.rotation.y=rng.randf()*TAU

func litter() -> void:
	var pockets: Array[Vector2]=[Vector2(-12,4),Vector2(18,-9),Vector2(-5,-22),Vector2(-15,10),Vector2(12,-16),Vector2(8,13),Vector2(-7,17)]
	for i in range(3):
		var edge:=ForestLandscape.road_point(.2+i*.3)
		edge.x+=(-1.0 if i%2==0 else 1.0)*(ClearingLayout.path_half_width(edge.y)+.3)
		pockets.append(edge)
	for pocket in range(pockets.size()):
		var center:=pockets[pocket]
		for i in range(40 if pocket<7 else 18):
			var a:=rng.randf()*TAU
			var p:=center+Vector2(cos(a),sin(a))*sqrt(rng.randf())*2.4
			if absf(p.x)>23.6 or absf(p.y)>23.6: continue
			if absf(p.x)<8.4 and p.y<5.2 and p.y>-12.4: continue
			plant("fallen_leaf",p,rng.randf_range(.6,1.3),a,.032 if ForestLandscape.on_road(p) else .008)
	for i in range(65):
		var p:=Vector2(rng.randf_range(-23,23),rng.randf_range(-22,22))
		if D.forest(p)>.3 and not D.reserved(p,.3): plant("twig",p,rng.randf_range(.5,1.3),rng.randf()*TAU,.01)

func flush() -> void:
	for item in batches.values():
		var mm:=MultiMesh.new()
		mm.transform_format=MultiMesh.TRANSFORM_3D
		mm.use_custom_data=true
		mm.mesh=meshes[item.asset]
		mm.instance_count=item.transforms.size()
		for i in range(mm.instance_count):
			mm.set_instance_transform(i,item.transforms[i])
			mm.set_instance_custom_data(i,item.tints[i])
		var node:=MultiMeshInstance3D.new()
		node.name=item.asset.to_pascal_case()
		node.extra_cull_margin=.06
		node.multimesh=mm
		node.material_override=materials[item.asset]
		if item.asset!="fern_rosette" and item.asset!="tall_sedge": node.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(node)
	batches.clear()
	print("Forest floor instances: ",instance_counts)

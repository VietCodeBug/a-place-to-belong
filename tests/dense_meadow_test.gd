extends SceneTree
var failures:=0
func _initialize() -> void:call_deferred("run")
func check(value: bool,label: String) -> void:
	print("PASS: " if value else "FAIL: ",label)
	if not value:failures+=1
func fingerprint(node: Node) -> int:
	var value:=0
	for child in node.get_children():
		if child is MultiMeshInstance3D:
			value=hash([value,child.multimesh.instance_count,child.multimesh.get_instance_transform(0)])
	return value
func run() -> void:
	var generator=load("res://environment/vegetation/scripts/dense_meadow.gd").new()
	generator.isolated_test=true;generator.area=Rect2(-2.5,-2.5,5,5)
	root.add_child(generator)
	await process_frame
	check(generator.counts.get("grass_carpet",0)>370,"5x5 carpet has at least 14.8 accepted clumps per m2")
	check(generator.counts.get("grass_main",0)>0,"separate main tuft layer present")
	check(generator.counts.get("grass_accent",0)>0,"separate sparse accent layer present")
	check(generator.counts.get("flowers_white",0)>0 and generator.counts.get("flowers_purple",0)>0,"white and purple flowers present")
	var old_fingerprint:=fingerprint(generator)
	var old_counts: Dictionary=generator.counts.duplicate();var old_nodes: int=generator.get_child_count()
	generator.regenerate()
	await process_frame
	check(generator.counts==old_counts and generator.get_child_count()==old_nodes and fingerprint(generator)==old_fingerprint,"same seed regenerates deterministically without accumulating nodes")
	var valid:=true
	for child in generator.get_children():
		if child is MultiMeshInstance3D:
			for i in range(child.multimesh.instance_count):
				var p: Vector3=child.multimesh.get_instance_transform(i).origin
				if absf(p.y-generator.height(Vector2(p.x,p.z))+.004)>.001:valid=false
	check(valid,"all roots sample the actual non-flat test surface")
	var clock: float=generator.clock;generator._process(.25)
	check(generator.clock>clock,"wind advances without regenerating terrain")
	var mesh=load("res://environment/vegetation/scripts/meadow_meshes.gd")
	check(mesh.grass(0,0,true).get_faces().size()<mesh.grass(0,0).get_faces().size()/10,"carpet distance mesh removes over 90 percent of triangles")
	generator.settings=generator.settings.duplicate();generator.settings.carpet_density=5.;generator.regenerate()
	check(generator.counts.grass_carpet<old_counts.grass_carpet/2,"Inspector density changes accepted population")
	generator.height_sampler=func(p: Vector2)->float:return p.x
	generator.normal_sampler=func(_p: Vector2)->Vector3:return Vector3(-1,1,0).normalized()
	generator.regenerate();check(generator.counts.is_empty(),"45 degree slopes rejected by 35 degree limit")
	generator.normal_sampler=Callable();generator.height_sampler=Callable();generator.exclusion_circles=PackedVector3Array([Vector3(0,0,20)])
	generator.regenerate();check(generator.counts.is_empty(),"custom exclusion masks reject placements")
	generator.exclusion_circles=PackedVector3Array()
	var image:=Image.create(2,2,false,Image.FORMAT_RGBA8);image.fill(Color(0,0,0,0))
	generator.density_mask=ImageTexture.create_from_image(image)
	generator.regenerate();check(generator.counts.is_empty(),"painted zero RGBA mask rejects all layers")
	generator.clear_generated();check(generator.get_child_count()==0,"Clear removes all generated batches")
	for quality in ["low","medium","high","ultra"]:
		var preset=load("res://environment/vegetation/presets/"+quality+".tres")
		check(preset.carpet_density>0. and preset.lod_begin<preset.lod_end and preset.lod_end<preset.render_distance,"valid "+quality+" density/LOD preset")
	generator.free();await process_frame
	print("DENSE MEADOW COMPLETE; failures=",failures);quit(1 if failures else 0)

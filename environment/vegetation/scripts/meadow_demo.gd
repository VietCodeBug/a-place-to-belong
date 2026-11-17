extends Node3D
func _ready() -> void:
	preload("res://scripts/lighting/lighting_rig.gd").apply(self,load("res://assets/lighting/golden_hour.tres"))
	get_node("Sun").rotation_degrees=Vector3(-36,-52,0)
	var meadow=get_node("DenseMeadow")
	var st:=SurfaceTool.new();st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for x in range(-14,14):
		for z in range(-14,14):
			var points: Array[Vector2]=[Vector2(x,z)*.25,Vector2(x+1,z)*.25,Vector2(x,z+1)*.25,Vector2(x+1,z+1)*.25]
			for i in [0,2,1,1,2,3]:
				var p:=points[i];st.add_vertex(Vector3(p.x,meadow.height(p)-.005,p.y))
	st.generate_normals()
	var floor_mesh:=MeshInstance3D.new();floor_mesh.mesh=st.commit()
	var base:=StandardMaterial3D.new();base.albedo_color=Color("648241");base.cull_mode=BaseMaterial3D.CULL_DISABLED;floor_mesh.material_override=base;floor_mesh.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF;add_child(floor_mesh)
	var camera:=Camera3D.new();add_child(camera);camera.fov=42
	camera.position=Vector3(.62,.54,.57).normalized()*13.;camera.look_at(Vector3.ZERO)
	for i in range(6):await get_tree().process_frame
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("/tmp/dense-demo-gameplay.png")
	camera.position=Vector3(3,1.6,4.2);camera.look_at(Vector3(0,.08,0))
	for i in range(4):await get_tree().process_frame
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("/tmp/dense-demo-close.png")
	get_tree().quit()

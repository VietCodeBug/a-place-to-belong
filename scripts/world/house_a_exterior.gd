extends Node3D
## This cottage owns its material overrides. Village cottages can share the original GLB.

const SURFACE = preload("res://shaders/house_a_surface.gdshader")
const STARTING_WEAR := .72

var wear := STARTING_WEAR
var finishes: Array[ShaderMaterial] = []

func setup(shell: Node3D) -> void:
	for instance: MeshInstance3D in shell.find_children("*","MeshInstance3D",true,false):
		for index in instance.mesh.get_surface_count():
			var source := instance.get_active_material(index) as StandardMaterial3D
			if source==null:
				continue
			var label := source.resource_name.to_lower()
			if label.begins_with("honey glass"):
				var glass := source.duplicate() as StandardMaterial3D
				glass.emission_energy_multiplier = .32
				glass.albedo_color = source.albedo_color.lerp(Color("A69870"),.45)
				instance.set_surface_override_material(index,glass)
				continue
			var kind := finish_for(label)
			if kind<0:
				continue
			var material := ShaderMaterial.new()
			material.shader = SURFACE
			material.set_shader_parameter("tint",source.albedo_color)
			material.set_shader_parameter("finish",kind)
			material.set_shader_parameter("vertical",kind in [0,1,4,6])
			material.set_shader_parameter("exterior",true)
			material.set_shader_parameter("wear",wear)
			instance.set_surface_override_material(index,material)
			finishes.append(material)

func finish_for(label: String) -> int:
	if label.begins_with("warm limewash"):
		return 1
	if label.begins_with("weathered sage paint"):
		return 4
	if label.begins_with("fired clay") or label.begins_with("warm slate"):
		return 5
	if label.begins_with("blackened iron"):
		return 6
	if label.contains("oak"):
		return 0
	return -1

func set_wear(amount: float) -> void:
	wear = clampf(amount,0.0,1.0)
	for material in finishes:
		material.set_shader_parameter("wear",wear)

func set_season(index: int) -> void:
	for material in finishes:
		material.set_shader_parameter("snow",.91 if index==3 else .0)

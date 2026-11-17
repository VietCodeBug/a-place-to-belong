@tool
class_name MeadowSettings
extends Resource
@export_range(0,32,.5) var carpet_density:=18.0
@export_range(0,10,.25) var tuft_density:=4.5
@export_range(0,3,.1) var accent_density:=.6
@export_range(0,3,.1) var flower_density:=.65
@export_range(8,100,1) var render_distance:=60.0
@export_range(4,50,1) var lod_begin:=14.0
@export_range(5,65,1) var lod_end:=24.0
@export_range(4,16,1) var chunk_size:=8.0
@export_range(0,60,1) var max_slope_angle:=35.0
@export_range(0,1,.05) var normal_alignment:=.65
@export_range(0,.4,.005) var wind_strength:=.065
@export_range(0,4,.1) var wind_speed:=1.3
@export var wind_direction:=Vector2(.85,.52)
@export var seed:=91061

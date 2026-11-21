extends RefCounted
## Small procedural one-shots, driven by actual steps and work beats.
var clips: Dictionary = {}

func play(kind: String, point: Vector3, parent: Node3D) -> void:
	if not clips.has(kind):
		clips[kind] = synthesize(kind)
	var sound := AudioStreamPlayer3D.new()
	sound.stream = clips[kind]
	sound.max_distance = 13.0
	sound.unit_size = 3.1
	sound.volume_db = -10.0 if kind=="chop" else -17.0
	sound.position = parent.to_local(point)
	parent.add_child(sound)
	sound.finished.connect(sound.queue_free)
	sound.play()

func synthesize(kind: String) -> AudioStreamWAV:
	var config: Array = {"wood":[.16,95,.27],"earth":[.15,62,.47],"door":[.31,118,.24],
		"chop":[.22,75,.64],"tap":[.11,214,.21],"water":[.47,380,.81],"wind":[1.75,49,.43]}.get(kind,[.14,96,.3])
	var rng := RandomNumberGenerator.new()
	rng.seed = kind.hash()
	var rate := 16000
	var samples := PackedByteArray()
	samples.resize(int(config[0]*rate)*2)
	var low := 0.0
	for i in samples.size()/2:
		var t := float(i)/rate
		var ratio: float = t/config[0]
		low = lerpf(low,rng.randf_range(-1,1),.18 if kind!="water" else .64)
		var fade := minf(1.0,ratio*45.0)*pow(1.0-ratio,2.3)
		var ring := sin(t*TAU*float(config[1])*(1.0-ratio*.32))
		var sample: float = (ring*(1.0-config[2])+low*config[2])*fade*.57
		samples.encode_s16(i*2,int(sample*32767.0))
	var clip := AudioStreamWAV.new()
	clip.format = AudioStreamWAV.FORMAT_16_BITS
	clip.mix_rate = rate
	clip.data = samples
	return clip

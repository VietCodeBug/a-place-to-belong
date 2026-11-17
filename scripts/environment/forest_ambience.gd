class_name ForestAmbience
extends Node
## Lightweight procedural CC0 woodland soundscape appropriate to time-of-day and weather:
## soft breeze through pine needles, gentle morning/daytime birdsong, and cozy evening crickets.

const MIX_RATE := 22050

var master_volume := 0.85
var muted := false
var breeze_player: AudioStreamPlayer
var birds_player: AudioStreamPlayer
var night_player: AudioStreamPlayer
var audio_enabled := false

func _ready() -> void:
	audio_enabled = DisplayServer.get_name() != "headless" and not OS.get_cmdline_args().has("Dummy")
	breeze_player = make_player("WoodlandBreeze", build_breeze_stream(5.0))
	birds_player = make_player("DaytimeBirds", build_birds_stream(8.0))
	night_player = make_player("NightCrickets", build_crickets_stream(6.0))

func make_player(p_name: String, stream: AudioStreamWAV) -> AudioStreamPlayer:
	var p := AudioStreamPlayer.new()
	p.name = p_name
	p.stream = stream
	p.volume_db = -70.0
	add_child(p)
	return p

func update_mix(daylight: float, rain_amount: float, wind_strength: float) -> void:
	if not audio_enabled:
		return
	var gain := 0.0 if muted else clampf(master_volume, 0.0, 1.0)
	var breeze_level := clampf(0.28 + wind_strength * 1.6, 0.2, 0.85) * gain
	var bird_level := smoothstep(0.22, 0.58, daylight) * (1.0 - smoothstep(0.10, 0.42, rain_amount)) * 0.52 * gain
	var cricket_level := (1.0 - smoothstep(0.08, 0.40, daylight)) * (1.0 - smoothstep(0.20, 0.55, rain_amount)) * 0.48 * gain

	apply_player(breeze_player, breeze_level, -34.0, -21.0)
	apply_player(birds_player, bird_level, -38.0, -20.0)
	apply_player(night_player, cricket_level, -40.0, -22.0)

func apply_player(player: AudioStreamPlayer, factor: float, min_db: float, max_db: float) -> void:
	if player == null:
		return
	if factor <= 0.015:
		player.volume_db = -72.0
		if player.playing:
			player.stop()
	else:
		player.volume_db = lerpf(min_db, max_db, sqrt(clampf(factor, 0.0, 1.0)))
		if not player.playing:
			player.play()

func build_breeze_stream(seconds: float) -> AudioStreamWAV:
	var samples := int(MIX_RATE * seconds)
	var data := PackedByteArray()
	data.resize(samples * 2)
	var rng := RandomNumberGenerator.new()
	rng.seed = 7712
	var lp := 0.0
	var lp2 := 0.0
	for i in range(samples):
		var t := float(i) / float(samples)
		var env := 0.62 + 0.38 * sin(t * TAU) * cos(t * TAU * 2.0)
		var white := rng.randf_range(-1.0, 1.0)
		lp = lp * 0.965 + white * 0.035
		lp2 = lp2 * 0.93 + lp * 0.07
		var fade_seam := 1.0
		if i < 600:
			fade_seam = float(i) / 600.0
		elif i > samples - 600:
			fade_seam = float(samples - i) / 600.0
		var v := clampi(int(lp2 * env * fade_seam * 11500.0), -32767, 32767)
		data.encode_s16(i * 2, v)
	return wrap_wav(data, samples)

func build_birds_stream(seconds: float) -> AudioStreamWAV:
	var samples := int(MIX_RATE * seconds)
	var data := PackedByteArray()
	data.resize(samples * 2)
	# Gentle, sparse woodland flute-like chirps at calm intervals
	var notes := [
		[0.75, 0.13, 1760.0, 2120.0],
		[0.93, 0.16, 2080.0, 1680.0],
		[2.85, 0.11, 2340.0, 2620.0],
		[3.01, 0.12, 2480.0, 2180.0],
		[3.18, 0.18, 1960.0, 1720.0],
		[5.60, 0.14, 1640.0, 1980.0],
		[5.80, 0.20, 1980.0, 1560.0],
	]
	var phase := 0.0
	for i in range(samples):
		var time := float(i) / float(MIX_RATE)
		var sample := 0.0
		for n in notes:
			var start: float = n[0]
			var dur: float = n[1]
			if time >= start and time < start + dur:
				var u := (time - start) / dur
				var freq := lerpf(float(n[2]), float(n[3]), smoothstep(0.0, 1.0, u))
				phase += TAU * freq / float(MIX_RATE)
				var env := sin(u * PI) * exp(-u * 1.4)
				sample += (sin(phase) * 0.82 + sin(phase * 2.0) * 0.18) * env * 0.24
		var v := clampi(int(sample * 24000.0), -32767, 32767)
		data.encode_s16(i * 2, v)
	return wrap_wav(data, samples)

func build_crickets_stream(seconds: float) -> AudioStreamWAV:
	var samples := int(MIX_RATE * seconds)
	var data := PackedByteArray()
	data.resize(samples * 2)
	for i in range(samples):
		var time := float(i) / float(MIX_RATE)
		var pulse_a := pow(maxf(0.0, sin(time * TAU * 2.0)), 6.0) * (0.5 + 0.5 * sin(time * TAU * 26.0))
		var pulse_b := pow(maxf(0.0, sin((time + 0.37) * TAU * 1.5)), 8.0) * (0.5 + 0.5 * sin(time * TAU * 29.0))
		var carrier_a := sin(time * TAU * 3820.0) * pulse_a * 0.09
		var carrier_b := sin(time * TAU * 4140.0) * pulse_b * 0.07
		var seam := 1.0
		if i < 500:
			seam = float(i) / 500.0
		elif i > samples - 500:
			seam = float(samples - i) / 500.0
		var v := clampi(int((carrier_a + carrier_b) * seam * 22000.0), -32767, 32767)
		data.encode_s16(i * 2, v)
	return wrap_wav(data, samples)

func wrap_wav(data: PackedByteArray, samples: int) -> AudioStreamWAV:
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = MIX_RATE
	wav.stereo = false
	wav.loop_mode = AudioStreamWAV.LOOP_FORWARD
	wav.loop_begin = 0
	wav.loop_end = samples
	wav.data = data
	return wav

func _exit_tree() -> void:
	for p in [breeze_player, birds_player, night_player]:
		if is_instance_valid(p):
			p.stop()
			p.stream = null

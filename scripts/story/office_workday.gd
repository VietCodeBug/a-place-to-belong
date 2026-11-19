extends Node3D
## Spatial rhythm of the office. The printer's feed and motor use the same timer.

const KEYS := preload("res://assets/story/office_keys.wav")
const MOTOR := preload("res://assets/story/office_printer.wav")
const FEED_ORIGIN := Vector3(-0.680, 0.980, 0.436)

var keyboard: AudioStreamPlayer3D
var printer: AudioStreamPlayer3D
var air: AudioStreamPlayer3D
var murmur: AudioStreamPlayer3D
var chair: AudioStreamPlayer3D
var mouse: AudioStreamPlayer3D
var notification: AudioStreamPlayer3D
var reading_mail := false
var printout: MeshInstance3D
var local_typing := 1.0
var time := 0.0
var next_job := 2.18
var job_started := -1.0
var rng := RandomNumberGenerator.new()

func configure(own_desk: Vector3, bank: Vector3, copier: Vector3, sheet: MeshInstance3D) -> void:
	rng.seed = 1884
	printout = sheet
	printout.hide()
	var loop := looping(KEYS)
	keyboard = speaker("ADeskKeys", own_desk + Vector3(0, 0.85, 0.19), loop, -20.0, 0.75)
	var nearby := speaker("NearDeskKeys", own_desk + Vector3(2.99, 0.85, 0.14), loop, -24.5, 2.20)
	var across_room := speaker("FarDeskKeys", bank + Vector3(2.10, 0.85, 0.03), loop, -25.0, 2.65)
	printer = speaker("CopierMotor", copier + Vector3(-0.62, 1.04, 0.44), MOTOR, -20.0, 4.30)
	air = speaker("AirVent", Vector3(0.5, 2.6, -0.7), looping(preload("res://assets/story/office_vent.wav")), -28.0, 8.0)
	murmur = speaker("PrinterConversation", copier + Vector3(1.0, 1.32, 1.26), looping(preload("res://assets/story/office_murmur.wav")), -27.0, 3.1)
	chair = speaker("DeskChair", own_desk + Vector3(0.0, 0.26, 1.02), preload("res://assets/story/office_chair.wav"), -24.0, 1.8)
	mouse = speaker("DeskMouse", own_desk + Vector3(0.36, 0.83, 0.38), preload("res://assets/story/office_mouse.wav"), -27.0, 0.8)
	notification = speaker("MailNotification", own_desk + Vector3(0.10, 1.10, -0.19), preload("res://assets/story/office_mail.wav"), -18.0, 3.8)
	if DisplayServer.get_name() != "headless":
		keyboard.play(0.12)
		nearby.play(2.3)
		across_room.play(5.17)
		air.play()
		murmur.play(1.8)
	nearby.pitch_scale = 0.96
	across_room.pitch_scale = 0.92

func _process(delta: float) -> void:
	time += delta
	var emphasis := -3.3 if reading_mail else 0.0
	murmur.volume_db = move_toward(murmur.volume_db, -27.0 + emphasis, 12.0 * delta)
	air.volume_db = move_toward(air.volume_db, -28.0 + emphasis * 0.7, 10.0 * delta)
	keyboard.volume_db = move_toward(keyboard.volume_db, lerpf(-51.0, -17.5, local_typing), delta * 49.0)
	if time >= next_job:
		job_started = time
		next_job = time + rng.randf_range(8.7, 13.6)
		printout.hide()
		if DisplayServer.get_name() != "headless":
			printer.play()
	if job_started < 0.0:
		return
	var age := time - job_started
	if age < 0.34:
		return
	var feed := smoothstep(0.34, 1.43, age)
	printout.show()
	printout.position = FEED_ORIGIN + Vector3(0.0, 0.0, 0.126 * feed)
	if feed >= 1.0:
		job_started = -1.0

func play_mail_cue() -> void:
	play_one_shot(notification)

func play_chair() -> void:
	play_one_shot(chair)

func play_mouse() -> void:
	play_one_shot(mouse)

func play_one_shot(voice: AudioStreamPlayer3D) -> void:
	if DisplayServer.get_name() != "headless":
		voice.play()

func looping(source: AudioStreamWAV) -> AudioStreamWAV:
	var loop := source.duplicate() as AudioStreamWAV
	loop.loop_mode = AudioStreamWAV.LOOP_FORWARD
	loop.loop_end = roundi(loop.get_length() * loop.mix_rate)
	return loop

func speaker(label: String, at: Vector3, clip: AudioStream, level: float, reach: float) -> AudioStreamPlayer3D:
	var voice := AudioStreamPlayer3D.new()
	voice.name = label
	voice.position = at
	voice.stream = clip
	voice.volume_db = level
	voice.unit_size = reach
	voice.max_db = level + 2.0
	voice.max_distance = 14.0
	add_child(voice)
	return voice

func _exit_tree() -> void:
	for voice in get_children():
		if voice is AudioStreamPlayer3D:
			voice.stop()
			voice.stream = null

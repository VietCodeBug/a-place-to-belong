extends RefCounted
## Story text remains in the snapshot. Actions and topic eligibility are session-local.

var stage: Node
var entries: Dictionary = {}
var lines: Dictionary = {}
var current: Node3D
var memory: Dictionary
var actor_id := ""
var last_group := ""
var left_nearby: Dictionary = {}

func setup(owner_stage: Node, snapshot: Dictionary) -> void:
	stage = owner_stage
	for row in snapshot.legacy_lines:
		lines[row.id] = row
	for entry in snapshot.resident_dialogue:
		entries[entry.character_id] = entry
		for row in entry.lines:
			lines[row.id] = row
	entries.THOMAS = snapshot.thomas
	for row in snapshot.thomas.lines:
		lines[row.id] = row
	var repeat: Dictionary = snapshot.thomas.revisit_draft
	lines[repeat.id] = repeat

func is_open() -> bool:
	return is_instance_valid(current)

func track_departure(observer: Vector2) -> void:
	for id in stage.session.residents:
		if stage.session.memory(id).met and not left_nearby.get(id,false):
			var person: Node3D = stage.actor(id)
			if person!=null and person.point.distance_squared_to(observer)>6.0*6.0:
				left_nearby[id] = true

func open(person: Node3D) -> void:
	if is_open() or stage.inside:
		return
	current = person
	var was_busy: bool = person.behavior=="RETURN_HOME"
	current.talking = true
	actor_id = person.data.id
	memory = stage.session.memory(actor_id)
	if not memory.met:
		if actor_id=="THOMAS":
			thomas_group("THOMAS_INTRO",menu)
		else:
			resident_group("intro",menu)
		return
	if left_nearby.get(actor_id,false):
		memory.return_visit = true
		memory.visits += 1
		left_nearby[actor_id] = false
	if actor_id=="THOMAS":
		sequence("THOMAS_REPEAT",[stage.snapshot.thomas.revisit_draft.id],[],menu,false)
	elif memory.activity_done and not memory.heard.has("after_help"):
		resident_group("after_help",menu)
	elif was_busy:
		resident_group("busy",menu)
	elif memory.return_visit:
		resident_group("revisit",menu)
	else:
		menu()

func close() -> void:
	if is_instance_valid(current):
		current.talking = false
	current = null
	actor_id = ""

func option(label: String, command: Callable) -> Dictionary:
	return {"label":label,"action":command}

func menu() -> void:
	var options: Array = []
	if actor_id=="THOMAS":
		for topic in stage.snapshot.thomas.topics:
			if topic.group_id!=null and not memory.heard.has(topic.group_id):
				options.append(option(topic.label_vi,thomas_group.bind(topic.group_id,menu)))
		if not memory.heard.has("THOMAS_SMALL_TALK"):
			options.append(option("Nói thêm một chút",thomas_group.bind("THOMAS_SMALL_TALK",menu)))
	else:
		options.append(option("Hỏi về việc đang làm",resident_group.bind("ask_activity",menu)))
		if stage.activities.supports(actor_id) and not memory.activity_done:
			if stage.activities.in_progress(actor_id):
				options.append(option("Để tôi giúp lúc khác",decline))
			else:
				options.append(option("Đề nghị giúp",resident_group.bind("offer_help",offer)))
		if memory.activity_done and memory.return_visit and not memory.heard.has("familiar"):
			options.append(option("Trò chuyện thêm",resident_group.bind("familiar",menu)))
	options.append(option("Tạm biệt",stage.hub.ui.close))
	stage.hub.ui.show_story(current.nick,"Bạn muốn nói chuyện gì?",options)

func thomas_group(id: String, complete: Callable) -> void:
	for group in entries.THOMAS.groups:
		if group.id==id:
			sequence(id,group.lines,group.set_flags,complete,group.once)
			return

func resident_group(kind: String, complete: Callable) -> void:
	for group in entries[actor_id].dialogue_groups:
		if group.type!=kind:
			continue
		var ids: Array = group.legacy_CH01_007_line_ids.duplicate()
		if kind=="revisit" and actor_id=="VLA-01":
			ids = ["CH01007-G11" if memory.activity_done else "CH01007-G12"]
		elif kind=="revisit":
			ids = group.own_line_ids
		elif ids.is_empty():
			ids = group.own_line_ids
		var flags: Array = []
		if kind=="intro" and actor_id in ["VLA-01","VLA-04"]:
			flags.append("gardener_met" if actor_id=="VLA-01" else "repairer_met")
		sequence(kind,ids,flags,complete,group.once)
		return

func sequence(group_id: String, ids: Array, flags: Array, complete: Callable, once: bool) -> void:
	last_group = group_id
	var index: int = memory.next_line.get(group_id,0) if once else 0
	show_line(group_id,ids,index,flags,complete,once)

func show_line(group_id: String, ids: Array, index: int, flags: Array, complete: Callable, once: bool) -> void:
	if index>=ids.size():
		memory.heard[group_id] = true
		memory.next_line.erase(group_id)
		if group_id in ["intro","THOMAS_INTRO"]:
			memory.met = true
			memory.visits = 1
		for id in flags:
			stage.session.flag(id)
		complete.call()
		return
	var row: Dictionary = lines[ids[index]]
	var speaker: String = str(row.get("speaker_id",row.get("speaker",actor_id)))
	var name := "A" if speaker=="A" else str(current.nick)
	var next := func() -> void:
		if once:
			memory.next_line[group_id] = index+1
		show_line(group_id,ids,index+1,flags,complete,once)
	stage.hub.ui.show_story(name,row.text_vi,[option("Tiếp",next)])

func offer() -> void:
	var id := actor_id
	var accept := func() -> void:
		stage.hub.ui.close()
		stage.activities.begin(id)
	stage.hub.ui.show_story(current.nick,"Cùng làm một tay?",[option("Bắt đầu",accept),option("Để lúc khác",decline)])

func decline() -> void:
	stage.activities.abandon(actor_id)
	resident_group("decline",menu)

func activity_feedback(id: String) -> void:
	var person: Node3D = stage.actor(id)
	if person==null:
		return
	current = person
	current.talking = true
	actor_id = id
	memory = stage.session.memory(id)
	resident_group("after_help",stage.hub.ui.close)

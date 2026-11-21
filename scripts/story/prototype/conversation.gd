extends RefCounted
## Keeps the source transcript intact. The live conversation selects a short NPC beat and actions.

const SITUATIONS = preload("res://scripts/story/prototype/situations.gd")
const WORK = preload("res://scripts/story/prototype/activities.gd")
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
			if person!=null and person.point.distance_squared_to(observer)>36.0:
				left_nearby[id] = true

func open(person: Node3D) -> void:
	if is_open() or stage.inside:
		return
	var returning_home: bool = person.behavior=="RETURN_HOME"
	current = person
	current.talking = true
	actor_id = person.data.id
	memory = stage.session.memory(actor_id)
	if not memory.met:
		memory.met = true
		memory.visits = 1
		if actor_id=="THOMAS":
			thomas_topic("THOMAS_INTRO")
		else:
			if actor_id==WORK.HAZEL: stage.session.flag("gardener_met")
			if actor_id==WORK.OWEN: stage.session.flag("repairer_met")
			present("intro",resident_lines("intro"))
		return
	if left_nearby.get(actor_id,false):
		memory.return_visit = true
		memory.visits += 1
		left_nearby[actor_id] = false
	if actor_id=="THOMAS":
		if memory.get(SITUATIONS.WOOD)=="player":
			card("Chỗ củi cậu xếp vẫn khô ráo đấy.")
		else:
			present("THOMAS_REPEAT",[stage.snapshot.thomas.revisit_draft.id])
	elif actor_id=="VLA-06" and memory.get(SITUATIONS.MEAL)=="player":
		card("Tôi nhớ cái bát cậu đặt. Ai cũng có chỗ ngồi rồi.")
	elif memory.activity_done and not memory.heard.has("after_help"):
		present("after_help",resident_lines("after_help"))
	elif returning_home:
		present("busy",resident_lines("busy"))
	else:
		present("revisit",resident_lines("revisit"))

func close() -> void:
	if is_instance_valid(current):
		current.talking = false
	current = null
	actor_id = ""

func option(label: String, command: Callable) -> Dictionary:
	return {"label":label,"action":command}

func card(text: String) -> void:
	var options: Array = []
	if actor_id=="THOMAS":
		if stage.situations.available(SITUATIONS.WOOD):
			options.append(option("Xếp lại khúc củi",join_situation.bind(SITUATIONS.WOOD)))
			options.append(option("Để Thomas tự xếp",defer_situation.bind(SITUATIONS.WOOD)))
		for topic in stage.snapshot.thomas.topics:
			if topic.group_id!=null and not memory.heard.has(topic.group_id):
				options.append(option(topic.label_vi,thomas_topic.bind(topic.group_id)))
		if not memory.heard.has("THOMAS_SMALL_TALK") and options.size()<4:
			options.append(option("Nói thêm một chút",thomas_topic.bind("THOMAS_SMALL_TALK")))
	else:
		if actor_id=="VLA-06" and stage.situations.available(SITUATIONS.MEAL):
			options.append(option("Phụ Clara dọn bàn",join_situation.bind(SITUATIONS.MEAL)))
			options.append(option("Để mọi người tự dọn",defer_situation.bind(SITUATIONS.MEAL)))
		if stage.activities.can_offer(actor_id) and not memory.activity_done:
			if stage.activities.in_progress(actor_id):
				options.append(option("Để tôi giúp lúc khác",decline))
			elif actor_id==WORK.HAZEL:
				options.append(option("Giúp tưới hai luống",join_activity.bind("hold")))
				options.append(option("Để Hazel tưới",decline))
			else:
				options.append(option("Giữ đầu gỗ",join_activity.bind("hold")))
				options.append(option("Thử nêm chốt",join_activity.bind("wedge")))
				options.append(option("Để Owen tự sửa",decline))
		if last_group!="ask_activity":
			options.append(option("Hỏi về việc đang làm",ask_about_work))
		if memory.activity_done and memory.return_visit and not memory.heard.has("familiar"):
			options.append(option("Trò chuyện thêm",show_familiar))
	options.append(option("Rời cuộc trò chuyện [Esc]",stage.hub.ui.close))
	stage.hub.ui.show_story(current.nick,text,options)

func thomas_topic(id: String) -> void:
	var previews := {"THOMAS_INTRO":["CH01003-L02","CH01003-L07"],"THOMAS_DIRECTIONS":["CH01003-L25"],
		"THOMAS_ABOUT_HOUSE":["CH01003-L15","CH01003-L16"],"THOMAS_ABOUT_PEOPLE":["CH01003-L23","CH01003-L24"],
		"THOMAS_SMALL_TALK":["CH01003-L12"]}
	for group in entries.THOMAS.groups:
		if group.id==id:
			for flag_id in group.set_flags:
				stage.session.flag(flag_id)
			present(id,previews[id])
			return

func resident_lines(kind: String) -> Array:
	for group in entries[actor_id].dialogue_groups:
		if group.type!=kind:
			continue
		if kind=="revisit" and actor_id==WORK.HAZEL:
			return ["CH01007-G11" if memory.activity_done else "CH01007-G12"]
		var ids: Array = group.legacy_CH01_007_line_ids
		return group.own_line_ids if ids.is_empty() else ids
	return []

func present(group: String, ids: Array) -> void:
	last_group = group
	memory.heard[group] = true
	var spoken := PackedStringArray()
	for id in ids:
		var row: Dictionary = lines[id]
		if row.get("speaker_id", row.get("speaker",""))!="A":
			spoken.append(row.text_vi)
		if spoken.size()>=2:
			break
	card(" ".join(spoken))

func ask_about_work() -> void:
	present("ask_activity",resident_lines("ask_activity"))

func show_familiar() -> void:
	present("familiar",resident_lines("familiar"))

func join_activity(method: String) -> void:
	var id := actor_id
	stage.hub.ui.close()
	stage.activities.begin(id,method)

func decline() -> void:
	var id := actor_id
	stage.activities.defer_for_npc(id)
	var ids := resident_lines("decline")
	stage.hub.ui.close()
	if not ids.is_empty():
		stage.hub.ui.story_notice(lines[ids[0]].text_vi)

func join_situation(id: String) -> void:
	stage.hub.ui.close()
	stage.situations.begin(id)

func defer_situation(id: String) -> void:
	stage.hub.ui.close()
	stage.situations.decline(id)

func activity_feedback(id: String) -> void:
	var person: Node3D = stage.actor(id)
	if person==null:
		return
	var group: Array = []
	for section in entries[id].dialogue_groups:
		if section.type=="after_help":
			group = section.own_line_ids if section.legacy_CH01_007_line_ids.is_empty() else section.legacy_CH01_007_line_ids
			break
	if not group.is_empty():
		stage.session.memory(id).heard["after_help"] = true
		stage.hub.ui.story_notice(person.nick+": "+lines[group[0]].text_vi)

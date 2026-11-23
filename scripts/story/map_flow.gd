extends RefCounted
## Shared map order and scene entry points for the title and both playable maps.

const OFFICE := 1
const FOREST := 2
const OFFICE_SCENE := "res://scenes/story/real_office.tscn"
const APARTMENT_SCENE := "res://scenes/story/rented_apartment.tscn"
const LOOK_SENSITIVITY := &"office_look_sensitivity"
const HEAD_BOB := &"office_head_bob"
const FOREST_SCENE := "res://scenes/world/forest_hub.tscn"
const SHOW_TITLE := &"show_map_title"
const QUIET_UI := &"quiet_ui"
const GRASS_QUALITY := &"grass_quality"

static func is_vietnamese() -> bool:
	return TranslationServer.get_locale().begins_with("vi")

static func text(english: String, vietnamese: String) -> String:
	return vietnamese if is_vietnamese() else english

static func label(map: int) -> String:
	if map == OFFICE:
		return text("Map 01 · Office", "Map 01 · Văn phòng")
	return text("Map 02 · Forest", "Map 02 · Khu rừng")

static func enter_forest(tree: SceneTree, show_title := false) -> void:
	var forest := (load(FOREST_SCENE) as PackedScene).instantiate()
	forest.set_meta(SHOW_TITLE, show_title)
	var result := tree.change_scene_to_node(forest)
	if result != OK:
		forest.queue_free()
		push_error("Unable to enter Map 02: %s" % error_string(result))

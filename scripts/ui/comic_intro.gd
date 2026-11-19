extends ColorRect

signal finished

const COPY = preload("res://assets/story/comic/prologue.json")
const ART = preload("res://assets/story/comic/prologue.svg")
const THEME = preload("res://scripts/ui/storybook_theme.gd")

var page := 0
var language := "en"
var languages: Array
var picture: TextureRect
var caption: Label
var previous: Button
var next: Button
var skip: Button

func _ready() -> void:
	color = Color("182421")
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	languages = COPY.data.keys()
	var locale := TranslationServer.get_locale().get_slice("_", 0).get_slice("-", 0)
	if COPY.data.has(locale):
		language = locale
	var column := VBoxContainer.new()
	add_child(column)
	column.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	column.offset_left = 64
	column.offset_right = -64
	column.offset_top = 24
	column.offset_bottom = -24
	column.add_theme_constant_override("separation", 10)
	var picker := OptionButton.new()
	for code in languages:
		picker.add_item(COPY.data[code]["name"])
	picker.select(languages.find(language))
	picker.size_flags_horizontal = Control.SIZE_SHRINK_END
	picker.item_selected.connect(func(index: int):
		language = languages[index]
		refresh()
	)
	column.add_child(picker)
	picture = TextureRect.new()
	picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	picture.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(picture)
	caption = Label.new()
	caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.add_theme_font_override("font", THEME.SANS)
	caption.add_theme_font_size_override("font_size", 23)
	column.add_child(caption)
	var actions := HBoxContainer.new()
	actions.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_child(actions)
	previous = add_action(actions, func(): page -= 1; refresh())
	next = add_action(actions, advance)
	skip = add_action(actions, func(): finished.emit())
	refresh()
	next.grab_focus()

func add_action(parent: Control, callback: Callable) -> Button:
	var button := Button.new()
	button.custom_minimum_size = Vector2(145, 42)
	button.pressed.connect(callback)
	parent.add_child(button)
	return button

func advance() -> void:
	if page == 3:
		finished.emit()
	else:
		page += 1
		refresh()

func refresh() -> void:
	var tile := ART.get_size() / 2.0
	var atlas := AtlasTexture.new()
	atlas.atlas = ART
	atlas.region = Rect2(Vector2(page % 2, page / 2) * tile, tile)
	atlas.filter_clip = true
	picture.texture = atlas
	var localized: Dictionary = COPY.data[language]
	caption.text = localized["captions"][page]
	previous.disabled = page == 0
	previous.text = localized["back"]
	next.text = localized["finish"] if page == 3 else localized["next"]
	skip.text = localized["skip"]

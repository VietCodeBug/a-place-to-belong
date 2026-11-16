extends CanvasLayer
var player: CharacterBody3D
var active: Node3D
var panel: PanelContainer
var prompt: Label
var heading: Label
var body: Label
var close_button: Button

func _ready() -> void:
	var controls := Label.new()
	controls.text = "FOREST POST CAFÉ  /  A quiet morning\nWASD  Walk   •   Shift  Jog   •   E  Interact   •   Wheel  Zoom   •   Esc  Close"
	var backing := ColorRect.new()
	backing.position = Vector2(12,12)
	backing.size = Vector2(790,66)
	backing.color = Color(0.12,0.2,0.16,0.9)
	backing.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backing)
	controls.position = Vector2(24,20)
	controls.add_theme_color_override("font_color", Color("F6E8D0"))
	add_child(controls)
	prompt = Label.new()
	prompt.position = Vector2(24,650)
	prompt.add_theme_font_size_override("font_size",24)
	add_child(prompt)
	panel = PanelContainer.new()
	panel.position = Vector2(380,240)
	panel.custom_minimum_size = Vector2(520,210)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("283F36")
	style.content_margin_left = 28
	style.content_margin_right = 28
	style.content_margin_top = 24
	style.content_margin_bottom = 24
	panel.add_theme_stylebox_override("panel",style)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation",18)
	panel.add_child(column)
	heading = Label.new()
	heading.add_theme_font_size_override("font_size",25)
	column.add_child(heading)
	body = Label.new()
	column.add_child(body)
	close_button = Button.new()
	close_button.text = "Close letter  [Esc]"
	close_button.pressed.connect(close)
	column.add_child(close_button)
	add_child(panel)
	panel.hide()
	for item in get_tree().get_nodes_in_group("interactables"):
		item.activated.connect(show_message)

func _process(_delta: float) -> void:
	active = null
	var nearest := INF
	for item in get_tree().get_nodes_in_group("interactables"):
		var d: float = player.global_position.distance_to(item.global_position)
		if d < item.interaction_radius and d < nearest:
			active = item
			nearest = d
	prompt.text = "E  •  " + active.interaction_name if active != null and not panel.visible else ""

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close()
	elif event.is_action_pressed("interact") and active != null and not panel.visible:
		active.interact()

func show_message(title: String, message: String) -> void:
	heading.text = title
	body.text = message
	panel.show()
	player.blocked = true
	close_button.grab_focus()

func close() -> void:
	panel.hide()
	player.blocked = false

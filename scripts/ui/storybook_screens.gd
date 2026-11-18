extends RefCounted
const T=preload("res://scripts/ui/storybook_theme.gd")
const Mark=preload("res://scripts/ui/postal_motif.gd")
const Postcard=preload("res://scripts/ui/atmosphere_postcard.gd")
var ui
var pages: Dictionary={}
var page_name:=""
var shade: Control
var postcards: Array[Button]=[]
var studio_cards: Array[Button]=[]
var reduce_motion:=false
var feedback: Label
var typing_tween: Tween
func _init(owner_ui):ui=owner_ui
func button(parent: Node,text: String,action: Callable) -> Button:
	var b:=preload("res://scripts/ui/sketch_button.gd").new();b.text=text;b.custom_minimum_size.y=46;b.mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND
	b.pressed.connect(action);parent.add_child(b)
	b.mouse_entered.connect(func():tick(650.))
	b.pressed.connect(func():tick(880.))
	return b
func tick(hz: float) -> void:
	if reduce_motion:return
	var player:=AudioStreamPlayer.new();var wav:=AudioStreamWAV.new();wav.format=AudioStreamWAV.FORMAT_16_BITS;wav.mix_rate=22050
	var bytes:=PackedByteArray();bytes.resize(1324)
	for i in range(662):bytes.encode_s16(i*2,int(sin(i*hz*TAU/22050.)*700.*pow(1.-i/662.,3.)))
	wav.data=bytes;player.stream=wav;ui.add_child(player);player.finished.connect(player.queue_free);player.play()
func column(parent: Node,gap: int=12) -> VBoxContainer:
	var v:=VBoxContainer.new();v.add_theme_constant_override("separation",gap);parent.add_child(v);return v
func build_title() -> void:
	ui.title_screen=Control.new();ui.title_screen.name="ScenicTitleScreen";ui.title_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);ui.root_ui.add_child(ui.title_screen)
	# The official title is an illustrated postcard. The playable 3D map is unchanged.
	var illustration:=TextureRect.new();illustration.texture=preload("res://assets/ui/postcards/honey-sketch.png")
	illustration.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);illustration.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;illustration.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_COVERED;illustration.flip_h=true;illustration.mouse_filter=Control.MOUSE_FILTER_IGNORE;ui.title_screen.add_child(illustration)
	var wash:=TextureRect.new();var gradient:=Gradient.new();gradient.colors=PackedColorArray([Color(.96,.91,.81,1.),Color(.96,.91,.81,.97),Color(.96,.91,.81,0.)]);gradient.offsets=PackedFloat32Array([0.,.30,.64])
	var tex:=GradientTexture2D.new();tex.gradient=gradient;tex.fill_from=Vector2.ZERO;tex.fill_to=Vector2.RIGHT;wash.texture=tex
	wash.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);wash.mouse_filter=Control.MOUSE_FILTER_IGNORE;ui.title_screen.add_child(wash)
	var left:=VBoxContainer.new();left.position=Vector2(62,42);left.custom_minimum_size=Vector2(385,0);left.add_theme_constant_override("separation",12);ui.title_screen.add_child(left)
	var mast:=HBoxContainer.new();left.add_child(mast);var mark:=Mark.new();mark.seal=true;mast.add_child(mark)
	var words:=column(mast,4);words.add_child(T.label("LETTERS FROM THE WOODLAND",11,T.FOREST));words.add_child(T.label("POST OFFICE  /  COFFEE HOUSE",11,T.SAGE))
	left.add_child(T.label("Forest Post",72,T.FOREST,true));left.add_child(T.label("Café",82,T.FOREST,true))
	left.add_child(T.label("A warm cup. A letter. A slower day.",15,T.FOREST))
	var first:=button(left,"Begin your day   →",func():ui.exit_title_menu(false));first.primary=true;first.name="BeginDay";first.add_theme_font_size_override("font_size",19)
	var settings:=button(left,"Settings",func():open_page("Settings"))
	var leave:=button(left,"Leave the forest",func():ui.get_tree().quit())
	for secondary in [settings,leave]:
		secondary.flat_ink=true
		secondary.alignment=HORIZONTAL_ALIGNMENT_LEFT;secondary.custom_minimum_size.y=34
		for state in ["normal","hover","pressed","focus"]:
			var ghost:=StyleBoxFlat.new();ghost.bg_color=Color(0,0,0,0);ghost.content_margin_left=8;ghost.content_margin_top=5;ghost.content_margin_bottom=5
			if state=="focus" or state=="hover":ghost.border_color=T.CREAM;ghost.border_width_bottom=1
			secondary.add_theme_stylebox_override(state,ghost)
	var signature:=T.label("FOREST POST  ·  LITTLE MOMENTS, DELIVERED",10,T.SAGE);signature.set_anchors_preset(Control.PRESET_BOTTOM_LEFT);signature.position=Vector2(62,-28);ui.title_screen.add_child(signature)
func make_page(name: String,subtitle: String) -> VBoxContainer:
	var center:=CenterContainer.new();center.name=name.replace(" ","");center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);center.hide();shade.add_child(center);pages[name]=center
	var paper:=PanelContainer.new();paper.custom_minimum_size=Vector2(660,0);paper.add_theme_stylebox_override("panel",T.paper());center.add_child(paper)
	var col:=column(paper,14);col.add_child(T.label("FOREST POST  /  FIELD NOTES",11,T.CORAL));col.add_child(T.label(name,30,T.FOREST,true));col.add_child(T.label(subtitle,13,T.SAGE))
	return col
func build_pause() -> void:
	ui.pause_overlay=Control.new();ui.pause_overlay.name="CozyPauseMenu";ui.pause_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);ui.pause_overlay.hide();ui.root_ui.add_child(ui.pause_overlay)
	var dim:=ColorRect.new();dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);dim.color=Color(.04,.09,.07,.70);ui.pause_overlay.add_child(dim)
	var pause:=CenterContainer.new();pause.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);ui.pause_overlay.add_child(pause)
	var paper:=PanelContainer.new();paper.custom_minimum_size=Vector2(410,0);paper.add_theme_stylebox_override("panel",T.paper());pause.add_child(paper)
	var col:=column(paper,12);col.add_child(T.label("THE LETTERS CAN WAIT",11,T.CORAL));col.add_child(T.label("A little pause",32,T.FOREST,true))
	button(col,"Resume your day   →",func():ui.set_pause_menu(false))
	button(col,"Settings",func():open_page("Settings"))
	button(col,"Controls",func():open_page("Controls"))
	if ui.debug_tools:button(col,"Atmosphere Studio [test]",func():open_page("Atmosphere Studio"))
	button(col,"Return to title",func():ui.set_pause_menu(false);ui.enter_title_menu(false))
	button(col,"Quit game",func():ui.get_tree().quit())
	shade=Control.new();shade.name="StorybookPages";shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);shade.hide();ui.root_ui.add_child(shade)
	var overlay:=ColorRect.new();overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);overlay.color=Color(.04,.08,.06,.82);shade.add_child(overlay)
	build_settings();build_studio()
	var controls:=make_page("Controls","Take your time. There is no hurry here.")
	controls.add_child(T.label("W A S D     Walk\nShift            Jog\nMouse wheel  Camera distance\nE                   Read / talk / interact\nEsc                Close / pause\nTab / arrows  Navigate menus\nEnter / Space Activate a focused button",17,T.FOREST))
	button(controls,"Return   ←",back)
func open_page(name: String) -> void:
	if name=="Atmosphere Studio" and not ui.debug_tools:return
	for p in pages.values():p.hide()
	page_name=name;ui.root_ui.move_child(shade,-1);shade.show();pages[name].show()
	if name=="Atmosphere Studio":
		for card in studio_cards:card.selected=card.get_meta("weather_key")==ui.weather.weather_name
	var buttons=pages[name].find_children("*","Button",true,false)
	if not buttons.is_empty():buttons[0].grab_focus()
func back() -> void:
	shade.hide();page_name=""
	var target=ui.title_screen if ui.in_title_menu else ui.pause_overlay
	var buttons=target.find_children("*","Button",true,false)
	if not buttons.is_empty():buttons[0].grab_focus()
func build_settings() -> void:
	var col:=make_page("Settings","Make the clearing feel like home.")
	var tabs:=TabContainer.new();tabs.custom_minimum_size=Vector2(600,230);col.add_child(tabs)
	for name in ["Audio","Graphics","Controls","Accessibility"]:
		var content:=VBoxContainer.new();content.name=name;content.add_theme_constant_override("separation",12);tabs.add_child(content)
		match name:
			"Audio":
				content.add_child(T.label("Forest ambience",17))
				var volume:=HSlider.new();volume.min_value=0;volume.max_value=1;volume.step=.05;volume.value=.85;volume.custom_minimum_size.y=42;content.add_child(volume)
				volume.value_changed.connect(func(v: float):
					ui.weather.ambience.master_volume=v;feedback.text="Forest ambience: %d%%"%roundi(v*100)
				)
			"Graphics":
				content.add_child(T.label("Meadow detail",17));var row:=HBoxContainer.new();content.add_child(row)
				for q in ["low","medium","high","ultra"]:
					var quality: String=q
					button(row,q.capitalize(),func():ui.apply_grass_quality(quality);feedback.text="Meadow detail: "+quality.capitalize())
				button(content,"Toggle fullscreen",func():DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if DisplayServer.window_get_mode()==DisplayServer.WINDOW_MODE_FULLSCREEN else DisplayServer.WINDOW_MODE_FULLSCREEN))
			"Controls":content.add_child(T.label("WASD — walk    •    Shift — jog\nE — interact    •    Esc — pause\nMouse wheel — camera distance\nTab / arrows — move focus\nEnter / Space — select",16))
			"Accessibility":
				var motion:=CheckButton.new();motion.text="Quiet UI: reduce movement and UI sounds";content.add_child(motion)
				motion.toggled.connect(func(on: bool):
					reduce_motion=on
					for card in postcards:card.reduce_motion=on
					feedback.text="Quiet UI on" if on else "Quiet UI off"
				)
				content.add_child(T.label("High-contrast paper text • keyboard focus rings\nFonts include Vietnamese characters.\nSettings apply for this session.",14,T.SAGE))
	feedback=T.label("Changes apply immediately for this visit.",13,T.SAGE);col.add_child(feedback);button(col,"Return   ←",back)
func build_studio() -> void:
	var col:=make_page("Atmosphere Studio","A little postcard experiment. Choose the light and listen to the forest.")
	var row:=HBoxContainer.new();row.add_theme_constant_override("separation",20);col.add_child(row)
	ui.pause_time_readout=Label.new();ui.pause_time_readout.hide();col.add_child(ui.pause_time_readout)
	ui.pause_time_slider=preload("res://scripts/ui/daylight_dial.gd").new();ui.pause_time_slider.min_value=0.;ui.pause_time_slider.max_value=23.95;ui.pause_time_slider.step=.05;ui.pause_time_slider.value=16.5
	ui.pause_time_slider.value_changed.connect(ui._on_time_slider_changed);row.add_child(ui.pause_time_slider)
	var choices:=HFlowContainer.new();choices.custom_minimum_size=Vector2(370,230);row.add_child(choices)
	var cards: Array=[]
	for e in [["Sunshine","clear","golden"],["Drifting","partly_cloudy","golden"],["Cloud veil","overcast","overcast"],["Shower","light_rain","rain"],["Downpour","heavy_rain","rain"]]:
		var card=Postcard.new();card.compact=true;card.title=e[0];card.mood=e[2];choices.add_child(card);cards.append(card)
		var key: String=e[1]
		card.set_meta("weather_key",key);studio_cards.append(card)
		card.pressed.connect(func():
			ui.weather.set_weather(key,false)
			for other in cards:other.selected=other==card
		)
	var freeze:=CheckButton.new();freeze.text="Hold this light";freeze.button_pressed=ui.weather.paused;freeze.toggled.connect(func(on: bool):ui.weather.paused=on);col.add_child(freeze)
	button(col,"Return   ←",back)

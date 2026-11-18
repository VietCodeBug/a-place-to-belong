extends RefCounted
## Shared stationery palette, typography and control states.
const FOREST=Color("253D32")
const SAGE=Color("496B59")
const CREAM=Color("F6E8D0")
const OAK=Color("B88254")
const CORAL=Color("C85E55")
const HAND_SOURCE=preload("res://assets/ui/fonts/Handwritten.ttf")
const SANS=preload("res://assets/ui/fonts/ReadingSans.ttf")
static var HAND: Font=handwriting()
static func handwriting() -> Font:
	var font:=FontVariation.new();font.base_font=HAND_SOURCE;font.fallbacks=[SANS];return font
static func paper(bg: Color=CREAM) -> StyleBoxFlat:
	var s:=StyleBoxFlat.new();s.bg_color=bg;s.border_color=Color("D5BC95");s.set_border_width_all(1);s.set_corner_radius_all(4)
	s.content_margin_left=28;s.content_margin_right=28;s.content_margin_top=22;s.content_margin_bottom=22
	s.shadow_size=12;s.shadow_offset=Vector2(0,6);s.shadow_color=Color(0.03,.06,.04,.3);return s
static func theme() -> Theme:
	var t:=Theme.new();t.default_font=SANS;t.default_font_size=16
	for type in ["Label","CheckButton","TabContainer"]:t.set_color("font_color",type,FOREST)
	t.set_font("font","Label",SANS)
	for state in ["normal","hover","pressed","focus","disabled"]:
		var style:=paper(OAK if state=="normal" else (SAGE if state=="hover" else FOREST))
		style.content_margin_top=12;style.content_margin_bottom=12;style.border_color=CORAL if state=="focus" else Color("D5BC95")
		style.set_border_width_all(3 if state=="focus" else 1)
		t.set_stylebox(state,"Button",style)
	for state in ["font_color","font_hover_color","font_pressed_color","font_focus_color"]:t.set_color(state,"Button",CREAM)
	t.set_stylebox("panel","TabContainer",paper(Color("EADBC0")))
	for state in ["tab_selected","tab_unselected","tab_hovered","tab_focus"]:
		var tab:=paper(SAGE if state=="tab_selected" else Color("DEC8A5"))
		tab.content_margin_left=14;tab.content_margin_right=14;tab.content_margin_top=9;tab.content_margin_bottom=9;tab.shadow_size=0
		t.set_stylebox(state,"TabContainer",tab)
	t.set_color("font_selected_color","TabContainer",CREAM)
	t.set_color("font_unselected_color","TabContainer",FOREST)
	t.set_color("font_hovered_color","TabContainer",FOREST)
	var track:=paper(Color("B5BEA2"));track.content_margin_top=4;track.content_margin_bottom=4;track.shadow_size=0
	t.set_stylebox("slider","HSlider",track)
	var fill:=track.duplicate();fill.bg_color=SAGE
	t.set_stylebox("grabber_area","HSlider",fill);t.set_stylebox("grabber_area_highlight","HSlider",fill)
	return t
static func label(text: String, size: int=16, color: Color=FOREST, serif: bool=false) -> Label:
	var l:=Label.new();l.text=text;l.add_theme_font_size_override("font_size",size);l.add_theme_color_override("font_color",color)
	if serif:l.add_theme_font_override("font",HAND)
	return l

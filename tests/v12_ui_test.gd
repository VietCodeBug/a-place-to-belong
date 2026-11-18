extends SceneTree
var failures:=0
func _initialize():call_deferred("run")
func check(value: bool,message: String):
	print("PASS: " if value else "FAIL: ",message)
	if not value:failures+=1
func run():
	var hub=load("res://scenes/world/forest_hub.tscn").instantiate();root.add_child(hub)
	for i in range(5):await process_frame
	var ui=hub.ui;var book=ui.storybook
	var type=preload("res://scripts/ui/storybook_theme.gd")
	check(type.SANS.has_char("Đ".unicode_at(0)) and type.SANS.has_char("ễ".unicode_at(0)) and type.HAND.fallbacks.has(type.SANS),"handwritten font has bundled Vietnamese fallback")
	check(ui.postal_clock!=null and ui.hud_badge.get_theme_stylebox("panel") is StyleBoxEmpty,"circular HUD has no rectangular backing")
	hub.get_node("ForestWeather").set_time(22.);ui.update_hud_status()
	check(absf(ui.postal_clock.hours-22.)<.001,"clock reads real environment time")
	hub.get_node("ForestWeather").set_time(16.5)
	ui.enter_title_menu(true)
	check(root.gui_get_focus_owner()==ui.title_screen.find_child("BeginDay",true,false),"title opens with Begin focus")
	var tab:=InputEventKey.new();tab.keycode=KEY_TAB;tab.pressed=true;root.push_input(tab);await process_frame
	check(root.gui_get_focus_owner()!=ui.title_screen.find_child("BeginDay",true,false),"Tab moves actual GUI focus")
	var accept:=InputEventKey.new();accept.keycode=KEY_ENTER;accept.pressed=true;root.push_input(accept);await process_frame
	accept.pressed=false;root.push_input(accept);await process_frame
	check(book.shade.visible,"Enter activates focused Settings button")
	book.back()
	check(book.postcards.is_empty(),"official title contains no weather controls")
	book.open_page("Settings");await process_frame
	check(book.shade.visible and ui.root_ui.get_child(-1)==book.shade,"settings displayed above title and consumes input")
	check(root.gui_get_focus_owner()!=null and book.pages["Settings"].is_ancestor_of(root.gui_get_focus_owner()),"settings receives keyboard focus")
	var esc:=InputEventKey.new();esc.keycode=KEY_ESCAPE;esc.pressed=true;ui._unhandled_input(esc)
	check(not book.shade.visible and ui.in_title_menu,"Esc returns from settings to title")
	ui.exit_title_menu(true);ui.set_pause_menu(true)
	check(ui.in_pause_menu and hub.player.blocked and not book.shade.visible,"pause opens essential actions and blocks movement")
	check(not ui.pause_time_slider.is_visible_in_tree(),"time dial absent from ordinary pause menu")
	book.open_page("Atmosphere Studio");await process_frame
	check(not book.shade.visible,"official build cannot open weather debug page")
	check(not "Atmosphere" in " ".join(ui.pause_overlay.find_children("*","Button",true,false).map(func(b):return b.text)),"official pause has no weather tools")
	ui.debug_tools=true;book.open_page("Atmosphere Studio");await process_frame
	check(ui.pause_time_slider.is_visible_in_tree(),"time/weather controls live in separate Studio")
	ui.pause_time_slider.value=19.25
	check(absf(hub.get_node("ForestWeather").hours-19.25)<.1,"Studio dial actually changes clock")
	ui._unhandled_input(esc)
	check(ui.in_pause_menu and not book.shade.visible and hub.player.blocked,"Esc from Studio returns to pause without unblocking player")
	ui.set_pause_menu(false);hub.mailbox.interact();await process_frame
	check(ui.panel.visible and hub.player.blocked and ui.body.text.length()>0,"mailbox opens genuine letter content and locks walking")
	ui.close()
	check(not hub.player.blocked and ui.notice.text.length()>0,"closing letter restores movement and gives notification")
	for viewport in [Vector2i(1280,720),Vector2i(1920,1080)]:
		root.size=viewport
		ui.enter_title_menu(true);await process_frame;await process_frame
		check(buttons_inside(ui.title_screen,Vector2(viewport)),"title buttons stay on-screen at "+str(viewport))
		book.open_page("Settings");await process_frame;await process_frame
		check(buttons_inside(book.pages["Settings"],Vector2(viewport)),"settings buttons stay on-screen at "+str(viewport))
		book.back();ui.exit_title_menu(true)
	print("V12 UI COMPLETE; failures=",failures);hub.queue_free();await process_frame;quit(1 if failures else 0)
func buttons_inside(node: Node,viewport: Vector2) -> bool:
	for child in node.find_children("*","Button",true,false):
		if child.is_visible_in_tree():
			var r: Rect2=child.get_global_rect()
			if r.position.x<0 or r.position.y<0 or r.end.x>viewport.x+1 or r.end.y>viewport.y+1:
				print("Outside: ",child.text," ",r);return false
	return true

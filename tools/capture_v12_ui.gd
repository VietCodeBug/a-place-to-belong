extends SceneTree
var folder:="/tmp/v12-captures/720p"
func _initialize():call_deferred("run")
func run():
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--output="):folder=arg.trim_prefix("--output=")
	DirAccess.make_dir_recursive_absolute(folder)
	var hub=load("res://scenes/world/forest_hub.tscn").instantiate();root.add_child(hub)
	for i in range(5):await process_frame
	hub.get_node("ForestWeather").paused=true
	if DisplayServer.get_name()=="headless":quit(1);return
	if "--pages-only" in OS.get_cmdline_user_args():
		hub.ui.enter_title_menu(true);hub.ui.storybook.open_page("Settings")
		var settings_tabs=hub.ui.storybook.pages["Settings"].find_children("*","TabContainer",true,false)[0]
		settings_tabs.current_tab=1;await save("04b-graphics.png")
		settings_tabs.current_tab=2;await save("04c-controls-settings.png")
		hub.ui.storybook.back();hub.ui.exit_title_menu(true);hub.ui.set_pause_menu(true)
		hub.ui.storybook.open_page("Atmosphere Studio");await save("07-atmosphere-studio.png")
		hub.ui.storybook.back();hub.ui.set_pause_menu(false)
		hub.mailbox.interact();await save("09-envelope-opening.png");finish_reading_animation(hub.ui);await save("09-letter.png")
		hub.ui.close();hub.get_node("Eggeght/EggeghtChat").interact();finish_reading_animation(hub.ui);await save("10-dialogue.png")
		hub.ui.close();await save("11-notification.png")
		hub.queue_free();await process_frame;quit();return
	hub.ui.enter_title_menu(true);await save("01-main-menu.png")
	var card=hub.ui.storybook.postcards[1]
	var hover:=InputEventMouseMotion.new();hover.position=card.get_global_rect().get_center();root.push_input(hover);await process_frame
	card.grab_focus();await save("02-postcard-focus.png")
	card.pressed.emit()
	# Apply the transition's real target for a stable selected-state capture.
	for i in range(4):await process_frame
	await save("03-postcard-selected.png")
	hub.ui.storybook.open_page("Settings");await save("04-settings.png")
	var tabs=hub.ui.storybook.pages["Settings"].find_children("*","TabContainer",true,false)[0];tabs.current_tab=3;await save("05-accessibility.png")
	hub.ui.storybook.back();hub.ui.exit_title_menu(true);hub.ui.set_pause_menu(true);await save("06-pause.png")
	hub.ui.storybook.open_page("Atmosphere Studio");await save("07-atmosphere-studio.png")
	hub.ui.storybook.back();hub.ui.storybook.open_page("Controls");await save("08-controls.png")
	hub.ui.storybook.back();hub.ui.set_pause_menu(false)
	var mailbox=hub.get_node("Mailbox");mailbox.interact();await save("09-envelope-opening.png");finish_reading_animation(hub.ui);await save("09-letter.png")
	hub.ui.close();hub.get_node("Eggeght/EggeghtChat").interact();finish_reading_animation(hub.ui);await save("10-dialogue.png")
	hub.ui.close();await save("11-notification.png")
	hub.queue_free();await process_frame;quit()
func save(name: String):
	for i in range(2):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(folder.path_join(name))

func finish_reading_animation(ui):
	# Deterministic final UI state: advance the real animations, without replacing content.
	if ui.envelope_tween!=null:ui.envelope_tween.custom_step(2.0)
	if ui.letter_tween!=null:ui.letter_tween.custom_step(2.0)

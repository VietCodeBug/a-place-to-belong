extends SceneTree
## Official automatic-weather UI captures. Test weather tools are deliberately excluded.
var folder:="/tmp/v12-official/720p"
func _initialize():call_deferred("run")
func run():
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--output="):folder=arg.trim_prefix("--output=")
	DirAccess.make_dir_recursive_absolute(folder)
	if DisplayServer.get_name()=="headless":quit(1);return
	var hub=load("res://scenes/world/forest_hub.tscn").instantiate();root.add_child(hub)
	for i in range(4):await process_frame
	# Freeze only for deterministic screenshots; the game itself retains automatic weather.
	hub.get_node("ForestWeather").paused=true
	hub.ui.enter_title_menu(true);await save("01-main-menu.png")
	var hover:=InputEventMouseMotion.new();hover.position=hub.ui.title_screen.find_child("BeginDay",true,false).get_global_rect().get_center();root.push_input(hover);await save("02-main-focus-hover.png")
	hub.ui.storybook.open_page("Settings");await save("03-settings-audio.png")
	var tabs=hub.ui.storybook.pages["Settings"].find_children("*","TabContainer",true,false)[0]
	tabs.current_tab=1;await save("04-settings-graphics.png")
	tabs.current_tab=3;await save("05-accessibility.png")
	hub.ui.storybook.back();hub.ui.exit_title_menu(true);hub.ui.set_pause_menu(true);await save("06-pause.png")
	hub.ui.storybook.open_page("Controls");await save("07-controls.png")
	hub.ui.storybook.back();hub.ui.set_pause_menu(false);hub.mailbox.interact();await save("08-envelope-opening.png")
	finish_reading(hub.ui);await save("09-letter.png")
	hub.ui.close();hub.get_node("Eggeght/EggeghtChat").interact();finish_reading(hub.ui);await save("10-dialogue.png")
	hub.ui.close();await save("11-notification.png")
	hub.queue_free();await process_frame;quit()
func finish_reading(ui):
	if ui.envelope_tween!=null:ui.envelope_tween.custom_step(2.)
	if ui.letter_tween!=null:ui.letter_tween.custom_step(2.)
func save(name: String):
	await process_frame;await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(folder.path_join(name))

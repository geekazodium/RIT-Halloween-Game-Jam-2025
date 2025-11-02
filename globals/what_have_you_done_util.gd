class_name WHATHAVEYOUDONE

## when the user does something completely insane, call this.
## just.
## just quit, don't even bother.
## it's not worth trying to rescue this.
## this is past saving
static func WHAT_HAVE_YOU_DONE(angry_message: String) -> void:
	var dialog: AcceptDialog = AcceptDialog.new();
	
	var stack: Array[Dictionary] = get_stack();
	stack.pop_front();
	var stack_trace: String = stack.reduce(func(acc, next):
		return "%s\n%s at %s:%s" %[acc, next["function"], next["source"], next["line"]];
	, "");
	
	dialog.dialog_text = "%s\n%s" % [angry_message,stack_trace];
	dialog.set_unparent_when_invisible(true);
	dialog.title = "WHAT HAVE YOU DONE (T_T)";
	var loop:MainLoop = Engine.get_main_loop();
	if loop is SceneTree:
		loop.paused = true;
		(loop as SceneTree).root.add_child(dialog);
		dialog.process_mode = Node.PROCESS_MODE_ALWAYS;
		dialog.popup_centered();
		await dialog.tree_exiting;
		dialog.queue_free();
	loop.quit(-1);

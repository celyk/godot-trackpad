@tool
extends Node

var touchscreen_emulation_enabled := false :
	set(value):
		touchscreen_emulation_enabled = value
		
		if touchscreen_emulation_enabled:
			var touchscreen_emulation = TouchscreenEmulation.new()
			add_child(touchscreen_emulation)
		else:
			if $TouchScreenEmulation:
				$TouchScreenEmulation.queue_free()

#var touches_cache : Dictionary[int,TrackpadTouch] = {}
#var prev_touches_cache : Dictionary[int,TrackpadTouch] = {}
var touches_cache : Array[TrackpadTouch] = []
var prev_touches_cache : Array[TrackpadTouch] = []

signal trackpad_touch(touch:TrackpadTouch)

const TouchscreenEmulation = preload("uid://bhwwj71jhevtg")
const TouchscreenEmulationDebugDraw = preload("uid://b1jy66mvled8i")

func _ready() -> void:
	var device := TrackpadServer.get_primary_device()
	
	TrackpadServer.device_register_input_callback(device, _on_trackpad_event)
	trackpad_touch.connect(_on_touch)
	
	if ProjectSettings.get_setting("godot_trackpad/input/emulate_screen_touch") == true:
		if not Engine.is_editor_hint():
			touchscreen_emulation_enabled = true
			#Input.emulate_mouse_from_touch = false
			Input.emulate_touch_from_mouse = false
		
		if ProjectSettings.get_setting("godot_trackpad/input/display_screen_touches") == true:
			var touchscreen_emulation_draw = TouchscreenEmulationDebugDraw.new()
			add_child(touchscreen_emulation_draw)
	
	if (not Engine.is_editor_hint()) and ProjectSettings.get_setting("godot_trackpad/input/mouse_capture") == true:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _exit_tree() -> void:
	TrackpadServer.device_set_haptics_disabled(TrackpadServer.get_primary_device(), false)
	
func _on_trackpad_event(touch:TrackpadTouch):
	trackpad_touch.emit.call_deferred(touch)

func _on_touch(touch:TrackpadTouch):
	touches_cache.append(touch)

func _process(delta: float) -> void:
	await RenderingServer.frame_post_draw
	
	prev_touches_cache = touches_cache
	touches_cache.clear()


func _print_touch(touch:TrackpadTouch):
	print(var_to_str(touch))

@tool
extends Node

#var touches_cache : Dictionary[int,TrackpadTouch] = {}
#var prev_touches_cache : Dictionary[int,TrackpadTouch] = {}
var touches_cache : Array[TrackpadTouch] = []
var prev_touches_cache : Array[TrackpadTouch] = []

signal trackpad_touch(touch:TrackpadTouch)

const TouchscreenEmulation = preload("uid://bhwwj71jhevtg")
const TouchscreenEmulationDebugDraw = preload("uid://b1jy66mvled8i")

var touchscreen_emulation_callback : Callable

func _ready() -> void:
	var device := TrackpadServer.get_primary_device()
	
	TrackpadServer.device_register_input_callback(device, _on_trackpad_event)
	trackpad_touch.connect(_on_touch)
	
	if ProjectSettings.get_setting("godot_trackpad/input/emulate_screen_touch") == true:
		var touchscreen_emulation = TouchscreenEmulation.new()
		add_child(touchscreen_emulation)
		
		if ProjectSettings.get_setting("godot_trackpad/input/display_screen_touches") == true:
			var touchscreen_emulation_draw = TouchscreenEmulationDebugDraw.new()
			add_child(touchscreen_emulation_draw)

func _on_trackpad_event(touch:TrackpadTouch):
	if touchscreen_emulation_callback:
		touchscreen_emulation_callback.call_deferred(0, touch)
	
	trackpad_touch.emit.call_deferred(touch)

func _on_touch(touch:TrackpadTouch):
	touches_cache.append(touch)

func _process(delta: float) -> void:
	await RenderingServer.frame_post_draw
	
	prev_touches_cache = touches_cache
	touches_cache.clear()


func _print_touch(touch:TrackpadTouch):
	print(var_to_str(touch))

@tool
extends Node

var touches_cache : Array[OMSTouchData] = []
signal trackpad_touch(touch:OMSTouchData)

const TouchscreenEmulation = preload("uid://bhwwj71jhevtg")

func _ready() -> void:
	TrackpadServer.register_input_callback(_on_trackpad_event)
	trackpad_touch.connect(_on_touch)
	
	if ProjectSettings.get_setting("godot_trackpad/input/emulate_screen_touch") == true:
		add_child(TouchscreenEmulation.new())

func _on_trackpad_event(touch:OMSTouchData):
	trackpad_touch.emit.call_deferred(touch)

func _on_touch(touch:OMSTouchData):
	touches_cache.append(touch)

func _process(delta: float) -> void:
	await RenderingServer.frame_post_draw
	touches_cache.clear()

func _print_touch(touch:OMSTouchData):
	print(var_to_str(touch))

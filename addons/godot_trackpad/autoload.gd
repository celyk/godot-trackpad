@tool
extends Node

var touches_cache : Array[OMSTouchData] = []
signal trackpad_touch(touch:OMSTouchData)

func _ready() -> void:
	TrackpadServer.register_input_callback(_on_trackpad_event)
	trackpad_touch.connect(_on_touch)

func _on_trackpad_event(touch:OMSTouchData):
	trackpad_touch.emit.call_deferred(touch)

func _on_touch(touch:OMSTouchData):
	touches_cache.append(touch)

func _process(delta: float) -> void:
	await RenderingServer.frame_post_draw
	touches_cache.clear()

func _print_touch(touch:OMSTouchData):
	print(var_to_str(touch))

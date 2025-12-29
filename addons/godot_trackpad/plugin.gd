@tool
class_name TrackpadServerAddon extends EditorPlugin

static var singleton : TrackpadServerAddon

signal trackpad_touch(touch:OMSTouchData)

func _enter_tree() -> void:
	singleton = self
	TrackpadServer.register_input_callback(_on_trackpad_event)
	trackpad_touch.connect(_on_touch)

func _on_trackpad_event(touch:OMSTouchData):
	trackpad_touch.emit.call_deferred(touch)

func _on_touch(touch:OMSTouchData):
	#_print_touch(touch)
	pass

func _print_touch(touch:OMSTouchData):
	print(var_to_str(touch))

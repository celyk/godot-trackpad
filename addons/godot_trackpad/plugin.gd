@tool
extends EditorPlugin

func _enter_tree() -> void:
	TrackpadServer.register_input_callback(_on_trackpad_event)

func _on_trackpad_event(touch:OMSTouchData):
	#print(touch.position)
	_print_touch(touch)

func _print_touch(touch:OMSTouchData):
	print(var_to_str(touch))

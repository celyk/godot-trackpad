@tool
extends Node

const TouchParser = preload("touch_parser.gd")
var touch_parser = TouchParser.new()

func _ready() -> void:
	name = "TouchScreenEmulation"
	TrackpadServer.device_register_input_callback(TrackpadServer.get_primary_device(), _on_trackpad_event)

func _on_trackpad_event(touch:TrackpadTouch) -> void:
	_process_touch.call_deferred(DisplayServer.MAIN_WINDOW_ID, touch)

func _process_touch(window_id:int, touch:TrackpadTouch) -> void:
	# Map the trackpad edge to edge with the game window.
	var touch_pos := _normalized_pos_to_screen(touch.normalized_position)
	
	# Get the cached TrackpadTouch before updating the touch parser.
	var prev_touch : TrackpadTouch = touch_parser._get_touch(touch)
	var prev_index : int = -1
	if prev_touch != null:
		prev_index = touch_parser.touch_get_index(touch)
	
	# Update the touch parser.
	touch_parser._process_touch(window_id, touch)
	
	# Emulate touch screen events.
	match touch.state:
		TrackpadTouch.starting:
			var index : int = touch_parser.touch_get_index(touch)
			
			touch_press(
					window_id,
					index, 
					touch_pos.x,
					touch_pos.y,
					true,
					false)
		
		TrackpadTouch.touching:
			# Ignore touches that began because the callback started running
			if prev_touch == null: return
			
			assert(prev_index != -1)
			
			var prev_touch_pos := _normalized_pos_to_screen(prev_touch.normalized_position)
			
			touch_drag(
					window_id,
					prev_index,
					prev_touch_pos.x,
					prev_touch_pos.y,
					touch_pos.x,
					touch_pos.y,
					touch.pressure,
					touch.axis)
			
		TrackpadTouch.leaving:
			# Ignore touches that began because the callback started running
			if prev_touch == null: return
			
			assert(prev_index != -1)
			
			touch_press(
					window_id,
					prev_index, 
					touch_pos.x,
					touch_pos.y,
					false,
					false)

func _normalized_pos_to_screen(p:Vector2) -> Vector2:
	p = p * Vector2(get_viewport().size)
	return p

#region Send Input

func touch_press(window_id:int, p_idx:int, p_x:int, p_y:int, p_pressed:bool, p_double_click:bool) -> void:
	var event := InputEventScreenTouch.new()
	
	event.set_window_id(window_id)
	event.set_index(p_idx)
	event.set_pressed(p_pressed)
	event.set_position(Vector2(p_x, p_y))
	event.set_double_tap(p_double_click)
	
	perform_event(event)

func touch_drag(window_id:int, p_idx:int, p_prev_x:int, p_prev_y:int, p_x:int, p_y:int, p_pressure:float, p_tilt:Vector2) -> void:
	var event := InputEventScreenDrag.new()
	
	event.set_window_id(window_id)
	event.set_index(p_idx)
	event.set_pressure(p_pressure)
	event.set_tilt(p_tilt)
	event.set_position(Vector2(p_x, p_y))
	event.set_relative(Vector2(p_x - p_prev_x, p_y - p_prev_y))
	event.set_screen_relative(event.get_relative())
	
	perform_event(event)

func touch_canceled(window_id:int, p_idx:int) -> void:
	touch_press(window_id, p_idx, -1, -1, false, false)

func _push_input(viewport:Viewport, event:InputEvent) -> void:
	viewport.push_input(event)

func perform_event(event:InputEvent) -> void:
	Input.parse_input_event(event)

#endregion

@tool
extends Node

const TouchParser = preload("touch_parser.gd")
var touch_parser = TouchParser.new()

func _ready() -> void:
	name = "TouchScreenEmulation"
	TrackpadServerAddon.touchscreen_emulation_callback = _process_touch

func _process_touch(window_id:int, touch:TrackpadTouch) -> void:
	var touch_pos := _normalized_pos_to_screen(touch.normalized_position)
	
	touch_parser._process_touch(window_id, touch)
	
	match touch.state:
		TrackpadTouch.starting:
			var index : int = touch_parser.get_lowest_index_available_for_touch(touch)
	
			touch_press(
					window_id,
					index, 
					touch_pos.x,
					touch_pos.y,
					true,
					false)
			
			#print("starting id: ", id)
			
			touch_parser._initial_touch_insert(touch)
		
		TrackpadTouch.touching:
			var prev_touch := touch_parser._get_touch(touch)
			
			# Ignore touches that began because the callback started running
			if prev_touch == null: return
			
			var prev_touch_pos := _normalized_pos_to_screen(prev_touch.normalized_position)
			
			var index : int = touch_parser.inverse_touch_map[prev_touch.identifier]
			
			touch_drag(
					window_id,
					index,
					prev_touch_pos.x,
					prev_touch_pos.y,
					touch_pos.x,
					touch_pos.y,
					touch.pressure,
					touch.axis)
			
			#print("touching id: ", id)
			
			touch_parser._update_touch(touch)
			
		TrackpadTouch.leaving:
			var prev_touch := touch_parser._get_touch(touch)
			
			# Ignore touches that began because the callback started running
			if prev_touch == null: return
			
			var index : int = touch_parser.inverse_touch_map[prev_touch.identifier]
			
			touch_press(
					window_id,
					index, 
					touch_pos.x,
					touch_pos.y,
					false,
					false)
			
			#print("leaving id: ", id)
			
			touch_parser._final_touch_remove(touch)

func _normalized_pos_to_screen(p:Vector2) -> Vector2:
	p.y = 1.0 - p.y
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

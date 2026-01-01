@tool
extends Node

func _ready() -> void:
	if Engine.is_editor_hint():
		set_process(false)

var prev_touches_cache : Array[OMSTouchData]
func _process(delta: float) -> void:
	#for touch:OMSTouchData in TrackpadServerAddon.touches_cache:
	for i:int in range(0,TrackpadServerAddon.touches_cache.size()):
		var touch := TrackpadServerAddon.touches_cache[i]
		var prev_touch : OMSTouchData = null
		
		#var prev_touch_idx := func(e): return e.id == i
		#if prev_touches_cache.find_custom()
		
		for j:int in range(0,prev_touches_cache.size()):
			if prev_touches_cache[j].id == touch.id:
				prev_touch = prev_touches_cache[j]
				break
		
		var touch_pos : Vector2 = Vector2(touch.position)
		touch_pos.y = 1.0 - touch_pos.y
		touch_pos = touch_pos * Vector2(get_viewport().size)
		
		#print(touch_pos)
		
		if prev_touch == null:
			touch_press(
					0,
					touch.id, 
					touch_pos.x,
					touch_pos.y,
					true,
					false)
		else:
			var prev_touch_pos : Vector2 = prev_touch.position
			prev_touch_pos.y = 1.0 - prev_touch_pos.y
			prev_touch_pos = prev_touch_pos * Vector2(get_viewport().size)
			
			touch_drag(
					0,
					touch.id,
					prev_touch_pos.x,
					prev_touch_pos.y,
					touch_pos.x,
					touch_pos.y,
					touch.pressure,
					touch.axis)
	
	prev_touches_cache = TrackpadServerAddon.touches_cache.duplicate()

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

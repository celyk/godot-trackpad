@tool
extends Node

const max_touches := 10

func _ready() -> void:
	if Engine.is_editor_hint():
		set_process(false)

var prev_touches_cache : Dictionary[int,OMSTouchData] = {}
func _process(delta: float) -> void:
	for i:int in range(0,max_touches):
		var prev_touch : OMSTouchData = prev_touches_cache.get(i)
		var touch := TrackpadServerAddon.touches_cache.get(i)
		
		if prev_touch == null and touch:
			var touch_pos : Vector2 = Vector2(touch.position)
			touch_pos.y = 1.0 - touch_pos.y
			touch_pos = touch_pos * Vector2(get_viewport().size)
			
			touch_press(
					0,
					get_lowest_index_available_for_touch(touch), 
					touch_pos.x,
					touch_pos.y,
					true,
					false)
		
		if prev_touch and touch == null:
			var prev_touch_pos : Vector2 = prev_touch.position
			prev_touch_pos.y = 1.0 - prev_touch_pos.y
			prev_touch_pos = prev_touch_pos * Vector2(get_viewport().size)
			
			touch_press(
					0,
					get_lowest_index_available_for_touch(prev_touch), 
					prev_touch_pos.x,
					prev_touch_pos.y,
					false,
					false)
		
		if prev_touch and touch:
			var touch_pos : Vector2 = Vector2(touch.position)
			touch_pos.y = 1.0 - touch_pos.y
			touch_pos = touch_pos * Vector2(get_viewport().size)
			
			var prev_touch_pos : Vector2 = prev_touch.position
			prev_touch_pos.y = 1.0 - prev_touch_pos.y
			prev_touch_pos = prev_touch_pos * Vector2(get_viewport().size)
			
			touch_drag(
					0,
					get_lowest_index_available_for_touch(touch),
					prev_touch_pos.x,
					prev_touch_pos.y,
					touch_pos.x,
					touch_pos.y,
					touch.pressure,
					touch.axis)
	
	prev_touches_cache = TrackpadServerAddon.touches_cache.duplicate()

func get_lowest_index_available_for_touch(touch:OMSTouchData) -> int:
	var touches := TrackpadServerAddon.touches_cache.values()
	touches.sort_custom(func(a,b): return a.id < b.id)
	
	var prev_touch_id : int = 0
	for i in range(0,touches.size()):
		var touch_id : int = touches[i].id
		
		if touch_id - prev_touch_id > 1:
			var lowest_available_index := prev_touch_id + 1
			return lowest_available_index
		
		prev_touch_id = touch_id
	
	return 0
	
	return touch.id

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

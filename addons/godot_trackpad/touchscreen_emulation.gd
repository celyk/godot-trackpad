@tool
extends Node

const max_touches := 10

var prev_touch_events : Array[OMSTouchData] = []
var touch_events : Array[OMSTouchData] = []

func _ready() -> void:
	if Engine.is_editor_hint():
		set_process(false)
	
	touch_events.resize(max_touches)
	touch_events.fill(null)
	prev_touch_events = touch_events.duplicate()

func _process(delta: float) -> void:
	touch_events.fill(null)
	
	for touch:OMSTouchData in TrackpadServerAddon.touches_cache.values():
		var id := get_lowest_index_available_for_touch(touch)
		
		if id < max_touches:
			touch_events[id] = touch
	
	#print(touch_events.map(func(e): return str(e.id)+"   " if e else null))
	
	for i:int in range(0,max_touches):
		var prev_touch : OMSTouchData = prev_touch_events[i]
		var touch : OMSTouchData = touch_events[i]
		
		if prev_touch == null and touch:
			var touch_pos : Vector2 = Vector2(touch.position)
			touch_pos.y = 1.0 - touch_pos.y
			touch_pos = touch_pos * Vector2(get_viewport().size)
			
			touch_press(
					0,
					i, 
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
					i, 
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
					i,
					prev_touch_pos.x,
					prev_touch_pos.y,
					touch_pos.x,
					touch_pos.y,
					touch.pressure,
					touch.axis)
	
	prev_touch_events = touch_events.duplicate()

func get_lowest_index_available_for_touch(touch:OMSTouchData) -> int:
	# First see if the touch exists
	for i in range(0,max_touches):
		if prev_touch_events[i] == null:
			continue
		
		if prev_touch_events[i].id == touch.id:
			return i
	
	# If not, get the first available slot
	for i in range(0,max_touches):
		if prev_touch_events[i] == null:
			return i
	
	return max_touches

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

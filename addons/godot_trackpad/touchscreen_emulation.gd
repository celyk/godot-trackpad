@tool
extends Node

const max_touches := 10

# From the minimal id to the raw TrackpadTouch
var prev_touch_map : Dictionary[int, TrackpadTouch]
var touch_map : Dictionary[int, TrackpadTouch]
var inverse_touch_map : Dictionary[int, int] # identifier -> id

func _ready() -> void:
	if Engine.is_editor_hint():
		set_process(false)
	
	TrackpadServerAddon.touchscreen_emulation_callback = _process_touch

func _process(delta: float) -> void:
	return
	
	var touch_queue : Array[TrackpadTouch] = _get_touch_queue()
	
	var window_id := 0
	
	for i in range(0,touch_queue.size()):
		var touch : TrackpadTouch = touch_queue[i]
		_process_touch(window_id, touch)

func _process_touch(window_id:int, touch:TrackpadTouch) -> void:
	var touch_pos := _normalized_pos_to_screen(touch.position)
	
	match touch.state:
		TrackpadTouch.starting:
			var id := get_lowest_index_available_for_touch(touch)
	
			touch_press(
					window_id,
					id, 
					touch_pos.x,
					touch_pos.y,
					true,
					false)
			
			print("starting id: ", id)
			
			_initial_touch_insert(touch)
		
		TrackpadTouch.touching:
			var prev_touch := _get_touch(touch)
			
			if prev_touch == null: return
			
			var prev_touch_pos := _normalized_pos_to_screen(prev_touch.position)
			
			var id := inverse_touch_map[prev_touch.id]
			
			touch_drag(
					window_id,
					id,
					prev_touch_pos.x,
					prev_touch_pos.y,
					touch_pos.x,
					touch_pos.y,
					touch.pressure,
					touch.axis)
			
			print("touching id: ", id)
			
			_update_touch(touch)
			
		TrackpadTouch.leaving:
			var prev_touch := _get_touch(touch)
			
			var id := inverse_touch_map[prev_touch.id]
			
			touch_press(
					window_id,
					id, 
					touch_pos.x,
					touch_pos.y,
					false,
					false)
			
			print("leaving id: ", id)
			
			_final_touch_remove(touch)
		
		_:
			var prev_touch := _get_touch(touch)
			#print("Other touch state: ", touch.state, " id: ", _find_touch_id(prev_touch))
			pass
		
func _is_in_touch_map(touch:TrackpadTouch) -> bool:
	return touch.id in touch_map.values().map(func(e:TrackpadTouch): return e.id)

func _find_touch_id(touch:TrackpadTouch) -> int:
	#if touch == null: return -1
	
	touch_map.sort()
	var foo := func(e:TrackpadTouch, id:int): return e.id == id
	return touch_map.values().find_custom(foo.bind(touch.id))

func _get_touch(touch:TrackpadTouch) -> TrackpadTouch:
	return touch_map[inverse_touch_map[touch.id]]
	return touch_map.get(_find_touch_id(touch))

func _is_touch_free(touch:TrackpadTouch) -> bool:
	return touch == null or touch.state == TrackpadTouch.TouchState.leaving

func _get_sorted_touches() -> Array[TrackpadTouch]:
	touch_map.sort()
	return touch_map.values()

func get_lowest_index_available_for_touch(touch:TrackpadTouch) -> int:
	var id := 0
	
	touch_map.sort()
	var sorted_keys := touch_map.keys()
	
	if not sorted_keys.is_empty():
		for i in range(0, sorted_keys.back()+2):
			if not (i in sorted_keys):
				id = i
				break
	
	return id

func _initial_touch_insert(touch:TrackpadTouch) -> void:
	var id := get_lowest_index_available_for_touch(touch)
	touch_map[id] = touch
	inverse_touch_map[touch.id] = id

func _get_touch_queue() -> Array[TrackpadTouch]:
	var queue := TrackpadServerAddon.touches_cache.duplicate()
	
	#queue.sort_custom(func(a:TrackpadTouch,b:TrackpadTouch): return a.timestamp < b.timestamp)
	
	return queue

func _update_touch(touch:TrackpadTouch) -> void:
	var id := inverse_touch_map[touch.id]
	touch_map[id] = touch

func _final_touch_remove(touch:TrackpadTouch) -> void:
	var id := inverse_touch_map[touch.id]
	touch_map.erase(id)

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

@tool
extends Node

const max_touches := 10

# From the minimal id to the raw TrackpadTouch
var prev_touch_map : Dictionary[int, TrackpadTouch]
var touch_map : Dictionary[int, TrackpadTouch]
#var identifier_to_id : Dictionary[int, int]
#var id_to_identifier : Dictionary[int, int]

func _ready() -> void:
	if Engine.is_editor_hint():
		set_process(false)

var prev_sorted_touches : Array[TrackpadTouch]
var sorted_touches : Array[TrackpadTouch]
func _process(delta: float) -> void:
	#return
	
	sorted_touches = _get_sorted_touches()
	print(sorted_touches)
	#print(sorted_touches)
	
	var window_id := 0
	
	for id:int in range(0,sorted_touches.size()):
		var touch : TrackpadTouch = sorted_touches[id]
		var touch_pos := _normalized_pos_to_screen(touch.position)
		
		if touch.state == TrackpadTouch.starting:
			print("touch_press")
			
			touch_press(
					window_id,
					id, 
					touch_pos.x,
					touch_pos.y,
					true,
					false)
		
		if touch.state == TrackpadTouch.touching:
			print("touch_drag")
			
			print(prev_touch_map[id])
			var prev_touch : TrackpadTouch = prev_touch_map[id]
			var prev_touch_pos := _normalized_pos_to_screen(touch.position)
			
			touch_drag(
					window_id,
					id,
					prev_touch_pos.x,
					prev_touch_pos.y,
					touch_pos.x,
					touch_pos.y,
					touch.pressure,
					touch.axis)
		
		if touch.state == TrackpadTouch.leaving:
			var prev_touch : TrackpadTouch = prev_touch_map[id]
			
			if not _is_touch_free(prev_touch):
				touch_press(
						window_id,
						id, 
						touch_pos.x,
						touch_pos.y,
						false,
						false)
	
	for id:int in range(0,sorted_touches.size()):
		if sorted_touches[id] != null:
			prev_touch_map[id] = sorted_touches[id]
	
	#_update_touch_events()
	

func _is_in_touch_map(touch:TrackpadTouch) -> bool:
	return touch.id in touch_map.values().map(func(e:TrackpadTouch): return e.id)

func _find_touch_id(touch:TrackpadTouch) -> int:
	touch_map.sort()
	var foo := func(e:TrackpadTouch, id:int): return e.id == id
	return touch_map.values().find_custom(foo.bind(touch.id))

func _is_touch_free(touch:TrackpadTouch) -> bool:
	return touch == null or touch.state == TrackpadTouch.TouchState.leaving

func _get_sorted_touches() -> Array[TrackpadTouch]:
	touch_map.sort()
	return touch_map.values()

func get_lowest_index_available_for_touch(touch:TrackpadTouch) -> int:
	var id := _find_touch_id(touch)
	
	if id != -1: return id
	
	for i in range(0, touch_map.keys().size()):
		var touch_map_touch : TrackpadTouch = touch_map.get(i)
		if _is_touch_free(touch_map_touch):
			id = i
			return id
	
	return -1

func _initial_touch_insert(touch:TrackpadTouch) -> void:
	var id := 0
	
	touch_map.sort()
	var sorted_keys := touch_map.keys()
	
	if not sorted_keys.is_empty():
		for i in range(0, sorted_keys.back()+2):
			if not (i in sorted_keys):
				id = i
				break
	
	touch_map[id] = touch

func _update_touch(touch:TrackpadTouch) -> void:
	var id := _find_touch_id(touch)
	
	touch_map[id] = touch

func _final_touch_remove(touch:TrackpadTouch) -> void:
	var id := _find_touch_id(touch)
	touch_map.erase(id)

func _update_touch_events() -> void:
	for touch:TrackpadTouch in TrackpadServerAddon.touches_cache:
		if touch.state == TrackpadTouch.starting:
			_initial_touch_insert(touch)
		
		if touch.state == TrackpadTouch.touching:
			_update_touch(touch)
		
		if touch.state == TrackpadTouch.leaving:
			_final_touch_remove(touch)

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

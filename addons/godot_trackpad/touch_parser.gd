@tool
extends Node

# From the minimal id to the raw TrackpadTouch
#var prev_touch_map : Dictionary[int, TrackpadTouch]
var touch_map : Dictionary[int, TrackpadTouch]
var inverse_touch_map : Dictionary[int, int] # identifier -> id

func touch_get_index(touch:TrackpadTouch) -> int:
	var prev_touch := _get_touch(touch)
	if prev_touch == null: return -1
	
	return inverse_touch_map.get(prev_touch.identifier, -1)
#
#func touch_just_pressed(touch:TrackpadTouch) -> bool:
	#var index : int = touch_get_index(touch)
	#return prev_touch_map.get(index, null) == null and touch_map.get(index, null) != null
#
#func touch_just_released(touch:TrackpadTouch) -> bool:
	#var index : int = touch_get_index(touch)
	#return prev_touch_map.get(index, null) != null and touch_map.get(index, null) == null

func _ready() -> void:
	name = "TouchScreenParser"

func _process_touch(window_id:int, touch:TrackpadTouch) -> void:
	var touch_pos := _normalized_pos_to_screen(touch.normalized_position)
	
	match touch.state:
		TrackpadTouch.starting:
			var index : int = get_lowest_index_available_for_touch(touch)
			_initial_touch_insert(touch)
		
		TrackpadTouch.touching:
			var prev_touch := _get_touch(touch)
			
			# Ignore touches that began because the callback started running
			if prev_touch == null: return
			
			var prev_touch_pos := _normalized_pos_to_screen(prev_touch.normalized_position)
			
			var index : int = inverse_touch_map[prev_touch.identifier]
			
			_update_touch(touch)
			
		TrackpadTouch.leaving:
			var prev_touch := _get_touch(touch)
			
			# Ignore touches that began because the callback started running
			if prev_touch == null: return
			
			_final_touch_remove(touch)

func _initial_touch_insert(touch:TrackpadTouch) -> void:
	var index := get_lowest_index_available_for_touch(touch)
	touch_map[index] = touch
	inverse_touch_map[touch.identifier] = index

func _update_touch(touch:TrackpadTouch) -> void:
	var index := inverse_touch_map[touch.identifier]
	touch_map[index] = touch

func _final_touch_remove(touch:TrackpadTouch) -> void:
	var index := inverse_touch_map[touch.identifier]
	touch_map.erase(index)
	inverse_touch_map.erase(touch.identifier)

func _get_touch(touch:TrackpadTouch) -> TrackpadTouch:
	if inverse_touch_map.get(touch.identifier) == null: return null
	
	return touch_map[inverse_touch_map[touch.identifier]]

func get_lowest_index_available_for_touch(touch:TrackpadTouch) -> int:
	var index := 0
	
	touch_map.sort()
	var sorted_keys := touch_map.keys()
	
	if not sorted_keys.is_empty():
		for i in range(0, sorted_keys.back()+2):
			if not (i in sorted_keys):
				index = i
				break
	
	return index

func _normalized_pos_to_screen(p:Vector2) -> Vector2:
	return p

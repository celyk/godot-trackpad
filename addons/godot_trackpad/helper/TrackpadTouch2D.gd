@tool
class_name TrackpadTouch2D extends Node2D

func _process(delta: float) -> void:
	var touches := TrackpadServerAddon.touches_cache.duplicate()
	
	touches.sort_custom(func(a:TrackpadTouch, b:TrackpadTouch): return a.identifier < b.identifier)
	
	#print(touches.map(func(e): return e.id))
	
	if not touches.is_empty():
		var primary_touch : TrackpadTouch = touches.front()
		
		var device := TrackpadServer.get_primary_device()
		var size : Vector2 = TrackpadServer.device_get_digitizer_physical_size(device)
		
		position = primary_touch.normalized_position
		position.y = position.y
		position = position * size / 100
		position *= 10

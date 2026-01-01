@tool
class_name TrackpadTouch2D extends Node2D

func _process(delta: float) -> void:
	var touches := TrackpadServerAddon.touches_cache.duplicate()
	
	touches.sort_custom(func(a:OMSTouchData, b:OMSTouchData): return a.id < b.id)
	
	#print(touches.map(func(e): return e.id))
	
	if not touches.is_empty():
		var primary_touch : OMSTouchData = touches.front()
		
		var size : Vector2 = TrackpadServer.get_digitizer_physical_size()
		
		position = primary_touch.position
		position.y = 1.0 - position.y
		position = position * size / 100
		position *= 10

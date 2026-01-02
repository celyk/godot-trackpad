@tool
extends RefCounted

# Returns touches in a new sorted array of size 10, as we only care about 10 point touch
func sort_touches(touches:Array[TrackpadTouch]) -> Array[TrackpadTouch]:
	var sorted_touches : Array[TrackpadTouch]
	sorted_touches.resize(10)
	
	#sorted_touches.sort_custom(func(e:TrackpadTouch): if not e: return false)
	
	for touch in touches:
		if touch.id < sorted_touches.size():
			sorted_touches[touch.id] = touch
	
	return sorted_touches

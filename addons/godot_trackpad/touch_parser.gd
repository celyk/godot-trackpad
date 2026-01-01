@tool
extends RefCounted

# Returns touches in a new sorted array of size 10, as we only care about 10 point touch
func sort_touches(touches:Array[OMSTouchData]) -> Array[OMSTouchData]:
	var sorted_touches : Array[OMSTouchData]
	sorted_touches.resize(10)
	
	#sorted_touches.sort_custom(func(e:OMSTouchData): if not e: return false)
	
	for touch in touches:
		if touch.id < sorted_touches.size():
			sorted_touches[touch.id] = touch
	
	return sorted_touches

@tool
class_name TouchDebug extends Control

var touches : Array[OMSTouchData] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if TrackpadServerAddon.singleton:
		TrackpadServerAddon.singleton.trackpad_touch.connect(_on_touch)


func _on_touch(touch:OMSTouchData):
	touches.append(touch)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	
	#print("Sensor size: ", TrackpadServer.get_sensor_size())
	#print("Sensor physical size: ", TrackpadServer.get_sensor_physical_size() / 100.0 / 10.0)
	#print("Sensor aspect: ", TrackpadServer.get_sensor_size().aspect(), " ", TrackpadServer.get_sensor_physical_size().aspect())
	
	var aspect : float = TrackpadServer.get_sensor_physical_size().aspect()
	
	size.x = size.y * aspect
	
func _draw() -> void:
	draw_rect(Rect2(Vector2(), size), Color.BLACK)
	
	for touch in touches:
		var normalize_pos := touch.position
		normalize_pos.y = 1.0 - normalize_pos.y
		draw_circle(normalize_pos * size, 2 + touch.pressure / 40, Color.BLUE)
	
	touches.clear()

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

func _draw() -> void:
	for touch in touches:
		var normalize_pos := touch.position
		normalize_pos.y = 1.0 - normalize_pos.y
		draw_circle(normalize_pos * size, 5, Color.BLUE)
	
	touches.clear()

@tool
class_name TouchDebug extends Control

var touches : Array[OMSTouchData] = []

var draw_rect := ColorRect.new()
func _ready() -> void:
	if TrackpadServerAddon.singleton:
		TrackpadServerAddon.singleton.trackpad_touch.connect(_on_touch)
	
	add_child(draw_rect)
	draw_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	draw_rect.z_index = -1
	draw_rect.modulate = Color(0.1,0.1,0.1)
	draw_rect.material = ShaderMaterial.new()
	draw_rect.material.shader = preload("./shaders/grid_points.gdshader")
	draw_rect.material.set_shader_parameter("point_color", Color(0.3,0.3,0.3))

func _on_touch(touch:OMSTouchData):
	touches.append(touch)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	
	#print("Sensor size: ", TrackpadServer.get_sensor_size())
	#print("Sensor physical size: ", TrackpadServer.get_sensor_physical_size() / 100.0 / 10.0)
	#print("Sensor aspect: ", TrackpadServer.get_sensor_size().aspect(), " ", TrackpadServer.get_sensor_physical_size().aspect())
	
	var sensor_size := TrackpadServer.get_sensor_size()
	sensor_size = Vector2(sensor_size.y, sensor_size.x)
	
	var sensor_physical_size := TrackpadServer.get_sensor_physical_size()
	
	var physical_aspect : float = TrackpadServer.get_sensor_physical_size().aspect()
	
	size.x = physical_aspect * size.y
	
	draw_rect.material.set_shader_parameter("grid_cell_size", size / sensor_size)
	
func _draw() -> void:
	#draw_rect(Rect2(Vector2(), size), Color.BLACK)
	#draw_texture_rect(,)
	for touch in touches:
		var normalize_pos := touch.position
		normalize_pos.y = 1.0 - normalize_pos.y
		draw_circle(normalize_pos * size, 2 + touch.pressure / 40, Color.BLUE)
	
	touches.clear()

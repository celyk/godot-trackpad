@tool
class_name TrackpadDebug extends Control

var draw_rect := ColorRect.new()
func _ready() -> void:
	add_child(draw_rect)
	draw_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	draw_rect.z_index = -1
	draw_rect.modulate = Color(0.1,0.1,0.1)
	draw_rect.material = ShaderMaterial.new()
	draw_rect.material.shader = preload("../shaders/grid_points.gdshader")
	draw_rect.material.set_shader_parameter("point_color", Color(0.5,0.5,0.5))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	
	#print("Sensor size: ", TrackpadServer.get_sensor_size())
	#print("Sensor physical size: ", TrackpadServer.get_sensor_physical_size() / 100.0 / 10.0)
	#print("Sensor aspect: ", TrackpadServer.get_sensor_size().aspect(), " ", TrackpadServer.get_sensor_physical_size().aspect())
	
	var sensor_size : Vector2 = TrackpadServer.get_digitizer_resolution()
	var sensor_physical_size : Vector2 = TrackpadServer.get_digitizer_physical_size()
	
	var physical_aspect : float = TrackpadServer.get_digitizer_physical_size().aspect()
	
	size.x = physical_aspect * size.y
	
	draw_rect.material.set_shader_parameter("grid_cell_size", size / sensor_size)

func _draw() -> void:
	#draw_primitive()
	
	for touch in TrackpadServerAddon.touches_cache:
		var normalize_pos := touch.position
		normalize_pos.y = 1.0 - normalize_pos.y
		draw_circle(normalize_pos * size, (2 + touch.pressure / 40)*4, Color.BLUE)

@tool
extends Node2D

var touchscreen_emulation : Node

func _ready() -> void:
	z_index = 99

func _process(delta: float) -> void:
	queue_redraw()

var points : Array[Vector2]
func _input(event: InputEvent) -> void:
	if not (event is InputEventScreenTouch or event is InputEventScreenDrag):
		return
	
	points.append(event.position)

func _draw() -> void:
	for point in points:
		draw_circle(point, 50.0, Color.BLUE, false, 2.0, true)
	
	points.clear()

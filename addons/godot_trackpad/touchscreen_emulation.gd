@tool
extends Node

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	for touch:OMSTouchData in TrackpadServerAddon.touches_cache:
		pass

func TouchStartEvent() -> InputEvent:
	var event := InputEventScreenTouch.new()
	event.pressed = true
	return event

func TouchDragEvent() -> InputEvent:
	var event := InputEventScreenDrag.new()
	event.pressed = true
	
	perform_input(event)
	
	return event

func TouchEndEvent() -> InputEvent:
	var event := InputEventScreenTouch.new()
	event.pressed = false
	return event

func _push_input(viewport:Viewport, event:InputEvent) -> void:
	viewport.push_input(event)

func perform_input(event:InputEvent) -> void:
	Input.parse_input_event(event)

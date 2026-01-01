@tool
extends EditorPlugin

var settings = load("settings.gd").instantiate()

func _enter_tree() -> void:
	add_autoload_singleton("TrackpadServerAddon", "autoload.gd")

func _exit_tree() -> void:
	remove_autoload_singleton("TrackpadServerAddon")

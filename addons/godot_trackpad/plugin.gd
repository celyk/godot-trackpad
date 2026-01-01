@tool
extends EditorPlugin

var settings = preload("uid://0sbo77w267vf").new()

func _enter_tree() -> void:
	add_autoload_singleton("TrackpadServerAddon", "autoload.gd")

func _exit_tree() -> void:
	remove_autoload_singleton("TrackpadServerAddon")

@tool
extends Node

func _init() -> void:
	_initialize.call_deferred()

func _initialize() -> void:
	_define_project_setting(
			"godot_trackpad/input/emulate_screen_touch", 
			TYPE_BOOL, 
			PROPERTY_HINT_NONE,
			"",
			false)

func _define_project_setting(
		p_name : String,
		p_type : int,
		p_hint : int = PROPERTY_HINT_NONE,
		p_hint_string : String = "",
		p_default_val = "") -> void:
	# p_default_val can be any type!!

	if not ProjectSettings.has_setting(p_name):
		ProjectSettings.set_setting(p_name, p_default_val)

	var property_info : Dictionary = {
		"name" : p_name,
		"type" : p_type,
		"hint" : p_hint,
		"hint_string" : p_hint_string
	}

	ProjectSettings.add_property_info(property_info)
	ProjectSettings.set_as_basic(p_name, true)
	ProjectSettings.set_initial_value(p_name, p_default_val)

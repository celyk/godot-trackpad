#include "TrackpadServer.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void TrackpadServer::_bind_methods() {
	ClassDB::bind_method(D_METHOD("device_register_input_callback", "callback"), &TrackpadServer::device_register_input_callback);
	ClassDB::bind_method(D_METHOD("device_get_digitizer_resolution"), &TrackpadServer::device_get_digitizer_resolution);
	ClassDB::bind_method(D_METHOD("device_get_digitizer_physical_size"), &TrackpadServer::device_get_digitizer_physical_size);
	ClassDB::bind_method(D_METHOD("device_get_haptics_disabled"), &TrackpadServer::device_set_haptics_disabled);
	ClassDB::bind_method(D_METHOD("device_set_haptics_disabled", "disabled"), &TrackpadServer::device_set_haptics_disabled);
}

godot::TrackpadServer::TrackpadServer()
{
}

godot::TrackpadServer::~TrackpadServer()
{
}

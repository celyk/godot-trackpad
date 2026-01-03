#include "TrackpadServer.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void TrackpadServer::_bind_methods() {
	ClassDB::bind_method(D_METHOD("register_input_callback", "callback"), &TrackpadServer::register_input_callback);
	ClassDB::bind_method(D_METHOD("get_digitizer_resolution"), &TrackpadServer::get_digitizer_resolution);
	ClassDB::bind_method(D_METHOD("get_digitizer_physical_size"), &TrackpadServer::get_digitizer_physical_size);
	ClassDB::bind_method(D_METHOD("get_haptics_disabled"), &TrackpadServer::get_haptics_disabled);
	ClassDB::bind_method(D_METHOD("set_haptics_disabled", "disabled"), &TrackpadServer::set_haptics_disabled);
}

godot::TrackpadServer::TrackpadServer()
{
}

godot::TrackpadServer::~TrackpadServer()
{
}

#include "TrackpadServer.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void TrackpadServer::_bind_methods() {
	ClassDB::bind_method(D_METHOD("register_input_callback", "callback"), &TrackpadServer::registerInputCallback);
	ClassDB::bind_method(D_METHOD("get_digitizer_resolution"), &TrackpadServer::getDigitizerResolution);
	ClassDB::bind_method(D_METHOD("get_digitizer_physical_size"), &TrackpadServer::getDigitizerPhysicalSize);
	ClassDB::bind_method(D_METHOD("get_haptics_disabled"), &TrackpadServer::getHapticsDisabled);
	ClassDB::bind_method(D_METHOD("set_haptics_disabled", "disabled"), &TrackpadServer::setHapticsDisabled);
}
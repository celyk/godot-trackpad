#include "wrapper.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void TrackpadServer::_bind_methods() {
	ClassDB::bind_method(D_METHOD("register_input_callback", "callback"), &TrackpadServer::registerInputCallback);
}

void TrackpadServer::registerInputCallback(Callable callback) {

}
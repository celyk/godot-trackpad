#include "wrapper.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void TrackpadServer::_bind_methods() {
	ClassDB::bind_method(D_METHOD("register_input_callback", "callback"), &TrackpadServer::registerInputCallback);
}

TrackpadServer::TrackpadServer() {

}

void TrackpadServer::registerInputCallback(Callable callback) {

}

void OMSTouchData::_bind_methods() {
	ADD_PROPERTY(PropertyInfo(Variant::INT, "id"), "set_id", "get_id");
	ADD_PROPERTY(PropertyInfo(Variant::VECTOR2, "position"), "set_position", "get_position");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "total"), "set_total", "get_total");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "pressure"), "set_pressure", "get_pressure");
	ADD_PROPERTY(PropertyInfo(Variant::VECTOR2, "axis"), "set_axis", "get_axis");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "angle"), "set_angle", "get_angle");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "density"), "set_density", "get_density");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "state", PROPERTY_HINT_ENUM, "notTouching,starting,hovering,making,touching,breaking,lingering,leaving"), "set_state", "get_state");
	ADD_PROPERTY(PropertyInfo(Variant::STRING, "timestamp"), "set_timestamp", "get_timestamp");

	BIND_ENUM_CONSTANT(notTouching);
	BIND_ENUM_CONSTANT(starting);
	BIND_ENUM_CONSTANT(hovering);
	BIND_ENUM_CONSTANT(making);
	BIND_ENUM_CONSTANT(touching);
	BIND_ENUM_CONSTANT(breaking);
	BIND_ENUM_CONSTANT(lingering);
	BIND_ENUM_CONSTANT(leaving);
}


int OMSTouchData::get_id() const {
    return id;
}
void OMSTouchData::set_id(int p_id) {	
	id = p_id;
}

Vector2 OMSTouchData::get_position() const {
    return position;
}
void OMSTouchData::set_position(Vector2 p_position) {
    position = p_position;
}

float OMSTouchData::get_total() const {
    return total;
}
void OMSTouchData::set_total(float p_total) {
    total = p_total;
}

float OMSTouchData::get_pressure() const {
    return pressure;
}
void OMSTouchData::set_pressure(float p_pressure) {
    pressure = p_pressure;
}

Vector2 OMSTouchData::get_axis() const {
    return axis;
}
void OMSTouchData::set_axis(Vector2 p_axis) {
    axis = p_axis;
}

float OMSTouchData::get_angle() const {
    return angle;
}
void OMSTouchData::set_angle(float p_angle) {
    angle = p_angle;
}

float OMSTouchData::get_density() const {
    return density;
}
void OMSTouchData::set_density(float p_density) {
    density = p_density;
}

OMSTouchData::OMSState OMSTouchData::get_state() const {
    return state;
}
void OMSTouchData::set_state(OMSTouchData::OMSState p_state) {
    state = p_state;
}

String OMSTouchData::get_timestamp() const {
    return timestamp;
}
void OMSTouchData::set_timestamp(String p_timestamp) {
    timestamp = p_timestamp;
}

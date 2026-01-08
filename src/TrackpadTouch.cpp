#include "TrackpadTouch.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void TrackpadTouch::_bind_methods() {
	ClassDB::bind_method(D_METHOD("get_identifier"), &TrackpadTouch::get_identifier);
	ClassDB::bind_method(D_METHOD("set_identifier", "identifier"), &TrackpadTouch::set_identifier);
	ClassDB::bind_method(D_METHOD("get_position"), &TrackpadTouch::get_position);
	ClassDB::bind_method(D_METHOD("set_position", "position"), &TrackpadTouch::set_position);
	ClassDB::bind_method(D_METHOD("get_normalized_position"), &TrackpadTouch::get_normalized_position);
	ClassDB::bind_method(D_METHOD("set_normalized_position", "position"), &TrackpadTouch::set_normalized_position);
	ClassDB::bind_method(D_METHOD("get_total"), &TrackpadTouch::get_total);
	ClassDB::bind_method(D_METHOD("set_total", "total"), &TrackpadTouch::set_total);
	ClassDB::bind_method(D_METHOD("get_pressure"), &TrackpadTouch::get_pressure);
	ClassDB::bind_method(D_METHOD("set_pressure", "pressure"), &TrackpadTouch::set_pressure);
	ClassDB::bind_method(D_METHOD("get_axis"), &TrackpadTouch::get_axis);
	ClassDB::bind_method(D_METHOD("set_axis", "axis"), &TrackpadTouch::set_axis);
	ClassDB::bind_method(D_METHOD("get_angle"), &TrackpadTouch::get_angle);
	ClassDB::bind_method(D_METHOD("set_angle", "angle"), &TrackpadTouch::set_angle);
	ClassDB::bind_method(D_METHOD("get_density"), &TrackpadTouch::get_density);
	ClassDB::bind_method(D_METHOD("set_density", "density"), &TrackpadTouch::set_density);
	ClassDB::bind_method(D_METHOD("get_state"), &TrackpadTouch::get_state);
	ClassDB::bind_method(D_METHOD("set_state", "state"), &TrackpadTouch::set_state);
	ClassDB::bind_method(D_METHOD("get_timestamp"), &TrackpadTouch::get_timestamp);
	ClassDB::bind_method(D_METHOD("set_timestamp", "timestamp"), &TrackpadTouch::set_timestamp);

	ADD_PROPERTY(PropertyInfo(Variant::INT, "identifier"), "set_identifier", "get_identifier");
	ADD_PROPERTY(PropertyInfo(Variant::VECTOR2, "position"), "set_position", "get_position");
	ADD_PROPERTY(PropertyInfo(Variant::VECTOR2, "normalized_position"), "set_normalized_position", "get_normalized_position");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "total"), "set_total", "get_total");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "pressure"), "set_pressure", "get_pressure");
	ADD_PROPERTY(PropertyInfo(Variant::VECTOR2, "axis"), "set_axis", "get_axis");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "angle"), "set_angle", "get_angle");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "density"), "set_density", "get_density");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "state", PROPERTY_HINT_ENUM, "notTouching,starting,hovering,making,touching,breaking,lingering,leaving"), "set_state", "get_state");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "timestamp"), "set_timestamp", "get_timestamp");

	BIND_ENUM_CONSTANT(notTouching);
	BIND_ENUM_CONSTANT(starting);
	BIND_ENUM_CONSTANT(hovering);
	BIND_ENUM_CONSTANT(making);
	BIND_ENUM_CONSTANT(touching);
	BIND_ENUM_CONSTANT(breaking);
	BIND_ENUM_CONSTANT(lingering);
	BIND_ENUM_CONSTANT(leaving);
}


int TrackpadTouch::get_identifier() const {
    return identifier;
}
void TrackpadTouch::set_identifier(int p_identifier) {	
	identifier = p_identifier;
}

Vector2 TrackpadTouch::get_position() const {
    return position;
}
void TrackpadTouch::set_position(Vector2 p_position) {
    position = p_position;
}

Vector2 TrackpadTouch::get_normalized_position() const {
    return normalized_position;
}
void TrackpadTouch::set_normalized_position(Vector2 p_position) {
    normalized_position = p_position;
}

float TrackpadTouch::get_total() const {
    return total;
}
void TrackpadTouch::set_total(float p_total) {
    total = p_total;
}

float TrackpadTouch::get_pressure() const {
    return pressure;
}
void TrackpadTouch::set_pressure(float p_pressure) {
    pressure = p_pressure;
}

Vector2 TrackpadTouch::get_axis() const {
    return axis;
}
void TrackpadTouch::set_axis(Vector2 p_axis) {
    axis = p_axis;
}

float TrackpadTouch::get_angle() const {
    return angle;
}
void TrackpadTouch::set_angle(float p_angle) {
    angle = p_angle;
}

float TrackpadTouch::get_density() const {
    return density;
}
void TrackpadTouch::set_density(float p_density) {
    density = p_density;
}

TrackpadTouch::TouchState TrackpadTouch::get_state() const {
    return state;
}
void TrackpadTouch::set_state(TrackpadTouch::TouchState p_state) {
    state = p_state;
}

double TrackpadTouch::get_timestamp() const {
    return timestamp;
}
void TrackpadTouch::set_timestamp(double p_timestamp) {
    timestamp = p_timestamp;
}

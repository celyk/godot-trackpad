#include "wrapper.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void TrackpadServer::_bind_methods() {
	ClassDB::bind_method(D_METHOD("register_input_callback", "callback"), &TrackpadServer::registerInputCallback);
}

void TrackpadServer::registerInputCallback(Callable callback) {

}

void OMSTouchData::_bind_methods() {
	ADD_PROPERTY(PropertyInfo(Variant::INT, "id"), "set_id", "get_id");
	ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "position"), "set_id", "get_id");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "total"), "set_id", "get_id");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "pressure"), "set_id", "get_id");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "axis"), "set_id", "get_id");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "angle"), "set_id", "get_id");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "density"), "set_id", "get_id");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "state"), "set_id", "get_id");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "timestamp"), "set_id", "get_id");
}


int OMSTouchData::get_id() const
{
    return id;
}
void OMSTouchData::set_id(int p_id)
{	
	id = p_id;
}

Vector2 OMSTouchData::get_position() const
{
    return position;
}

float OMSTouchData::get_total() const
{
    return total;
}

float OMSTouchData::get_pressure() const
{
    return pressure;
}

Vector2 OMSTouchData::get_axis() const
{
    return axis;
}

float OMSTouchData::get_angle() const
{
    return angle;
}

float OMSTouchData::get_density() const
{
    return density;
}

int OMSTouchData::get_state() const
{
    return state;
}

String OMSTouchData::get_timestamp() const
{
    return timestamp;
}

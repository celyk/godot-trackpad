#pragma once

//#include <godot_cpp/core/version.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/mutex_lock.hpp>
#include <godot_cpp/classes/ref.hpp>

namespace godot{

class TrackpadTouch : public RefCounted {
	GDCLASS(TrackpadTouch, RefCounted);

public:
	enum TouchState {
        notTouching,
        starting,
        hovering,
        making,
        touching,
        breaking,
        lingering,
        leaving
	};

private:
    int identifier; //: Int32
    Vector2 position;
    Vector2 normalized_position;
    float total; // total value of capacitance
    float pressure;
    Vector2 axis;
    float angle; // finger angle
    float density; // area density of capacitance
    TouchState state;
    double timestamp;

protected:
	static void _bind_methods();

public:
    int get_identifier() const;
    void set_identifier(int p_identifier);
    
    Vector2 get_position() const;
    void set_position(Vector2 p_position);

    Vector2 get_normalized_position() const;
    void set_normalized_position(Vector2 p_position);
    
    float get_total() const;
    void set_total(float p_total);
    
    float get_pressure() const;
    void set_pressure(float p_pressure);

    Vector2 get_axis() const;
    void set_axis(Vector2 p_axis);

    float get_angle() const;
    void set_angle(float p_angle);

    float get_density() const;
    void set_density(float p_density);

    TouchState get_state() const;
    void set_state(TouchState p_state);

    double get_timestamp() const;
    void set_timestamp(double p_timestamp);
};

}

VARIANT_ENUM_CAST(godot::TrackpadTouch::TouchState);

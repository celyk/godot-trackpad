#ifndef TRACKPAD_WRAPPER_H
#define TRACKPAD_WRAPPER_H

//#include <godot_cpp/core/version.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/classes/ref.hpp>

namespace godot{

/*
enum OMSState: String, Sendable {
    case notTouching
    case starting
    case hovering
    case making
    case touching
    case breaking
    case lingering
    case leaving
}
*/

class OMSTouchData : public RefCounted {
	GDCLASS(OMSTouchData, RefCounted);

    int id; //: Int32
    Vector2 position;
    float total; // total value of capacitance
    float pressure;
    Vector2 axis;
    float angle; // finger angle
    float density; // area density of capacitance
    int state; //: OMSState
    String timestamp;

protected:
	static void _bind_methods();

public:
    int get_id() const;
    void set_id(int p_id);
    
    Vector2 get_position() const;
    void set_position(int p_position);
    
    float get_total() const;
    void set_total(float p_total);
    
    float get_pressure() const;
    float set_pressure(float p_pressure);

    Vector2 get_axis() const;
    void set_axis(Vector2 p_axis);

    float get_angle() const;
    void set_angle(float p_angle);

    float get_density() const;
    void set_density(float p_density);

    int get_state() const;
    void set_state(int p_state);

    String get_timestamp() const;
    void set_timestamp(String p_timestamp);
};


class TrackpadServer : public Object {
	GDCLASS(TrackpadServer, Object);

private:

protected:
	static void _bind_methods();

public:
    TrackpadServer(){}
    ~TrackpadServer(){}

    void registerInputCallback(Callable callback);
};

}

#endif /* !TRACKPAD_WRAPPER_H */

#pragma once

//#include <godot_cpp/core/version.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/mutex_lock.hpp>
#include <godot_cpp/classes/ref.hpp>

#include "TrackpadTouch.h"

namespace godot{

class TrackpadServer : public Object {
	GDCLASS(TrackpadServer, Object);
    //_THREAD_SAFE_CLASS_

protected:
	static void _bind_methods();

    Callable primary_touch_callback;

    bool haptics_disabled = false;

public:
    TrackpadServer();
    virtual ~TrackpadServer();

    virtual void handle_touch_event(Ref<TrackpadTouch> event) { }
    virtual void register_input_callback(Callable callback) { }
    
    virtual Vector2i get_digitizer_resolution() { return Vector2i(); }
    virtual Vector2i get_digitizer_physical_size() { return Vector2i(); }

    virtual bool get_haptics_disabled() { return true; }
    virtual Error set_haptics_disabled(bool disable) { return FAILED; }
};


}

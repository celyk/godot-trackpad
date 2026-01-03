#pragma once

//#include <godot_cpp/core/version.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/mutex_lock.hpp>
#include <godot_cpp/classes/ref.hpp>

#include "TrackpadTouch.h"

namespace godot{

typedef int TrackpadDeviceID;

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

    //virtual void handle_touch_event(Ref<TrackpadTouch> event) { }
    virtual void register_input_callback(Callable callback) { }

    virtual Vector2i get_digitizer_resolution() { return Vector2i(); }
    virtual Vector2i get_digitizer_physical_size() { return Vector2i(); }


    // TrackpadServer.get_primary_device() -> int
    // TrackpadServer.get_device_list() -> Array[int]

    // TrackpadServer.device_get_digitizer_resolution(device_id:int) -> Vector2i
    // TrackpadServer.device_get_digitizer_physical_size(device_id:int) -> Vector2i

    // TrackpadServer.device_get_haptics_disabled(device_id:int) -> bool
    // TrackpadServer.device_set_haptics_disabled(device_id:int, disabled:bool) -> void

    // TrackpadServer.device_register_input_callback(device_id:int, callback:Callable) -> void

    
    virtual bool device_is_haptics_available(TrackpadDeviceID device_id) { return false; }
    virtual bool get_haptics_disabled() { return true; }
    virtual Error set_haptics_disabled(bool disable) { return FAILED; }

};


}

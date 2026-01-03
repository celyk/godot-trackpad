#pragma once

//#include <godot_cpp/core/version.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/mutex_lock.hpp>
#include <godot_cpp/classes/ref.hpp>
#include <godot_cpp/variant/array.hpp>

#include "TrackpadTouch.h"

namespace godot{

typedef int TrackpadDeviceID;

class TrackpadServer : public Object {
	GDCLASS(TrackpadServer, Object);
    //_THREAD_SAFE_CLASS_

protected:
	static void _bind_methods();

    bool haptics_disabled = false;

public:
    TrackpadServer();
    virtual ~TrackpadServer();

    virtual TrackpadDeviceID get_primary_device() { return -1; }
    virtual TypedArray<TrackpadDeviceID> get_device_list() { return TypedArray<TrackpadDeviceID>(); }

    virtual void device_register_input_callback(TrackpadDeviceID device_id, Callable callback) { }

    virtual Vector2i device_get_digitizer_resolution(TrackpadDeviceID device_id) { return Vector2i(); }
    virtual Vector2i device_get_digitizer_physical_size(TrackpadDeviceID device_id) { return Vector2i(); }

    virtual bool device_is_haptics_available(TrackpadDeviceID device_id) { return false; }
    virtual bool device_get_haptics_disabled(TrackpadDeviceID device_id) { return false; }
    virtual Error device_set_haptics_disabled(TrackpadDeviceID device_id, bool disable) { return FAILED; }
};


}

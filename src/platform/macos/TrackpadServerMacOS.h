#pragma once

//#include <godot_cpp/core/version.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/mutex_lock.hpp>
#include <godot_cpp/classes/ref.hpp>


#include "../../TrackpadServer.h"

// Forward declaration of the Objective-C class
#ifdef __OBJC__
@class MyObjCClass;
#else
class MyObjCClass;
#endif

namespace godot{

class TrackpadServerMacOS : public TrackpadServer {
    GDCLASS(TrackpadServerMacOS, TrackpadServer);
	//GDSOFTCLASS(TrackpadServerMacOS, TrackpadServer);

private:
    MyObjCClass* objc_wrapper;
    //friend class MyObjCClass;

    TrackpadDeviceID primary_device = -1;
    TypedArray<TrackpadDeviceID> device_list;

    Callable primary_touch_callback;
    
public:
    void handle_touch_event(Ref<TrackpadTouch> event);

protected:
	static void _bind_methods() {};

public:
    TrackpadServerMacOS();
    ~TrackpadServerMacOS();

    // static TrackpadServer* singleton;
    // static TrackpadServer* get_singleton() { return singleton; }
    
    virtual TrackpadDeviceID get_primary_device() override { return primary_device; }
    virtual TypedArray<TrackpadDeviceID> get_device_list() override { return device_list; }

    virtual void device_register_input_callback(TrackpadDeviceID device_id, Callable callback) override;

    virtual Vector2i device_get_digitizer_resolution(TrackpadDeviceID device_id) override;
    virtual Vector2i device_get_digitizer_physical_size(TrackpadDeviceID device_id) override;

    virtual bool device_is_haptics_available(TrackpadDeviceID device_id) override { return true; }
    virtual bool device_get_haptics_disabled(TrackpadDeviceID device_id) override;
    virtual Error device_set_haptics_disabled(TrackpadDeviceID device_id, bool disable) override;
};


}

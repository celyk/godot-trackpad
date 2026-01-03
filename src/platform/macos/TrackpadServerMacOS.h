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

public:
    void handle_touch_event(Ref<TrackpadTouch> event);

protected:
	static void _bind_methods() {};

public:
    TrackpadServerMacOS();
    ~TrackpadServerMacOS();

    virtual void register_input_callback(Callable callback) override;
    
    virtual Vector2i get_digitizer_resolution() override;
    virtual Vector2i get_digitizer_physical_size() override;

    virtual bool get_haptics_disabled() override;
    virtual Error set_haptics_disabled(bool disable) override;
};


}

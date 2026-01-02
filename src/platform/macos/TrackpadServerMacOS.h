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

    Callable touch_callback;

    bool haptics_disabled = false;

protected:
	static void _bind_methods() {};

public:
    TrackpadServerMacOS();
    ~TrackpadServerMacOS();

    void handle_touch_event(Ref<TrackpadTouch> event) override;
    void registerInputCallback(Callable callback) override;
    Vector2i getDigitizerResolution() override;
    Vector2i getDigitizerPhysicalSize() override;
    bool getHapticsDisabled() override;
    Error setHapticsDisabled(bool disable) override;
};


}

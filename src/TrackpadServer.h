#pragma once

//#include <godot_cpp/core/version.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/mutex_lock.hpp>
#include <godot_cpp/classes/ref.hpp>

//#include "TrackpadTouch.h"
class TrackpadTouch;

namespace godot{

class TrackpadServer : public Object {
	GDCLASS(TrackpadServer, Object);
    //_THREAD_SAFE_CLASS_

private:
    Callable touch_callback;

    bool haptics_disabled = false;

protected:
	static void _bind_methods();

public:
    //virtual TrackpadServer();
    //virtual ~TrackpadServer();

    virtual void handle_touch_event(Ref<TrackpadTouch> event) = 0;
    virtual void registerInputCallback(Callable callback) = 0;
    virtual Vector2i getDigitizerResolution() = 0;
    virtual Vector2i getDigitizerPhysicalSize();
    virtual bool getHapticsDisabled();
    virtual Error setHapticsDisabled(bool disable);
};


}

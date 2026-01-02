#pragma once

//#include <godot_cpp/core/version.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/mutex_lock.hpp>
#include <godot_cpp/classes/ref.hpp>

#include "TrackpadTouch.h"
//class TrackpadTouch;

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
    TrackpadServer();//{}
    //~TrackpadServer(){}
    virtual ~TrackpadServer();// {}

    virtual void handle_touch_event(Ref<TrackpadTouch> event) { }
    virtual void registerInputCallback(Callable callback) { }
    virtual Vector2i getDigitizerResolution() { return Vector2i(); }
    virtual Vector2i getDigitizerPhysicalSize() { return Vector2i(); }
    virtual bool getHapticsDisabled() { return true; }
    virtual Error setHapticsDisabled(bool disable) { return FAILED; }
};


}

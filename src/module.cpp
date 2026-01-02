#include "module.h"

#include <godot_cpp/core/version.hpp>
#include <godot_cpp/core/class_db.hpp>
//#include <godot_cpp/godot.hpp>
#include <godot_cpp/classes/engine.hpp>


#include "TrackpadServer.h"

// Platform dependent headers
#if defined(MACOS_ENABLED)
#include "platform/macos/TrackpadServerMacOS.h"
#endif

#if defined(LINUX_ENABLED)
#endif

#if defined(WINDOWS_ENABLED)
#endif


using namespace godot;

void register_types() {
    GDREGISTER_CLASS(TrackpadTouch);
	GDREGISTER_ABSTRACT_CLASS(TrackpadServer);

#if defined(MACOS_ENABLED)
    GDREGISTER_INTERNAL_CLASS(TrackpadServerMacOS);
	TrackpadServer* trackpad_singleton = memnew(TrackpadServerMacOS);
#endif

#if defined(LINUX_ENABLED)
    GDREGISTER_INTERNAL_CLASS(TrackpadServerLinux);
	TrackpadServer* trackpad_singleton = memnew(TrackpadServerLinux);
#endif

#if defined(WINDOWS_ENABLED)
    GDREGISTER_INTERNAL_CLASS(TrackpadServerWindows);
	TrackpadServer* trackpad_singleton = memnew(TrackpadServerWindows);
#endif

	Engine::get_singleton()->register_singleton("TrackpadServer", trackpad_singleton);
}

void unregister_types() {
	Engine::get_singleton()->unregister_singleton("TrackpadServer");
	//memdelete(link_singleton);
}

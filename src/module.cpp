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
    if (ClassDB::class_exists("TrackpadServer")){ return; }

    GDREGISTER_CLASS(TrackpadTouch);
	GDREGISTER_ABSTRACT_CLASS(TrackpadServer);

#if defined(MACOS_ENABLED)
    GDREGISTER_INTERNAL_CLASS(TrackpadServerMacOS);
	TrackpadServer::singleton = memnew(TrackpadServerMacOS);
#endif

#if defined(LINUX_ENABLED)
    GDREGISTER_INTERNAL_CLASS(TrackpadServerLinux);
	TrackpadServer::singleton = memnew(TrackpadServerLinux);
#endif

#if defined(WINDOWS_ENABLED)
    GDREGISTER_INTERNAL_CLASS(TrackpadServerWindows);
	TrackpadServer::singleton = memnew(TrackpadServerWindows);
#endif

	Engine::get_singleton()->register_singleton("TrackpadServer", TrackpadServer::get_singleton());
}

void unregister_types() {
    if (Engine::get_singleton()->has_singleton("TrackpadServer")){
	    Engine::get_singleton()->unregister_singleton("TrackpadServer");
    }

	if (TrackpadServer::singleton) {
        memdelete(TrackpadServer::singleton);
        TrackpadServer::singleton = nullptr;
    }
}

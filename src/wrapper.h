#ifndef TRACKPAD_WRAPPER_H
#define TRACKPAD_WRAPPER_H

//#include <godot_cpp/core/version.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot{

class TrackpadServer : public Object {
	GDCLASS(TrackpadServer, Object);

private:

protected:
	static void _bind_methods();

public:
    TrackpadServer(){}
    ~TrackpadServer(){}

    void registerInputCallback(Callable callback);
};

}

#endif /* !TRACKPAD_WRAPPER_H */

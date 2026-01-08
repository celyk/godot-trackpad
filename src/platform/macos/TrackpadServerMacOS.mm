#include "TrackpadServerMacOS.h"

#include <godot_cpp/core/class_db.hpp>

#import <OpenMultitouchSupportXCF/OpenMultitouchSupportXCF.h>

#include "MultitouchSupportHeader.h"

using namespace godot;


// --- Interface ---
@interface MyObjCClass : NSObject {
@public
	TrackpadServerMacOS* cppInstance; // Pointer to the C++ class
	MTDeviceRef device;
}
- (void)handleMultitouchEvent:(OpenMTEvent *)event;
@end

// --- Implementation ---
@implementation MyObjCClass
- (void)handleMultitouchEvent:(OpenMTEvent *)event {
	for (OpenMTTouch* touch in event.touches){
		Vector2i digitizer_resolution = cppInstance->device_get_digitizer_resolution(cppInstance->get_primary_device());

		Ref<TrackpadTouch> godot_event;
		godot_event.instantiate();

		godot_event->set_identifier(int(touch.identifier));
		godot_event->set_position(Vector2(touch.posX, touch.posY) * Vector2(digitizer_resolution));
		godot_event->set_normalized_position(Vector2(touch.posX, touch.posY));
		godot_event->set_total(float(touch.total));
		godot_event->set_pressure(float(touch.pressure));
		godot_event->set_axis(Vector2(touch.minorAxis, touch.majorAxis));
		godot_event->set_angle(float(touch.angle));
		godot_event->set_density(float(touch.density));
		godot_event->set_state((TrackpadTouch::TouchState)touch.state);
		godot_event->set_timestamp(touch.timestamp);

		cppInstance->handle_touch_event(godot_event);
	}
}

@end


void TrackpadServerMacOS::handle_touch_event(Ref<TrackpadTouch> event) {
	for (int i = 0; i < primary_touch_callbacks.size(); i ++){
		Callable primary_touch_callback = primary_touch_callbacks[i];

		if(primary_touch_callback.is_null()) {
			continue;
		}

		primary_touch_callback.call(event);
	}
}

TrackpadServerMacOS::TrackpadServerMacOS() {
	objc_wrapper = [[MyObjCClass alloc] init];
    objc_wrapper->cppInstance = this; // OR: [objc_wrapper setCppInstance:this];
	
	if (MTDeviceIsAvailable()) {
		MTDeviceRef device = MTDeviceCreateDefault(); //manager.device;
		objc_wrapper->device = device;
	}


    // The manager starts working as soon as you add a listener
	OpenMTManager* manager = OpenMTManager.sharedManager;
    [manager addListenerWithTarget:objc_wrapper selector:@selector(handleMultitouchEvent:)];
}

TrackpadServerMacOS::~TrackpadServerMacOS() {
	MTDeviceRef device = objc_wrapper->device;
	
	// We're responsible for releasing the device handle.
	CFRelease(device);

	[objc_wrapper release];
	objc_wrapper = nil;
}

void TrackpadServerMacOS::device_register_input_callback(TrackpadDeviceID device_id, Callable callback) {	
	for (int i = 0; i < primary_touch_callbacks.size(); i ++) {
		primary_touch_callbacks.append(callback);
	}
}

void TrackpadServerMacOS::device_unregister_input_callback(TrackpadDeviceID device_id, Callable callback) {
	primary_touch_callbacks.erase(callback);
}

Vector2i TrackpadServerMacOS::device_get_digitizer_resolution(TrackpadDeviceID device_id) {
	MTDeviceRef device = objc_wrapper->device;
	
	if (!device){
		return Vector2i(0, 0);
	}

	int rows, cols;
	OSStatus err = MTDeviceGetSensorDimensions(device, &rows, &cols);

	if (err != noErr) {
		NSLog(@"ERROR Dimensions: %d x %d ", cols, rows);
		return Vector2i(0, 0);
	}

	// Cols should come first because it gives how many lines along the x axis.
	return Vector2i(cols, rows);

}

// width and height are returned in hundreds of mm
Vector2i TrackpadServerMacOS::device_get_digitizer_physical_size(TrackpadDeviceID device_id) {
	MTDeviceRef device = objc_wrapper->device;
	
	if (!device){
		return Vector2i(0, 0);
	}

	int width, height;
	OSStatus err = MTDeviceGetSensorSurfaceDimensions(device, &width, &height);

	if (err != noErr) {
		NSLog(@"ERROR Surface Dimensions: %d x %d ", width, height);
		return Vector2i(0, 0);
	}

	return Vector2i(width, height);
}

bool TrackpadServerMacOS::device_get_haptics_disabled(TrackpadDeviceID device_id) {
	return haptics_disabled;
}

Error TrackpadServerMacOS::device_set_haptics_disabled(TrackpadDeviceID device_id, bool disable) {
	MTDeviceRef device = objc_wrapper->device;
	
	if (!device){
		return FAILED;
	}

	void* actuator = MTDeviceGetMTActuator(device);
    if (actuator == nullptr) {
		return FAILED;
	}

	int result = MTActuatorSetSystemActuationsEnabled(actuator, disable ? 0 : 1);
	if (result == 0) {
		NSLog(@"Trackpad haptics successfully %@", disable ? @"disabled" : @"enabled");
	} else {
		NSLog(@"Failed to toggle trackpad haptics. Error code: %d", result);
	}

	haptics_disabled = disable;

	return OK;
}
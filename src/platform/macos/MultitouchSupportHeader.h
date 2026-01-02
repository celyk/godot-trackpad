#ifndef MultitouchSupport_h
#define MultitouchSupport_h

#ifdef __cplusplus
extern "C" {
#endif

#import "OpenMTInternal.h"

// Haptic control functions
typedef void *MTActuatorRef;
MTActuatorRef MTDeviceGetMTActuator(MTDeviceRef device);
bool MTActuatorGetSystemActuationsEnabled(MTActuatorRef actuator);
OSStatus MTActuatorSetSystemActuationsEnabled(MTActuatorRef actuator, bool enabled);

// HapticKey-style haptic control (working implementation)
CFTypeRef MTActuatorCreateFromDeviceID(UInt64 deviceID);
IOReturn MTActuatorOpen(CFTypeRef actuatorRef);
IOReturn MTActuatorClose(CFTypeRef actuatorRef);
IOReturn MTActuatorActuate(CFTypeRef actuatorRef, SInt32 actuationID, UInt32 unknown1, Float32 unknown2, Float32 unknown3);
bool MTActuatorIsOpen(CFTypeRef actuatorRef);

// Haptic patterns and intensities
typedef enum {
    MTHapticIntensityWeak = 3,
    MTHapticIntensityMedium = 4,
    MTHapticIntensityStrong = 6
} MTHapticIntensity;

typedef enum {
    MTHapticPatternGeneric = 15,
    MTHapticPatternAlignment = 16,
    MTHapticPatternLevel = 17
} MTHapticPattern;

#ifdef __cplusplus
}
#endif

#endif /* MultitouchSupport_h */
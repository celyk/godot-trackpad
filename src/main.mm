/**
 * Copyright (C) 2023 Gil Barbosa Reis.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the “Software”), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "module.h"

#include <godot_cpp/godot.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/classes/engine.hpp>

#include <gdextension_interface.h>

#import <OpenMultitouchSupportXCF/OpenMultitouchSupportXCF.h>

using namespace godot;

// --- Interface ---
@interface TouchHandler : NSObject
- (void)handleMultitouchEvent:(OpenMTEvent *)event;
@end

// --- Implementation ---
@implementation TouchHandler
- (void)handleMultitouchEvent:(OpenMTEvent *)event {
    // This is where your touch data comes in!
    NSLog(@"Touch received from OpenMultitouchSupport!");
}
@end

OpenMTManager* manager;

// Global or static variable to keep the handler alive in memory
static TouchHandler *myTouchHandler = nil;

static void initialize(ModuleInitializationLevel level) {
	if (level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}

	register_types();


	// 1. Create the instance of your handler class
	myTouchHandler = [[TouchHandler alloc] init];

	manager = OpenMTManager.sharedManager;

    NSLog(@"initialize from gdextension!");

    // Use the correct method from your .h file
    //OpenMTManager *manager = [OpenMTManager sharedManager];
    
    // The manager starts working as soon as you add a listener
    [manager addListenerWithTarget:myTouchHandler selector:@selector(handleMultitouchEvent:)];
}

static void terminate(ModuleInitializationLevel level) {
	if (level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}

	unregister_types();
}

extern "C" GDExtensionBool GDE_EXPORT objcgdextension_entrypoint(
	GDExtensionInterfaceGetProcAddress p_getprocaccess,
	GDExtensionClassLibraryPtr p_library,
	GDExtensionInitialization *r_initialization
) {
	GDExtensionBinding::InitObject init_obj(p_getprocaccess, p_library, r_initialization);

	init_obj.register_initializer(&initialize);
	init_obj.register_terminator(&terminate);
	init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

	return init_obj.init();
}

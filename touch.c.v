// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_touch.h
//

// SDL offers touch input, on platforms that support it. It can manage
// multiple touch devices and track multiple fingers on those devices.
//
// Touches are mostly dealt with through the event system, in the
// SDL_EVENT_FINGER_DOWN, SDL_EVENT_FINGER_MOTION, and SDL_EVENT_FINGER_UP
// events, but there are also functions to query for hardware details, etc.
//
// The touch system, by default, will also send virtual mouse events; this can
// be useful for making a some desktop apps work on a phone without
// significant changes. For apps that care about mouse and touch input
// separately, they should ignore mouse events that have a `which` field of
// SDL_TOUCH_MOUSEID.

// A unique ID for a touch device.
//
// This ID is valid for the time the device is connected to the system, and is
// never reused for the lifetime of the application.
//
// The value 0 is an invalid ID.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type TouchID = u64

// A unique ID for a single finger on a touch device.
//
// This ID is valid for the time the finger (stylus, etc) is touching and will
// be unique for all fingers currently in contact, so this ID tracks the
// lifetime of a single continuous touch. This value may represent an index, a
// pointer, or some other unique ID, depending on the platform.
//
// The value 0 is an invalid ID.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type FingerID = u64

// TouchDeviceType is C.SDL_TouchDeviceType
pub enum TouchDeviceType {
	invalid           = C.SDL_TOUCH_DEVICE_INVALID           // -1,
	direct            = C.SDL_TOUCH_DEVICE_DIRECT            // `direct` touch screen with window-relative coordinates
	indirect_absolute = C.SDL_TOUCH_DEVICE_INDIRECT_ABSOLUTE // `indirect_absolute` trackpad with absolute device coordinates
	indirect_relative = C.SDL_TOUCH_DEVICE_INDIRECT_RELATIVE // `indirect_relative` trackpad with screen cursor-relative coordinates
}

@[typedef]
pub struct C.SDL_Finger {
pub mut:
	id       FingerID // the finger ID
	x        f32      // the x-axis location of the touch event, normalized (0...1)
	y        f32      // the y-axis location of the touch event, normalized (0...1)
	pressure f32      // the quantity of pressure applied, normalized (0...1)
}

pub type Finger = C.SDL_Finger

pub const touch_mouseid = C.SDL_TOUCH_MOUSEID // ((SDL_MouseID)-1)

pub const mouse_touchid = C.SDL_MOUSE_TOUCHID // ((SDL_TouchID)-1)

// C.SDL_GetTouchDevices [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTouchDevices)
fn C.SDL_GetTouchDevices(count &int) &TouchID

// get_touch_devices gets a list of registered touch devices.
//
// On some platforms SDL first sees the touch device if it was actually used.
// Therefore the returned list might be empty, although devices are available.
// After using all devices at least once the number will be correct.
//
// `count` count a pointer filled in with the number of devices returned, may
//              be NULL.
// returns a 0 terminated array of touch device IDs or NULL on failure; call
//          SDL_GetError() for more information. This should be freed with
//          SDL_free() when it is no longer needed.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_touch_devices(count &int) &TouchID {
	return C.SDL_GetTouchDevices(count)
}

// C.SDL_GetTouchDeviceName [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTouchDeviceName)
fn C.SDL_GetTouchDeviceName(touch_id TouchID) &char

// get_touch_device_name gets the touch device name as reported from the driver.
//
// `touch_id` touchID the touch device instance ID.
// returns touch device name, or NULL on failure; call SDL_GetError() for
//          more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_touch_device_name(touch_id TouchID) &char {
	return &char(C.SDL_GetTouchDeviceName(touch_id))
}

// C.SDL_GetTouchDeviceType [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTouchDeviceType)
fn C.SDL_GetTouchDeviceType(touch_id TouchID) TouchDeviceType

// get_touch_device_type gets the type of the given touch device.
//
// `touch_id` touchID the ID of a touch device.
// returns touch device type.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_touch_device_type(touch_id TouchID) TouchDeviceType {
	return C.SDL_GetTouchDeviceType(touch_id)
}

// C.SDL_GetTouchFingers [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTouchFingers)
fn C.SDL_GetTouchFingers(touch_id TouchID, count &int) &&C.SDL_Finger

// get_touch_fingers gets a list of active fingers for a given touch device.
//
// `touch_id` touchID the ID of a touch device.
// `count` count a pointer filled in with the number of fingers returned, can
//              be NULL.
// returns a NULL terminated array of SDL_Finger pointers or NULL on failure;
//          call SDL_GetError() for more information. This is a single
//          allocation that should be freed with SDL_free() when it is no
//          longer needed.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_touch_fingers(touch_id TouchID, count &int) &&C.SDL_Finger {
	return C.SDL_GetTouchFingers(touch_id, count)
}

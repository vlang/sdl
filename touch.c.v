// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_touch.h
//

// `typedef Sint64 SDL_TouchID;`
pub type TouchID = i64

// `typedef Sint64 SDL_FingerID;`
pub type FingerID = i64

pub const (
	// Used as the device ID for mouse events simulated with touch input
	touch_mouseid  = C.SDL_TOUCH_MOUSEID // ((Uint32)-1)
	// Used as the SDL_TouchID for touch events simulated with mouse input
	mouse_touch_id = C.SDL_MOUSE_TOUCHID // ((Sint64)-1)
)

// TouchDeviceType is C.SDL_TouchDeviceType
pub enum TouchDeviceType {
	invalid = C.SDL_TOUCH_DEVICE_INVALID // -1
	direct = C.SDL_TOUCH_DEVICE_DIRECT // touch screen with window-relative coordinates
	indirect_absolute = C.SDL_TOUCH_DEVICE_INDIRECT_ABSOLUTE // trackpad with absolute device coordinates
	indirect_relative = C.SDL_TOUCH_DEVICE_INDIRECT_RELATIVE // trackpad with screen cursor-relative coordinates
}

[typedef]
struct C.SDL_Finger {
pub:
	id       FingerID // C.SDL_FingerID
	x        f32
	y        f32
	pressure f32
}

pub type Finger = C.SDL_Finger

fn C.SDL_GetNumTouchDevices() int

// get_num_touch_devices gets the number of registered touch devices.
//
// On some platforms SDL first sees the touch device if it was actually used.
// Therefore SDL_GetNumTouchDevices() may return 0 although devices are
// available. After using all devices at least once the number will be
// correct.
//
// This was fixed for Android in SDL 2.0.1.
//
// returns the number of registered touch devices.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetTouchDevice
pub fn get_num_touch_devices() int {
	return C.SDL_GetNumTouchDevices()
}

fn C.SDL_GetTouchDevice(index int) TouchID

// C.SDL_TouchID

// get_touch_device gets the touch ID with the given index.
//
// `index` the touch device index
// returns the touch ID with the given index on success or 0 if the index is
//          invalid; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetNumTouchDevices
pub fn get_touch_device(index int) TouchID {
	return C.SDL_GetTouchDevice(index)
}

fn C.SDL_GetTouchName(index int) &char

// get_touch_name gets the touch device name as reported from the driver or NULL if the index
// is invalid.
//
// NOTE This function is available since SDL 2.0.22.
pub fn get_touch_name(index int) &char {
	return C.SDL_GetTouchName(index)
}

fn C.SDL_GetTouchDeviceType(touch_id TouchID) C.SDL_TouchDeviceType

// get_touch_device_type gets the type of the given touch device.
//
// NOTE This function is available since SDL 2.0.10.
pub fn get_touch_device_type(touch_id TouchID) TouchDeviceType {
	return TouchDeviceType(int(C.SDL_GetTouchDeviceType(touch_id)))
}

fn C.SDL_GetNumTouchFingers(touch_id TouchID) int

// get_num_touch_fingers gets the number of active fingers for a given touch device.
//
// `touchID` the ID of a touch device
// returns the number of active fingers for a given touch device on success
//          or 0 on failure; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetTouchFinger
pub fn get_num_touch_fingers(touch_id TouchID) int {
	return C.SDL_GetNumTouchFingers(touch_id)
}

fn C.SDL_GetTouchFinger(touch_id TouchID, index int) &C.SDL_Finger

// get_touch_finger gets the finger object for specified touch device ID and finger index.
//
// The returned resource is owned by SDL and should not be deallocated.
//
// `touchID` the ID of the requested touch device
// `index` the index of the requested finger
// returns a pointer to the SDL_Finger object or NULL if no object at the
//          given ID and index could be found.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RecordGesture
pub fn get_touch_finger(touch_id TouchID, index int) &Finger {
	return C.SDL_GetTouchFinger(touch_id, index)
}

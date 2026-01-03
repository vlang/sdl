// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_pen.h
//

// SDL pen event handling.
//
// SDL provides an API for pressure-sensitive pen (stylus and/or eraser)
// handling, e.g., for input and drawing tablets or suitably equipped mobile /
// tablet devices.
//
// To get started with pens, simply handle SDL_EVENT_PEN_* events. When a pen
// starts providing input, SDL will assign it a unique SDL_PenID, which will
// remain for the life of the process, as long as the pen stays connected.
//
// Pens may provide more than simple touch input; they might have other axes,
// such as pressure, tilt, rotation, etc.

// PenID; sdls pen instance IDs.
//
// Zero is used to signify an invalid/null device.
//
// These show up in pen events when SDL sees input from them. They remain
// consistent as long as SDL can recognize a tool to be the same pen; but if a
// pen's digitizer table is physically detached from the computer, it might
// get a new ID when reconnected, as SDL won't know it's the same device.
//
// These IDs are only stable within a single run of a program; the next time a
// program is run, the pen's ID will likely be different, even if the hardware
// hasn't been disconnected, etc.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_PenID)
pub type PenID = u32

pub const pen_mouseid = u32(C.SDL_PEN_MOUSEID) // ((SDL_MouseID)-2)

pub const pen_touchid = u32(C.SDL_PEN_TOUCHID) // ((SDL_TouchID)-2)

// Pen input flags, as reported by various pen events' `pen_state` field.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type PenInputFlags = u32

pub const pen_input_down = u32(C.SDL_PEN_INPUT_DOWN) // (1u << 0)

pub const pen_input_button_1 = u32(C.SDL_PEN_INPUT_BUTTON_1) // (1u << 1)

pub const pen_input_button_2 = u32(C.SDL_PEN_INPUT_BUTTON_2) // (1u << 2)

pub const pen_input_button_3 = u32(C.SDL_PEN_INPUT_BUTTON_3) // (1u << 3)

pub const pen_input_button_4 = u32(C.SDL_PEN_INPUT_BUTTON_4) // (1u << 4)

pub const pen_input_button_5 = u32(C.SDL_PEN_INPUT_BUTTON_5) // (1u << 5)

pub const pen_input_eraser_tip = u32(C.SDL_PEN_INPUT_ERASER_TIP) // (1u << 30)

pub const pen_input_in_proximity = u32(C.SDL_PEN_INPUT_IN_PROXIMITY) // (1u << 31)

// Pen axis indices.
//
// These are the valid values for the `axis` field in SDL_PenAxisEvent. All
// axes are either normalised to 0..1 or report a (positive or negative) angle
// in degrees, with 0.0 representing the centre. Not all pens/backends support
// all axes: unsupported axes are always zero.
//
// To convert angles for tilt and rotation into vector representation, use
// SDL_sinf on the XTILT, YTILT, or ROTATION component, for example:
//
// `SDL_sinf(xtilt * SDL_PI_F / 180.0)`.
//
// NOTE: This enum is available since SDL 3.2.0.
// PenAxis is C.SDL_PenAxis
pub enum PenAxis {
	pressure            = C.SDL_PEN_AXIS_PRESSURE            // `pressure` Pen pressure.Unidirectional: 0 to 1.0
	xtilt               = C.SDL_PEN_AXIS_XTILT               // `xtilt` Pen horizontal tilt angle.Bidirectional: -90.0 to 90.0 (left-to-right).
	ytilt               = C.SDL_PEN_AXIS_YTILT               // `ytilt` Pen vertical tilt angle.Bidirectional: -90.0 to 90.0 (top-to-down).
	distance            = C.SDL_PEN_AXIS_DISTANCE            // `distance` Pen distance to drawing surface.Unidirectional: 0.0 to 1.0
	rotation            = C.SDL_PEN_AXIS_ROTATION            // `rotation` Pen barrel rotation.Bidirectional: -180 to 179.9 (clockwise, 0 is facing up, -180.0 is facing down).
	slider              = C.SDL_PEN_AXIS_SLIDER              // `slider` Pen finger wheel or slider (e.g., Airbrush Pen).Unidirectional: 0 to 1.0
	tangential_pressure = C.SDL_PEN_AXIS_TANGENTIAL_PRESSURE // `tangential_pressure` Pressure from squeezing the pen ("barrel pressure").
	count               = C.SDL_PEN_AXIS_COUNT               // `count` Total known pen axis types in this version of SDL. This number may grow in future releases!
}

// PenDeviceType
//
// An enum that describes the type of a pen device.
//
// A "direct" device is a pen that touches a graphic display (like an Apple
// Pencil on an iPad's screen). "Indirect" devices touch an external tablet
// surface that is connected to the machine but is not a display (like a
// lower-end Wacom tablet connected over USB).
//
// Apps may use this information to decide if they should draw a cursor; if
// the pen is touching the screen directly, a cursor doesn't make sense and
// can be in the way, but becomes necessary for indirect devices to know where
// on the display they are interacting.
//
// NOTE: This enum is available since SDL 3.4.0.
//
// PenDeviceType is C.SDL_PenDeviceType
pub enum PenDeviceType {
	invalid  = C.SDL_PEN_DEVICE_TYPE_INVALID  // -1, *< Not a valid pen device.
	unknown  = C.SDL_PEN_DEVICE_TYPE_UNKNOWN  // `unknown` Don't know specifics of this pen.
	direct   = C.SDL_PEN_DEVICE_TYPE_DIRECT   // `direct` Pen touches display.
	indirect = C.SDL_PEN_DEVICE_TYPE_INDIRECT // `indirect` Pen touches something that isn't the display.
}

// C.SDL_GetPenDeviceType [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetPenDeviceType)
fn C.SDL_GetPenDeviceType(instance_id PenID) PenDeviceType

// get_pen_device_type gets the device type of the given pen.
//
// Many platforms do not supply this information, so an app must always be
// prepared to get an SDL_PEN_DEVICE_TYPE_UNKNOWN result.
//
// `instance_id` instance_id the pen instance ID.
// returns the device type of the given pen, or SDL_PEN_DEVICE_TYPE_INVALID
//          on failure; call SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.4.0.
pub fn get_pen_device_type(instance_id PenID) PenDeviceType {
	return C.SDL_GetPenDeviceType(instance_id)
}

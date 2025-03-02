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

// SDL pen instance IDs.
//
// Zero is used to signify an invalid/null device.
//
// These show up in pen events when SDL sees input from them. They remain
// consistent as long as SDL can recognize a tool to be the same pen; but if a
// pen physically leaves the area and returns, it might get a new ID.
//
// NOTE: This datatype is available since SDL 3.2.0.
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

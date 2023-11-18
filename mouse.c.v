// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_mouse.h
//
@[typedef]
pub struct C.SDL_Cursor {
}

pub type Cursor = C.SDL_Cursor

fn C.SDL_BUTTON(x int) int

// button is used as a mask when testing buttons in buttonstate.
//  - Button 1:  Left mouse button
//  - Button 2:  Middle mouse button
//  - Button 3:  Right mouse button
// Example
/*
```
mut x := 0
mut y := 0
mask := sdl.get_mouse_state(&x, &y)
if mask & u32(sdl.button(sdl.button_left)) == sdl.button_lmask {
	println('LMB pressed!')
}
```
*/
pub fn button(mask int) int {
	return C.SDL_BUTTON(mask)
}

pub const (
	button_left   = int(C.SDL_BUTTON_LEFT) // 1
	button_middle = int(C.SDL_BUTTON_MIDDLE) // 2
	button_right  = int(C.SDL_BUTTON_RIGHT) // 3
	button_x1     = int(C.SDL_BUTTON_X1) // 4
	button_x2     = int(C.SDL_BUTTON_X2) // 5
	button_lmask  = int(C.SDL_BUTTON_LMASK) // SDL_BUTTON(SDL_BUTTON_LEFT)
	button_mmask  = int(C.SDL_BUTTON_MMASK) // SDL_BUTTON(SDL_BUTTON_MIDDLE)
	button_rmask  = int(C.SDL_BUTTON_RMASK) // SDL_BUTTON(SDL_BUTTON_RIGHT)
	button_x1mask = int(C.SDL_BUTTON_X1MASK) // SDL_BUTTON(SDL_BUTTON_X1)
	button_x2mask = int(C.SDL_BUTTON_X2MASK) // SDL_BUTTON(SDL_BUTTON_X2)
)

// SystemCursor is C.SDL_SystemCursor
// Cursor types for SDL_CreateSystemCursor().
pub enum SystemCursor {
	arrow       = C.SDL_SYSTEM_CURSOR_ARROW // Arrow
	ibeam       = C.SDL_SYSTEM_CURSOR_IBEAM // I-beam
	wait        = C.SDL_SYSTEM_CURSOR_WAIT // Wait
	crosshair   = C.SDL_SYSTEM_CURSOR_CROSSHAIR // Crosshair
	waitarrow   = C.SDL_SYSTEM_CURSOR_WAITARROW // Small wait cursor (or Wait if not available)
	sizenwse    = C.SDL_SYSTEM_CURSOR_SIZENWSE // Double arrow pointing northwest and southeast
	sizenesw    = C.SDL_SYSTEM_CURSOR_SIZENESW // Double arrow pointing northeast and southwest
	sizewe      = C.SDL_SYSTEM_CURSOR_SIZEWE // Double arrow pointing west and east
	sizens      = C.SDL_SYSTEM_CURSOR_SIZENS // Double arrow pointing north and south
	sizeall     = C.SDL_SYSTEM_CURSOR_SIZEALL // Four pointed arrow pointing north, south, east, and west
	no          = C.SDL_SYSTEM_CURSOR_NO // Slashed circle or crossbones
	hand        = C.SDL_SYSTEM_CURSOR_HAND // Hand
	num_cursors = C.SDL_NUM_SYSTEM_CURSORS
}

// MouseWheelDirection is C.SDL_MouseWheelDirection
// Scroll direction types for the Scroll event
pub enum MouseWheelDirection {
	normal  = C.SDL_MOUSEWHEEL_NORMAL // The scroll direction is normal
	flipped = C.SDL_MOUSEWHEEL_FLIPPED // The scroll direction is flipped / natural
}

fn C.SDL_GetMouseFocus() &C.SDL_Window

// get_mouse_focus gets the window which currently has mouse focus.
pub fn get_mouse_focus() &Window {
	return C.SDL_GetMouseFocus()
}

fn C.SDL_GetMouseState(x &int, y &int) u32

// get_mouse_state retrieves the current state of the mouse.
//
// The current button state is returned as a button bitmask, which can
// be tested using the SDL_BUTTON(X) macros, and x and y are set to the
// mouse cursor position relative to the focus window for the currently
// selected mouse. You can pass NULL for either x or y.
pub fn get_mouse_state(x &int, y &int) u32 {
	return C.SDL_GetMouseState(x, y)
}

fn C.SDL_GetGlobalMouseState(x &int, y &int) u32

// get_global_mouse_state gets the current state of the mouse, in relation to the desktop
//
// This works just like SDL_GetMouseState(), but the coordinates will be
// reported relative to the top-left of the desktop. This can be useful if
// you need to track the mouse outside of a specific window and
// SDL_CaptureMouse() doesn't fit your needs. For example, it could be
// useful if you need to track the mouse while dragging a window, where
// coordinates relative to a window might not be in sync at all times.
//
// NOTE SDL_GetMouseState() returns the mouse position as SDL understands
// it from the last pump of the event queue. This function, however,
// queries the OS for the current mouse position, and as such, might
// be a slightly less efficient function. Unless you know what you're
// doing and have a good reason to use this function, you probably want
// SDL_GetMouseState() instead.
//
// `x` Returns the current X coord, relative to the desktop. Can be NULL.
// `y` Returns the current Y coord, relative to the desktop. Can be NULL.
// returns The current button state as a bitmask, which can be tested using the SDL_BUTTON(X) macros.
//
// See also: SDL_GetMouseState
pub fn get_global_mouse_state(x &int, y &int) u32 {
	return C.SDL_GetGlobalMouseState(x, y)
}

fn C.SDL_GetRelativeMouseState(x &int, y &int) u32

// get_relative_mouse_state retrieves the relative state of the mouse.
//
// The current button state is returned as a button bitmask, which can
// be tested using the SDL_BUTTON(X) macros, and x and y are set to the
// mouse deltas since the last call to SDL_GetRelativeMouseState().
pub fn get_relative_mouse_state(x &int, y &int) u32 {
	return C.SDL_GetRelativeMouseState(x, y)
}

fn C.SDL_WarpMouseInWindow(window &C.SDL_Window, x int, y int)

// warp_mouse_in_window moves the mouse to the given position within the window.
//
// `window` The window to move the mouse into, or NULL for the current mouse focus
// `x` The x coordinate within the window
// `y` The y coordinate within the window
//
// NOTE This function generates a mouse motion event
pub fn warp_mouse_in_window(window &Window, x int, y int) {
	C.SDL_WarpMouseInWindow(window, x, y)
}

fn C.SDL_WarpMouseGlobal(x int, y int) int

// warp_mouse_global moves the mouse to the given position in global screen space.
//
// `x` The x coordinate
// `y` The y coordinate
// returns 0 on success, -1 on error (usually: unsupported by a platform).
//
// NOTE This function generates a mouse motion event
pub fn warp_mouse_global(x int, y int) int {
	return C.SDL_WarpMouseGlobal(x, y)
}

fn C.SDL_SetRelativeMouseMode(enabled bool) int

// set_relative_mouse_mode sets relative mouse mode.
//
// `enabled` Whether or not to enable relative mode
//
// returns 0 on success, or -1 if relative mode is not supported.
//
// While the mouse is in relative mode, the cursor is hidden, and the
// driver will try to report continuous motion in the current window.
// Only relative motion events will be delivered, the mouse position
// will not change.
//
// NOTE This function will flush any pending mouse motion.
//
// See also: SDL_GetRelativeMouseMode()
pub fn set_relative_mouse_mode(enabled bool) int {
	return C.SDL_SetRelativeMouseMode(enabled)
}

fn C.SDL_CaptureMouse(enabled bool) int

// capture_mouse capture the mouse, to track input outside an SDL window.
//
// `enabled` Whether or not to enable capturing
//
// Capturing enables your app to obtain mouse events globally, instead of
// just within your window. Not all video targets support this function.
// When capturing is enabled, the current window will get all mouse events,
// but unlike relative mode, no change is made to the cursor and it is
// not restrained to your window.
//
// This function may also deny mouse input to other windows--both those in
// your application and others on the system--so you should use this
// function sparingly, and in small bursts. For example, you might want to
// track the mouse while the user is dragging something, until the user
// releases a mouse button. It is not recommended that you capture the mouse
// for long periods of time, such as the entire time your app is running.
//
// While captured, mouse events still report coordinates relative to the
// current (foreground) window, but those coordinates may be outside the
// bounds of the window (including negative values). Capturing is only
// allowed for the foreground window. If the window loses focus while
// capturing, the capture will be disabled automatically.
//
// While capturing is enabled, the current window will have the
// SDL_WINDOW_MOUSE_CAPTURE flag set.
//
// returns 0 on success, or -1 if not supported.
pub fn capture_mouse(enabled bool) int {
	return C.SDL_CaptureMouse(enabled)
}

fn C.SDL_GetRelativeMouseMode() bool

// get_relative_mouse_mode queries whether relative mouse mode is enabled.
//
// See also: SDL_SetRelativeMouseMode()
pub fn get_relative_mouse_mode() bool {
	return C.SDL_GetRelativeMouseMode()
}

fn C.SDL_CreateCursor(const_data &u8, const_mask &u8, w int, h int, hot_x int, hot_y int) &C.SDL_Cursor

// create_cursor creates a cursor, using the specified bitmap data and
// mask (in MSB format).
//
// The cursor width must be a multiple of 8 bits.
//
// The cursor is created in black and white according to the following:
/*
<table>
   <tr><td> data </td><td> mask </td><td> resulting pixel on screen </td></tr>
   <tr><td>  0   </td><td>  1   </td><td> White </td></tr>
   <tr><td>  1   </td><td>  1   </td><td> Black </td></tr>
   <tr><td>  0   </td><td>  0   </td><td> Transparent </td></tr>
   <tr><td>  1   </td><td>  0   </td><td> Inverted color if possible, black
   if not. </td></tr>
   </table>
*/
//
// See also: SDL_FreeCursor()
pub fn create_cursor(const_data &u8, const_mask &u8, w int, h int, hot_x int, hot_y int) &Cursor {
	return C.SDL_CreateCursor(const_data, const_mask, w, h, hot_x, hot_y)
}

fn C.SDL_CreateColorCursor(surface &C.SDL_Surface, hot_x int, hot_y int) &C.SDL_Cursor

// create_color_cursor creates a color cursor.
//
// See also: SDL_FreeCursor()
pub fn create_color_cursor(surface &Surface, hot_x int, hot_y int) &Cursor {
	return C.SDL_CreateColorCursor(surface, hot_x, hot_y)
}

fn C.SDL_CreateSystemCursor(id C.SDL_SystemCursor) &C.SDL_Cursor

// create_system_cursor creates a system cursor.
//
// See also: SDL_FreeCursor()
pub fn create_system_cursor(id SystemCursor) &Cursor {
	return C.SDL_CreateSystemCursor(C.SDL_SystemCursor(int(id)))
}

fn C.SDL_SetCursor(cursor &C.SDL_Cursor)

// set_cursor sets the active cursor.
pub fn set_cursor(cursor &Cursor) {
	C.SDL_SetCursor(cursor)
}

fn C.SDL_GetCursor() &C.SDL_Cursor

// get_cursor returns the active cursor.
pub fn get_cursor() &Cursor {
	return C.SDL_GetCursor()
}

fn C.SDL_GetDefaultCursor() &C.SDL_Cursor

// get_default_cursor returns the default cursor.
pub fn get_default_cursor() &Cursor {
	return C.SDL_GetDefaultCursor()
}

fn C.SDL_FreeCursor(cursor &C.SDL_Cursor)

// free_cursor frees a cursor created with SDL_CreateCursor() or similar functions.
//
// See also: SDL_CreateCursor()
// See also: SDL_CreateColorCursor()
// See also: SDL_CreateSystemCursor()
pub fn free_cursor(cursor &Cursor) {
	C.SDL_FreeCursor(cursor)
}

fn C.SDL_ShowCursor(toggle int) int

// show_cursor toggles whether or not the cursor is shown.
//
// `toggle` 1 to show the cursor, 0 to hide it, -1 to query the current
// state.
//
// returns 1 if the cursor is shown, or 0 if the cursor is hidden.
pub fn show_cursor(toggle int) int {
	return C.SDL_ShowCursor(toggle)
}

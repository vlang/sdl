// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_mouse.h
//
@[noinit; typedef]
pub struct C.SDL_Cursor {
}

pub type Cursor = C.SDL_Cursor

fn C.SDL_BUTTON(x int) int

// button is used as a mask when testing buttons in buttonstate.
//
//  - Button 1:  Left mouse button
//  - Button 2:  Middle mouse button
//  - Button 3:  Right mouse button
//
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

pub const button_left = int(C.SDL_BUTTON_LEFT) // 1

pub const button_middle = int(C.SDL_BUTTON_MIDDLE) // 2

pub const button_right = int(C.SDL_BUTTON_RIGHT) // 3

pub const button_x1 = int(C.SDL_BUTTON_X1) // 4

pub const button_x2 = int(C.SDL_BUTTON_X2) // 5

pub const button_lmask = int(C.SDL_BUTTON_LMASK) // SDL_BUTTON(SDL_BUTTON_LEFT)

pub const button_mmask = int(C.SDL_BUTTON_MMASK) // SDL_BUTTON(SDL_BUTTON_MIDDLE)

pub const button_rmask = int(C.SDL_BUTTON_RMASK) // SDL_BUTTON(SDL_BUTTON_RIGHT)

pub const button_x1mask = int(C.SDL_BUTTON_X1MASK) // SDL_BUTTON(SDL_BUTTON_X1)

pub const button_x2mask = int(C.SDL_BUTTON_X2MASK) // SDL_BUTTON(SDL_BUTTON_X2)

// SystemCursor is C.SDL_SystemCursor
// Cursor types for SDL_CreateSystemCursor().
pub enum SystemCursor {
	arrow       = C.SDL_SYSTEM_CURSOR_ARROW     // Arrow
	ibeam       = C.SDL_SYSTEM_CURSOR_IBEAM     // I-beam
	wait        = C.SDL_SYSTEM_CURSOR_WAIT      // Wait
	crosshair   = C.SDL_SYSTEM_CURSOR_CROSSHAIR // Crosshair
	waitarrow   = C.SDL_SYSTEM_CURSOR_WAITARROW // Small wait cursor (or Wait if not available)
	sizenwse    = C.SDL_SYSTEM_CURSOR_SIZENWSE  // Double arrow pointing northwest and southeast
	sizenesw    = C.SDL_SYSTEM_CURSOR_SIZENESW  // Double arrow pointing northeast and southwest
	sizewe      = C.SDL_SYSTEM_CURSOR_SIZEWE    // Double arrow pointing west and east
	sizens      = C.SDL_SYSTEM_CURSOR_SIZENS    // Double arrow pointing north and south
	sizeall     = C.SDL_SYSTEM_CURSOR_SIZEALL   // Four pointed arrow pointing north, south, east, and west
	no          = C.SDL_SYSTEM_CURSOR_NO        // Slashed circle or crossbones
	hand        = C.SDL_SYSTEM_CURSOR_HAND      // Hand
	num_cursors = C.SDL_NUM_SYSTEM_CURSORS
}

// MouseWheelDirection is C.SDL_MouseWheelDirection
// Scroll direction types for the Scroll event
pub enum MouseWheelDirection {
	normal  = C.SDL_MOUSEWHEEL_NORMAL  // The scroll direction is normal
	flipped = C.SDL_MOUSEWHEEL_FLIPPED // The scroll direction is flipped / natural
}

fn C.SDL_GetMouseFocus() &C.SDL_Window

// get_mouse_focus gets the window which currently has mouse focus.
//
// returns the window with mouse focus.
//
// NOTE This function is available since SDL 2.0.0.
pub fn get_mouse_focus() &Window {
	return C.SDL_GetMouseFocus()
}

fn C.SDL_GetMouseState(x &int, y &int) u32

// get_mouse_state retrieves the current state of the mouse.
//
// The current button state is returned as a button bitmask, which can be
// tested using the `SDL_BUTTON(X)` macros (where `X` is generally 1 for the
// left, 2 for middle, 3 for the right button), and `x` and `y` are set to the
// mouse cursor position relative to the focus window. You can pass NULL for
// either `x` or `y`.
//
// `x` the x coordinate of the mouse cursor position relative to the
//          focus window
// `y` the y coordinate of the mouse cursor position relative to the
//          focus window
// returns a 32-bit button bitmask of the current button state.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetGlobalMouseState
// See also: SDL_GetRelativeMouseState
// See also: SDL_PumpEvents
pub fn get_mouse_state(x &int, y &int) u32 {
	return C.SDL_GetMouseState(x, y)
}

fn C.SDL_GetGlobalMouseState(x &int, y &int) u32

// get_global_mouse_state gets the current state of the mouse in relation to the desktop.
//
// This works similarly to SDL_GetMouseState(), but the coordinates will be
// reported relative to the top-left of the desktop. This can be useful if you
// need to track the mouse outside of a specific window and SDL_CaptureMouse()
// doesn't fit your needs. For example, it could be useful if you need to
// track the mouse while dragging a window, where coordinates relative to a
// window might not be in sync at all times.
//
// Note: SDL_GetMouseState() returns the mouse position as SDL understands it
// from the last pump of the event queue. This function, however, queries the
// OS for the current mouse position, and as such, might be a slightly less
// efficient function. Unless you know what you're doing and have a good
// reason to use this function, you probably want SDL_GetMouseState() instead.
//
// `x` filled in with the current X coord relative to the desktop; can be
//          NULL
// `y` filled in with the current Y coord relative to the desktop; can be
//          NULL
// returns the current button state as a bitmask which can be tested using
//          the SDL_BUTTON(X) macros.
//
// NOTE This function is available since SDL 2.0.4.
//
// See also: SDL_CaptureMouse
pub fn get_global_mouse_state(x &int, y &int) u32 {
	return C.SDL_GetGlobalMouseState(x, y)
}

fn C.SDL_GetRelativeMouseState(x &int, y &int) u32

// get_relative_mouse_state retrieves the relative state of the mouse.
//
// The current button state is returned as a button bitmask, which can be
// tested using the `SDL_BUTTON(X)` macros (where `X` is generally 1 for the
// left, 2 for middle, 3 for the right button), and `x` and `y` are set to the
// mouse deltas since the last call to SDL_GetRelativeMouseState() or since
// event initialization. You can pass NULL for either `x` or `y`.
//
// `x` a pointer filled with the last recorded x coordinate of the mouse
// `y` a pointer filled with the last recorded y coordinate of the mouse
// returns a 32-bit button bitmask of the relative button state.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetMouseState
pub fn get_relative_mouse_state(x &int, y &int) u32 {
	return C.SDL_GetRelativeMouseState(x, y)
}

fn C.SDL_WarpMouseInWindow(window &C.SDL_Window, x int, y int)

// warp_mouse_in_window moves the mouse cursor to the given position within the window.
//
// This function generates a mouse motion event if relative mode is not
// enabled. If relative mode is enabled, you can force mouse events for the
// warp by setting the SDL_HINT_MOUSE_RELATIVE_WARP_MOTION hint.
//
// Note that this function will appear to succeed, but not actually move the
// mouse when used over Microsoft Remote Desktop.
//
// `window` the window to move the mouse into, or NULL for the current
//               mouse focus
// `x` the x coordinate within the window
// `y` the y coordinate within the window
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_WarpMouseGlobal
pub fn warp_mouse_in_window(window &Window, x int, y int) {
	C.SDL_WarpMouseInWindow(window, x, y)
}

fn C.SDL_WarpMouseGlobal(x int, y int) int

// warp_mouse_global moves the mouse to the given position in global screen space.
//
// This function generates a mouse motion event.
//
// A failure of this function usually means that it is unsupported by a
// platform.
//
// Note that this function will appear to succeed, but not actually move the
// mouse when used over Microsoft Remote Desktop.
//
// `x` the x coordinate
// `y` the y coordinate
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.4.
//
// See also: SDL_WarpMouseInWindow
pub fn warp_mouse_global(x int, y int) int {
	return C.SDL_WarpMouseGlobal(x, y)
}

fn C.SDL_SetRelativeMouseMode(enabled bool) int

// set_relative_mouse_mode sets relative mouse mode.
//
// While the mouse is in relative mode, the cursor is hidden, the mouse
// position is constrained to the window, and SDL will report continuous
// relative mouse motion even if the mouse is at the edge of the window.
//
// This function will flush any pending mouse motion.
//
// `enabled` SDL_TRUE to enable relative mode, SDL_FALSE to disable.
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
//          If relative mode is not supported, this returns -1.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetRelativeMouseMode
pub fn set_relative_mouse_mode(enabled bool) int {
	return C.SDL_SetRelativeMouseMode(enabled)
}

fn C.SDL_CaptureMouse(enabled bool) int

// capture_mouse captures the mouse and to track input outside an SDL window.
//
// Capturing enables your app to obtain mouse events globally, instead of just
// within your window. Not all video targets support this function. When
// capturing is enabled, the current window will get all mouse events, but
// unlike relative mode, no change is made to the cursor and it is not
// restrained to your window.
//
// This function may also deny mouse input to other windows--both those in
// your application and others on the system--so you should use this function
// sparingly, and in small bursts. For example, you might want to track the
// mouse while the user is dragging something, until the user releases a mouse
// button. It is not recommended that you capture the mouse for long periods
// of time, such as the entire time your app is running. For that, you should
// probably use SDL_SetRelativeMouseMode() or SDL_SetWindowGrab(), depending
// on your goals.
//
// While captured, mouse events still report coordinates relative to the
// current (foreground) window, but those coordinates may be outside the
// bounds of the window (including negative values). Capturing is only allowed
// for the foreground window. If the window loses focus while capturing, the
// capture will be disabled automatically.
//
// While capturing is enabled, the current window will have the
// `SDL_WINDOW_MOUSE_CAPTURE` flag set.
//
// Please note that as of SDL 2.0.22, SDL will attempt to "auto capture" the
// mouse while the user is pressing a button; this is to try and make mouse
// behavior more consistent between platforms, and deal with the common case
// of a user dragging the mouse outside of the window. This means that if you
// are calling SDL_CaptureMouse() only to deal with this situation, you no
// longer have to (although it is safe to do so). If this causes problems for
// your app, you can disable auto capture by setting the
// `SDL_HINT_MOUSE_AUTO_CAPTURE` hint to zero.
//
// `enabled` SDL_TRUE to enable capturing, SDL_FALSE to disable.
// returns 0 on success or -1 if not supported; call SDL_GetError() for more
//          information.
//
// NOTE This function is available since SDL 2.0.4.
//
// See also: SDL_GetGlobalMouseState
pub fn capture_mouse(enabled bool) int {
	return C.SDL_CaptureMouse(enabled)
}

fn C.SDL_GetRelativeMouseMode() bool

// get_relative_mouse_mode queries whether relative mouse mode is enabled.
//
// returns SDL_TRUE if relative mode is enabled or SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetRelativeMouseMode
pub fn get_relative_mouse_mode() bool {
	return C.SDL_GetRelativeMouseMode()
}

fn C.SDL_CreateCursor(const_data &u8, const_mask &u8, w int, h int, hot_x int, hot_y int) &C.SDL_Cursor

// create_cursor creates a cursor using the specified bitmap data and mask (in MSB format).
//
// `mask` has to be in MSB (Most Significant Bit) format.
//
// The cursor width (`w`) must be a multiple of 8 bits.
//
// The cursor is created in black and white according to the following:
//
// - data=0, mask=1: white
// - data=1, mask=1: black
// - data=0, mask=0: transparent
// - data=1, mask=0: inverted color if possible, black if not.
//
// Cursors created with this function must be freed with SDL_FreeCursor().
//
// If you want to have a color cursor, or create your cursor from an
// SDL_Surface, you should use SDL_CreateColorCursor(). Alternately, you can
// hide the cursor and draw your own as part of your game's rendering, but it
// will be bound to the framerate.
//
// Also, since SDL 2.0.0, SDL_CreateSystemCursor() is available, which
// provides twelve readily available system cursors to pick from.
//
// `data` the color value for each pixel of the cursor
// `mask` the mask value for each pixel of the cursor
// `w` the width of the cursor
// `h` the height of the cursor
// `hot_x` the X-axis location of the upper left corner of the cursor
//              relative to the actual mouse position
// `hot_y` the Y-axis location of the upper left corner of the cursor
//              relative to the actual mouse position
// returns a new cursor with the specified parameters on success or NULL on
//          failure; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_FreeCursor
// See also: SDL_SetCursor
// See also: SDL_ShowCursor
pub fn create_cursor(const_data &u8, const_mask &u8, w int, h int, hot_x int, hot_y int) &Cursor {
	return C.SDL_CreateCursor(const_data, const_mask, w, h, hot_x, hot_y)
}

fn C.SDL_CreateColorCursor(surface &C.SDL_Surface, hot_x int, hot_y int) &C.SDL_Cursor

// create_color_cursor creates a color cursor.
//
// `surface` an SDL_Surface structure representing the cursor image
// `hot_x` the x position of the cursor hot spot
// `hot_y` the y position of the cursor hot spot
// returns the new cursor on success or NULL on failure; call SDL_GetError()
//          for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateCursor
// See also: SDL_FreeCursor
pub fn create_color_cursor(surface &Surface, hot_x int, hot_y int) &Cursor {
	return C.SDL_CreateColorCursor(surface, hot_x, hot_y)
}

fn C.SDL_CreateSystemCursor(id C.SDL_SystemCursor) &C.SDL_Cursor

// create_system_cursor creates a system cursor.
//
// `id` an SDL_SystemCursor enum value
// returns a cursor on success or NULL on failure; call SDL_GetError() for
//          more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_FreeCursor
pub fn create_system_cursor(id SystemCursor) &Cursor {
	return C.SDL_CreateSystemCursor(C.SDL_SystemCursor(int(id)))
}

fn C.SDL_SetCursor(cursor &C.SDL_Cursor)

// set_cursor sets the active cursor.
//
// This function sets the currently active cursor to the specified one. If the
// cursor is currently visible, the change will be immediately represented on
// the display. SDL_SetCursor(NULL) can be used to force cursor redraw, if
// this is desired for any reason.
//
// `cursor` a cursor to make active
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateCursor
// See also: SDL_GetCursor
// See also: SDL_ShowCursor
pub fn set_cursor(cursor &Cursor) {
	C.SDL_SetCursor(cursor)
}

fn C.SDL_GetCursor() &C.SDL_Cursor

// get_cursor gets the active cursor.
//
// This function returns a pointer to the current cursor which is owned by the
// library. It is not necessary to free the cursor with SDL_FreeCursor().
//
// returns the active cursor or NULL if there is no mouse.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetCursor
pub fn get_cursor() &Cursor {
	return C.SDL_GetCursor()
}

fn C.SDL_GetDefaultCursor() &C.SDL_Cursor

// get_default_cursor gets the default cursor.
//
// You do not have to call SDL_FreeCursor() on the return value, but it is
// safe to do so.
//
// returns the default cursor on success or NULL on failure.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateSystemCursor
pub fn get_default_cursor() &Cursor {
	return C.SDL_GetDefaultCursor()
}

fn C.SDL_FreeCursor(cursor &C.SDL_Cursor)

// free_cursor frees a previously-created cursor.
//
// Use this function to free cursor resources created with SDL_CreateCursor(),
// SDL_CreateColorCursor() or SDL_CreateSystemCursor().
//
// `cursor` the cursor to free
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateColorCursor
// See also: SDL_CreateCursor
// See also: SDL_CreateSystemCursor
pub fn free_cursor(cursor &Cursor) {
	C.SDL_FreeCursor(cursor)
}

fn C.SDL_ShowCursor(toggle int) int

// show_cursor toggles whether or not the cursor is shown.
//
// The cursor starts off displayed but can be turned off. Passing `SDL_ENABLE`
// displays the cursor and passing `SDL_DISABLE` hides it.
//
// The current state of the mouse cursor can be queried by passing
// `SDL_QUERY`; either `SDL_DISABLE` or `SDL_ENABLE` will be returned.
//
// `toggle` `SDL_ENABLE` to show the cursor, `SDL_DISABLE` to hide it,
//               `SDL_QUERY` to query the current state without changing it.
// returns `SDL_ENABLE` if the cursor is shown, or `SDL_DISABLE` if the
//          cursor is hidden, or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateCursor
// See also: SDL_SetCursor
pub fn show_cursor(toggle int) int {
	return C.SDL_ShowCursor(toggle)
}

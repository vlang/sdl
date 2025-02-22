// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_mouse.h
//

// Any GUI application has to deal with the mouse, and SDL provides functions
// to manage mouse input and the displayed cursor.
//
// Most interactions with the mouse will come through the event subsystem.
// Moving a mouse generates an SDL_EVENT_MOUSE_MOTION event, pushing a button
// generates SDL_EVENT_MOUSE_BUTTON_DOWN, etc, but one can also query the
// current state of the mouse at any time with SDL_GetMouseState().
//
// For certain games, it's useful to disassociate the mouse cursor from mouse
// input. An FPS, for example, would not want the player's motion to stop as
// the mouse hits the edge of the window. For these scenarios, use
// SDL_SetWindowRelativeMouseMode(), which hides the cursor, grabs mouse input
// to the window, and reads mouse input no matter how far it moves.
//
// Games that want the system to track the mouse but want to draw their own
// cursor can use SDL_HideCursor() and SDL_ShowCursor(). It might be more
// efficient to let the system manage the cursor, if possible, using
// SDL_SetCursor() with a custom image made through SDL_CreateColorCursor(),
// or perhaps just a specific system cursor from SDL_CreateSystemCursor().
//
// SDL can, on many platforms, differentiate between multiple connected mice,
// allowing for interesting input scenarios and multiplayer games. They can be
// enumerated with SDL_GetMice(), and SDL will send SDL_EVENT_MOUSE_ADDED and
// SDL_EVENT_MOUSE_REMOVED events as they are connected and unplugged.
//
// Since many apps only care about basic mouse input, SDL offers a virtual
// mouse device for touch and pen input, which often can make a desktop
// application work on a touchscreen phone without any code changes. Apps that
// care about touch/pen separately from mouse input should filter out events
// with a `which` field of SDL_TOUCH_MOUSEID/SDL_PEN_MOUSEID.

// This is a unique ID for a mouse for the time it is connected to the system,
// and is never reused for the lifetime of the application.
//
// If the mouse is disconnected and reconnected, it will get a new ID.
//
// The value 0 is an invalid ID.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type MouseID = u32

// A bitmask of pressed mouse buttons, as reported by SDL_GetMouseState, etc.
//
// - Button 1: Left mouse button
// - Button 2: Middle mouse button
// - Button 3: Right mouse button
// - Button 4: Side mouse button 1
// - Button 5: Side mouse button 2
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: get_mouse_state (SDL_GetMouseState)
// See also: get_global_mouse_state (SDL_GetGlobalMouseState)
// See also: get_relative_mouse_state (SDL_GetRelativeMouseState)
pub type MouseButtonFlags = u32

@[noinit; typedef]
pub struct C.SDL_Cursor {
	// NOTE: Opaque type
}

pub type Cursor = C.SDL_Cursor

// SystemCursor is C.SDL_SystemCursor
pub enum SystemCursor {
	default     = C.SDL_SYSTEM_CURSOR_DEFAULT     // `default` Default cursor. Usually an arrow.
	text        = C.SDL_SYSTEM_CURSOR_TEXT        // `text` Text selection. Usually an I-beam.
	wait        = C.SDL_SYSTEM_CURSOR_WAIT        // `wait` Wait. Usually an hourglass or watch or spinning ball.
	crosshair   = C.SDL_SYSTEM_CURSOR_CROSSHAIR   // `crosshair` Crosshair.
	progress    = C.SDL_SYSTEM_CURSOR_PROGRESS    // `progress` Program is busy but still interactive. Usually it's WAIT with an arrow.
	nwse_resize = C.SDL_SYSTEM_CURSOR_NWSE_RESIZE // `nwse_resize` Double arrow pointing northwest and southeast.
	nesw_resize = C.SDL_SYSTEM_CURSOR_NESW_RESIZE // `nesw_resize` Double arrow pointing northeast and southwest.
	ew_resize   = C.SDL_SYSTEM_CURSOR_EW_RESIZE   // `ew_resize` Double arrow pointing west and east.
	ns_resize   = C.SDL_SYSTEM_CURSOR_NS_RESIZE   // `ns_resize` Double arrow pointing north and south.
	move        = C.SDL_SYSTEM_CURSOR_MOVE        // `move` Four pointed arrow pointing north, south, east, and west.
	not_allowed = C.SDL_SYSTEM_CURSOR_NOT_ALLOWED // `not_allowed` Not permitted. Usually a slashed circle or crossbones.
	pointer     = C.SDL_SYSTEM_CURSOR_POINTER     // `pointer` Pointer that indicates a link. Usually a pointing hand.
	nw_resize   = C.SDL_SYSTEM_CURSOR_NW_RESIZE   // `nw_resize` Window resize top-left. This may be a single arrow or a double arrow like NWSE_RESIZE.
	n_resize    = C.SDL_SYSTEM_CURSOR_N_RESIZE    // `n_resize` Window resize top. May be NS_RESIZE.
	ne_resize   = C.SDL_SYSTEM_CURSOR_NE_RESIZE   // `ne_resize` Window resize top-right. May be NESW_RESIZE.
	e_resize    = C.SDL_SYSTEM_CURSOR_E_RESIZE    // `e_resize` Window resize right. May be EW_RESIZE.
	se_resize   = C.SDL_SYSTEM_CURSOR_SE_RESIZE   // `se_resize` Window resize bottom-right. May be NWSE_RESIZE.
	s_resize    = C.SDL_SYSTEM_CURSOR_S_RESIZE    // `s_resize` Window resize bottom. May be NS_RESIZE.
	sw_resize   = C.SDL_SYSTEM_CURSOR_SW_RESIZE   // `sw_resize` Window resize bottom-left. May be NESW_RESIZE.
	w_resize    = C.SDL_SYSTEM_CURSOR_W_RESIZE    // `w_resize` Window resize left. May be EW_RESIZE.
	count       = C.SDL_SYSTEM_CURSOR_COUNT
}

// MouseWheelDirection is C.SDL_MouseWheelDirection
pub enum MouseWheelDirection {
	normal  = C.SDL_MOUSEWHEEL_NORMAL  // `normal` The scroll direction is normal
	flipped = C.SDL_MOUSEWHEEL_FLIPPED // `flipped` The scroll direction is flipped / natural
}

pub const button_left = C.SDL_BUTTON_LEFT // 1

pub const button_middle = C.SDL_BUTTON_MIDDLE // 2

pub const button_right = C.SDL_BUTTON_RIGHT // 3

pub const button_x1 = C.SDL_BUTTON_X1 // 4

pub const button_x2 = C.SDL_BUTTON_X2 // 5

// TODO: Function: #define SDL_BUTTON_MASK(X)  (1u << ((X)-1))

pub const button_lmask = C.SDL_BUTTON_LMASK // SDL_BUTTON_MASK(SDL_BUTTON_LEFT)

pub const button_mmask = C.SDL_BUTTON_MMASK // SDL_BUTTON_MASK(SDL_BUTTON_MIDDLE)

pub const button_rmask = C.SDL_BUTTON_RMASK // SDL_BUTTON_MASK(SDL_BUTTON_RIGHT)

pub const button_x1mask = C.SDL_BUTTON_X1MASK // SDL_BUTTON_MASK(SDL_BUTTON_X1)

pub const button_x2mask = C.SDL_BUTTON_X2MASK // SDL_BUTTON_MASK(SDL_BUTTON_X2)

// C.SDL_HasMouse [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasMouse)
fn C.SDL_HasMouse() bool

// has_mouse returns whether a mouse is currently connected.
//
// returns true if a mouse is connected, false otherwise.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_mice (SDL_GetMice)
pub fn has_mouse() bool {
	return C.SDL_HasMouse()
}

// C.SDL_GetMice [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetMice)
fn C.SDL_GetMice(count &int) &MouseID

// get_mice gets a list of currently connected mice.
//
// Note that this will include any device or virtual driver that includes
// mouse functionality, including some game controllers, KVM switches, etc.
// You should wait for input from a device before you consider it actively in
// use.
//
// `count` count a pointer filled in with the number of mice returned, may be
//              NULL.
// returns a 0 terminated array of mouse instance IDs or NULL on failure;
//          call SDL_GetError() for more information. This should be freed
//          with SDL_free() when it is no longer needed.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_mouse_name_for_id (SDL_GetMouseNameForID)
// See also: has_mouse (SDL_HasMouse)
pub fn get_mice(count &int) &MouseID {
	return C.SDL_GetMice(count)
}

// C.SDL_GetMouseNameForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetMouseNameForID)
fn C.SDL_GetMouseNameForID(instance_id MouseID) &char

// get_mouse_name_for_id gets the name of a mouse.
//
// This function returns "" if the mouse doesn't have a name.
//
// `instance_id` instance_id the mouse instance ID.
// returns the name of the selected mouse, or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_mice (SDL_GetMice)
pub fn get_mouse_name_for_id(instance_id MouseID) &char {
	return C.SDL_GetMouseNameForID(instance_id)
}

// C.SDL_GetMouseFocus [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetMouseFocus)
fn C.SDL_GetMouseFocus() &Window

// get_mouse_focus gets the window which currently has mouse focus.
//
// returns the window with mouse focus.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_mouse_focus() &Window {
	return C.SDL_GetMouseFocus()
}

// C.SDL_GetMouseState [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetMouseState)
fn C.SDL_GetMouseState(x &f32, y &f32) MouseButtonFlags

// get_mouse_state querys SDL's cache for the synchronous mouse button state and the
// window-relative SDL-cursor position.
//
// This function returns the cached synchronous state as SDL understands it
// from the last pump of the event queue.
//
// To query the platform for immediate asynchronous state, use
// SDL_GetGlobalMouseState.
//
// Passing non-NULL pointers to `x` or `y` will write the destination with
// respective x or y coordinates relative to the focused window.
//
// In Relative Mode, the SDL-cursor's position usually contradicts the
// platform-cursor's position as manually calculated from
// SDL_GetGlobalMouseState() and SDL_GetWindowPosition.
//
// `x` x a pointer to receive the SDL-cursor's x-position from the focused
//          window's top left corner, can be NULL if unused.
// `y` y a pointer to receive the SDL-cursor's y-position from the focused
//          window's top left corner, can be NULL if unused.
// returns a 32-bit bitmask of the button state that can be bitwise-compared
//          against the SDL_BUTTON_MASK(X) macro.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_global_mouse_state (SDL_GetGlobalMouseState)
// See also: get_relative_mouse_state (SDL_GetRelativeMouseState)
pub fn get_mouse_state(x &f32, y &f32) MouseButtonFlags {
	return C.SDL_GetMouseState(x, y)
}

// C.SDL_GetGlobalMouseState [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGlobalMouseState)
fn C.SDL_GetGlobalMouseState(x &f32, y &f32) MouseButtonFlags

// get_global_mouse_state querys the platform for the asynchronous mouse button state and the
// desktop-relative platform-cursor position.
//
// This function immediately queries the platform for the most recent
// asynchronous state, more costly than retrieving SDL's cached state in
// SDL_GetMouseState().
//
// Passing non-NULL pointers to `x` or `y` will write the destination with
// respective x or y coordinates relative to the desktop.
//
// In Relative Mode, the platform-cursor's position usually contradicts the
// SDL-cursor's position as manually calculated from SDL_GetMouseState() and
// SDL_GetWindowPosition.
//
// This function can be useful if you need to track the mouse outside of a
// specific window and SDL_CaptureMouse() doesn't fit your needs. For example,
// it could be useful if you need to track the mouse while dragging a window,
// where coordinates relative to a window might not be in sync at all times.
//
// `x` x a pointer to receive the platform-cursor's x-position from the
//          desktop's top left corner, can be NULL if unused.
// `y` y a pointer to receive the platform-cursor's y-position from the
//          desktop's top left corner, can be NULL if unused.
// returns a 32-bit bitmask of the button state that can be bitwise-compared
//          against the SDL_BUTTON_MASK(X) macro.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: capture_mouse (SDL_CaptureMouse)
// See also: get_mouse_state (SDL_GetMouseState)
// See also: get_global_mouse_state (SDL_GetGlobalMouseState)
pub fn get_global_mouse_state(x &f32, y &f32) MouseButtonFlags {
	return C.SDL_GetGlobalMouseState(x, y)
}

// C.SDL_GetRelativeMouseState [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRelativeMouseState)
fn C.SDL_GetRelativeMouseState(x &f32, y &f32) MouseButtonFlags

// get_relative_mouse_state querys SDL's cache for the synchronous mouse button state and accumulated
// mouse delta since last call.
//
// This function returns the cached synchronous state as SDL understands it
// from the last pump of the event queue.
//
// To query the platform for immediate asynchronous state, use
// SDL_GetGlobalMouseState.
//
// Passing non-NULL pointers to `x` or `y` will write the destination with
// respective x or y deltas accumulated since the last call to this function
// (or since event initialization).
//
// This function is useful for reducing overhead by processing relative mouse
// inputs in one go per-frame instead of individually per-event, at the
// expense of losing the order between events within the frame (e.g. quickly
// pressing and releasing a button within the same frame).
//
// `x` x a pointer to receive the x mouse delta accumulated since last
//          call, can be NULL if unused.
// `y` y a pointer to receive the y mouse delta accumulated since last
//          call, can be NULL if unused.
// returns a 32-bit bitmask of the button state that can be bitwise-compared
//          against the SDL_BUTTON_MASK(X) macro.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_mouse_state (SDL_GetMouseState)
// See also: get_global_mouse_state (SDL_GetGlobalMouseState)
pub fn get_relative_mouse_state(x &f32, y &f32) MouseButtonFlags {
	return C.SDL_GetRelativeMouseState(x, y)
}

// C.SDL_WarpMouseInWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_WarpMouseInWindow)
fn C.SDL_WarpMouseInWindow(window &Window, x f32, y f32)

// warp_mouse_in_window moves the mouse cursor to the given position within the window.
//
// This function generates a mouse motion event if relative mode is not
// enabled. If relative mode is enabled, you can force mouse events for the
// warp by setting the SDL_HINT_MOUSE_RELATIVE_WARP_MOTION hint.
//
// Note that this function will appear to succeed, but not actually move the
// mouse when used over Microsoft Remote Desktop.
//
// `window` window the window to move the mouse into, or NULL for the current
//               mouse focus.
// `x` x the x coordinate within the window.
// `y` y the y coordinate within the window.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: warp_mouse_global (SDL_WarpMouseGlobal)
pub fn warp_mouse_in_window(window &Window, x f32, y f32) {
	C.SDL_WarpMouseInWindow(window, x, y)
}

// C.SDL_WarpMouseGlobal [official documentation](https://wiki.libsdl.org/SDL3/SDL_WarpMouseGlobal)
fn C.SDL_WarpMouseGlobal(x f32, y f32) bool

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
// `x` x the x coordinate.
// `y` y the y coordinate.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: warp_mouse_in_window (SDL_WarpMouseInWindow)
pub fn warp_mouse_global(x f32, y f32) bool {
	return C.SDL_WarpMouseGlobal(x, y)
}

// C.SDL_SetWindowRelativeMouseMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowRelativeMouseMode)
fn C.SDL_SetWindowRelativeMouseMode(window &Window, enabled bool) bool

// set_window_relative_mouse_mode sets relative mouse mode for a window.
//
// While the window has focus and relative mouse mode is enabled, the cursor
// is hidden, the mouse position is constrained to the window, and SDL will
// report continuous relative mouse motion even if the mouse is at the edge of
// the window.
//
// If you'd like to keep the mouse position fixed while in relative mode you
// can use SDL_SetWindowMouseRect(). If you'd like the cursor to be at a
// specific location when relative mode ends, you should use
// SDL_WarpMouseInWindow() before disabling relative mode.
//
// This function will flush any pending mouse motion for this window.
//
// `window` window the window to change.
// `enabled` enabled true to enable relative mode, false to disable.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_relative_mouse_mode (SDL_GetWindowRelativeMouseMode)
pub fn set_window_relative_mouse_mode(window &Window, enabled bool) bool {
	return C.SDL_SetWindowRelativeMouseMode(window, enabled)
}

// C.SDL_GetWindowRelativeMouseMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowRelativeMouseMode)
fn C.SDL_GetWindowRelativeMouseMode(window &Window) bool

// get_window_relative_mouse_mode querys whether relative mouse mode is enabled for a window.
//
// `window` window the window to query.
// returns true if relative mode is enabled for a window or false otherwise.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_window_relative_mouse_mode (SDL_SetWindowRelativeMouseMode)
pub fn get_window_relative_mouse_mode(window &Window) bool {
	return C.SDL_GetWindowRelativeMouseMode(window)
}

// C.SDL_CaptureMouse [official documentation](https://wiki.libsdl.org/SDL3/SDL_CaptureMouse)
fn C.SDL_CaptureMouse(enabled bool) bool

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
// probably use SDL_SetWindowRelativeMouseMode() or SDL_SetWindowMouseGrab(),
// depending on your goals.
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
// Please note that SDL will attempt to "auto capture" the mouse while the
// user is pressing a button; this is to try and make mouse behavior more
// consistent between platforms, and deal with the common case of a user
// dragging the mouse outside of the window. This means that if you are
// calling SDL_CaptureMouse() only to deal with this situation, you do not
// have to (although it is safe to do so). If this causes problems for your
// app, you can disable auto capture by setting the
// `SDL_HINT_MOUSE_AUTO_CAPTURE` hint to zero.
//
// `enabled` enabled true to enable capturing, false to disable.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_global_mouse_state (SDL_GetGlobalMouseState)
pub fn capture_mouse(enabled bool) bool {
	return C.SDL_CaptureMouse(enabled)
}

// C.SDL_CreateCursor [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateCursor)
fn C.SDL_CreateCursor(const_data &u8, const_mask &u8, w int, h int, hot_x int, hot_y int) &Cursor

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
// Cursors created with this function must be freed with SDL_DestroyCursor().
//
// If you want to have a color cursor, or create your cursor from an
// SDL_Surface, you should use SDL_CreateColorCursor(). Alternately, you can
// hide the cursor and draw your own as part of your game's rendering, but it
// will be bound to the framerate.
//
// Also, SDL_CreateSystemCursor() is available, which provides several
// readily-available system cursors to pick from.
//
// `data` data the color value for each pixel of the cursor.
// `mask` mask the mask value for each pixel of the cursor.
// `w` w the width of the cursor.
// `h` h the height of the cursor.
// `hot_x` hot_x the x-axis offset from the left of the cursor image to the
//              mouse x position, in the range of 0 to `w` - 1.
// `hot_y` hot_y the y-axis offset from the top of the cursor image to the
//              mouse y position, in the range of 0 to `h` - 1.
// returns a new cursor with the specified parameters on success or NULL on
//          failure; call SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_color_cursor (SDL_CreateColorCursor)
// See also: create_system_cursor (SDL_CreateSystemCursor)
// See also: destroy_cursor (SDL_DestroyCursor)
// See also: set_cursor (SDL_SetCursor)
pub fn create_cursor(const_data &u8, const_mask &u8, w int, h int, hot_x int, hot_y int) &Cursor {
	return C.SDL_CreateCursor(const_data, const_mask, w, h, hot_x, hot_y)
}

// C.SDL_CreateColorCursor [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateColorCursor)
fn C.SDL_CreateColorCursor(surface &Surface, hot_x int, hot_y int) &Cursor

// create_color_cursor creates a color cursor.
//
// If this function is passed a surface with alternate representations, the
// surface will be interpreted as the content to be used for 100% display
// scale, and the alternate representations will be used for high DPI
// situations. For example, if the original surface is 32x32, then on a 2x
// macOS display or 200% display scale on Windows, a 64x64 version of the
// image will be used, if available. If a matching version of the image isn't
// available, the closest larger size image will be downscaled to the
// appropriate size and be used instead, if available. Otherwise, the closest
// smaller image will be upscaled and be used instead.
//
// `surface` surface an SDL_Surface structure representing the cursor image.
// `hot_x` hot_x the x position of the cursor hot spot.
// `hot_y` hot_y the y position of the cursor hot spot.
// returns the new cursor on success or NULL on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_cursor (SDL_CreateCursor)
// See also: create_system_cursor (SDL_CreateSystemCursor)
// See also: destroy_cursor (SDL_DestroyCursor)
// See also: set_cursor (SDL_SetCursor)
pub fn create_color_cursor(surface &Surface, hot_x int, hot_y int) &Cursor {
	return C.SDL_CreateColorCursor(surface, hot_x, hot_y)
}

// C.SDL_CreateSystemCursor [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateSystemCursor)
fn C.SDL_CreateSystemCursor(id SystemCursor) &Cursor

// create_system_cursor creates a system cursor.
//
// `id` id an SDL_SystemCursor enum value.
// returns a cursor on success or NULL on failure; call SDL_GetError() for
//          more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: destroy_cursor (SDL_DestroyCursor)
pub fn create_system_cursor(id SystemCursor) &Cursor {
	return C.SDL_CreateSystemCursor(id)
}

// C.SDL_SetCursor [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetCursor)
fn C.SDL_SetCursor(cursor &Cursor) bool

// set_cursor sets the active cursor.
//
// This function sets the currently active cursor to the specified one. If the
// cursor is currently visible, the change will be immediately represented on
// the display. SDL_SetCursor(NULL) can be used to force cursor redraw, if
// this is desired for any reason.
//
// `cursor` cursor a cursor to make active.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_cursor (SDL_GetCursor)
pub fn set_cursor(cursor &Cursor) bool {
	return C.SDL_SetCursor(cursor)
}

// C.SDL_GetCursor [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCursor)
fn C.SDL_GetCursor() &Cursor

// get_cursor gets the active cursor.
//
// This function returns a pointer to the current cursor which is owned by the
// library. It is not necessary to free the cursor with SDL_DestroyCursor().
//
// returns the active cursor or NULL if there is no mouse.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_cursor (SDL_SetCursor)
pub fn get_cursor() &Cursor {
	return C.SDL_GetCursor()
}

// C.SDL_GetDefaultCursor [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDefaultCursor)
fn C.SDL_GetDefaultCursor() &Cursor

// get_default_cursor gets the default cursor.
//
// You do not have to call SDL_DestroyCursor() on the return value, but it is
// safe to do so.
//
// returns the default cursor on success or NULL on failuree; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_default_cursor() &Cursor {
	return C.SDL_GetDefaultCursor()
}

// C.SDL_DestroyCursor [official documentation](https://wiki.libsdl.org/SDL3/SDL_DestroyCursor)
fn C.SDL_DestroyCursor(cursor &Cursor)

// destroy_cursor frees a previously-created cursor.
//
// Use this function to free cursor resources created with SDL_CreateCursor(),
// SDL_CreateColorCursor() or SDL_CreateSystemCursor().
//
// `cursor` cursor the cursor to free.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_color_cursor (SDL_CreateColorCursor)
// See also: create_cursor (SDL_CreateCursor)
// See also: create_system_cursor (SDL_CreateSystemCursor)
pub fn destroy_cursor(cursor &Cursor) {
	C.SDL_DestroyCursor(cursor)
}

// C.SDL_ShowCursor [official documentation](https://wiki.libsdl.org/SDL3/SDL_ShowCursor)
fn C.SDL_ShowCursor() bool

// show_cursor shows the cursor.
//
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: cursor_visible (SDL_CursorVisible)
// See also: hide_cursor (SDL_HideCursor)
pub fn show_cursor() bool {
	return C.SDL_ShowCursor()
}

// C.SDL_HideCursor [official documentation](https://wiki.libsdl.org/SDL3/SDL_HideCursor)
fn C.SDL_HideCursor() bool

// hide_cursor hides the cursor.
//
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: cursor_visible (SDL_CursorVisible)
// See also: show_cursor (SDL_ShowCursor)
pub fn hide_cursor() bool {
	return C.SDL_HideCursor()
}

// C.SDL_CursorVisible [official documentation](https://wiki.libsdl.org/SDL3/SDL_CursorVisible)
fn C.SDL_CursorVisible() bool

// cursor_visible returns whether the cursor is currently being shown.
//
// returns `true` if the cursor is being shown, or `false` if the cursor is
//          hidden.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: hide_cursor (SDL_HideCursor)
// See also: show_cursor (SDL_ShowCursor)
pub fn cursor_visible() bool {
	return C.SDL_CursorVisible()
}

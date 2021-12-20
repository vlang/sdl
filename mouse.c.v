// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_mouse.h
//
[typedef]
struct C.SDL_Cursor {
}

pub type Cursor = C.SDL_Cursor

// SystemCursor is C.SDL_SystemCursor
pub enum SystemCursor {
	arrow = C.SDL_SYSTEM_CURSOR_ARROW // Arrow
	ibeam = C.SDL_SYSTEM_CURSOR_IBEAM // I-beam
	wait = C.SDL_SYSTEM_CURSOR_WAIT // Wait
	crosshair = C.SDL_SYSTEM_CURSOR_CROSSHAIR // Crosshair
	waitarrow = C.SDL_SYSTEM_CURSOR_WAITARROW // Small wait cursor (or Wait if not available)
	sizenwse = C.SDL_SYSTEM_CURSOR_SIZENWSE // Double arrow pointing northwest and southeast
	sizenesw = C.SDL_SYSTEM_CURSOR_SIZENESW // Double arrow pointing northeast and southwest
	sizewe = C.SDL_SYSTEM_CURSOR_SIZEWE // Double arrow pointing west and east
	sizens = C.SDL_SYSTEM_CURSOR_SIZENS // Double arrow pointing north and south
	sizeall = C.SDL_SYSTEM_CURSOR_SIZEALL // Four pointed arrow pointing north, south, east, and west
	no = C.SDL_SYSTEM_CURSOR_NO // Slashed circle or crossbones
	hand = C.SDL_SYSTEM_CURSOR_HAND // Hand
	num_cursors = C.SDL_NUM_SYSTEM_CURSORS
}

// MouseWheelDirection is C.SDL_MouseWheelDirection
pub enum MouseWheelDirection {
	normal = C.SDL_MOUSEWHEEL_NORMAL // The scroll direction is normal
	flipped = C.SDL_MOUSEWHEEL_FLIPPED // The scroll direction is flipped / natural
}

// extern DECLSPEC SDL_Window * SDLCALL SDL_GetMouseFocus(void)
fn C.SDL_GetMouseFocus() &C.SDL_Window
pub fn get_mouse_focus() &C.SDL_Window {
	return C.SDL_GetMouseFocus()
}

// extern DECLSPEC Uint32 SDLCALL SDL_GetMouseState(int *x, int *y)
fn C.SDL_GetMouseState(x &int, y &int) u32
pub fn get_mouse_state(x &int, y &int) u32 {
	return C.SDL_GetMouseState(x, y)
}

// extern DECLSPEC Uint32 SDLCALL SDL_GetGlobalMouseState(int *x, int *y)
fn C.SDL_GetGlobalMouseState(x &int, y &int) u32
pub fn get_global_mouse_state(x &int, y &int) u32 {
	return C.SDL_GetGlobalMouseState(x, y)
}

// extern DECLSPEC Uint32 SDLCALL SDL_GetRelativeMouseState(int *x, int *y)
fn C.SDL_GetRelativeMouseState(x &int, y &int) u32
pub fn get_relative_mouse_state(x &int, y &int) u32 {
	return C.SDL_GetRelativeMouseState(x, y)
}

// extern DECLSPEC void SDLCALL SDL_WarpMouseInWindow(SDL_Window * window,                                                   int x, int y)
fn C.SDL_WarpMouseInWindow(window &C.SDL_Window, x int, y int)
pub fn warp_mouse_in_window(window &C.SDL_Window, x int, y int) {
	C.SDL_WarpMouseInWindow(window, x, y)
}

// extern DECLSPEC int SDLCALL SDL_WarpMouseGlobal(int x, int y)
fn C.SDL_WarpMouseGlobal(x int, y int) int
pub fn warp_mouse_global(x int, y int) int {
	return C.SDL_WarpMouseGlobal(x, y)
}

// extern DECLSPEC int SDLCALL SDL_SetRelativeMouseMode(SDL_bool enabled)
fn C.SDL_SetRelativeMouseMode(enabled bool) int
pub fn set_relative_mouse_mode(enabled bool) int {
	return C.SDL_SetRelativeMouseMode(enabled)
}

// extern DECLSPEC int SDLCALL SDL_CaptureMouse(SDL_bool enabled)
fn C.SDL_CaptureMouse(enabled bool) int
pub fn capture_mouse(enabled bool) int {
	return C.SDL_CaptureMouse(enabled)
}

// extern DECLSPEC SDL_bool SDLCALL SDL_GetRelativeMouseMode(void)
fn C.SDL_GetRelativeMouseMode() bool
pub fn get_relative_mouse_mode() bool {
	return C.SDL_GetRelativeMouseMode()
}

// extern DECLSPEC SDL_Cursor *SDLCALL SDL_CreateCursor(const Uint8 * data,                                                     const Uint8 * mask,                                                     int w, int h, int hot_x,                                                     int hot_y)
fn C.SDL_CreateCursor(data &byte, mask &byte, w int, h int, hot_x int, hot_y int) &C.SDL_Cursor
pub fn create_cursor(data &byte, mask &byte, w int, h int, hot_x int, hot_y int) &C.SDL_Cursor {
	return C.SDL_CreateCursor(data, mask, w, h, hot_x, hot_y)
}

// extern DECLSPEC SDL_Cursor *SDLCALL SDL_CreateColorCursor(SDL_Surface *surface,                                                          int hot_x,                                                          int hot_y)
fn C.SDL_CreateColorCursor(surface &C.SDL_Surface, hot_x int, hot_y int) &C.SDL_Cursor
pub fn create_color_cursor(surface &C.SDL_Surface, hot_x int, hot_y int) &C.SDL_Cursor {
	return C.SDL_CreateColorCursor(surface, hot_x, hot_y)
}

// extern DECLSPEC SDL_Cursor *SDLCALL SDL_CreateSystemCursor(SDL_SystemCursor id)
fn C.SDL_CreateSystemCursor(id C.SDL_SystemCursor) &C.SDL_Cursor
pub fn create_system_cursor(id C.SDL_SystemCursor) &C.SDL_Cursor {
	return C.SDL_CreateSystemCursor(id)
}

// extern DECLSPEC void SDLCALL SDL_SetCursor(SDL_Cursor * cursor)
fn C.SDL_SetCursor(cursor &C.SDL_Cursor)
pub fn set_cursor(cursor &C.SDL_Cursor) {
	C.SDL_SetCursor(cursor)
}

// extern DECLSPEC SDL_Cursor *SDLCALL SDL_GetCursor(void)
fn C.SDL_GetCursor() &C.SDL_Cursor
pub fn get_cursor() &C.SDL_Cursor {
	return C.SDL_GetCursor()
}

// extern DECLSPEC SDL_Cursor *SDLCALL SDL_GetDefaultCursor(void)
fn C.SDL_GetDefaultCursor() &C.SDL_Cursor
pub fn get_default_cursor() &C.SDL_Cursor {
	return C.SDL_GetDefaultCursor()
}

// extern DECLSPEC void SDLCALL SDL_FreeCursor(SDL_Cursor * cursor)
fn C.SDL_FreeCursor(cursor &C.SDL_Cursor)
pub fn free_cursor(cursor &C.SDL_Cursor) {
	C.SDL_FreeCursor(cursor)
}

// extern DECLSPEC int SDLCALL SDL_ShowCursor(int toggle)
fn C.SDL_ShowCursor(toggle int) int
pub fn show_cursor(toggle int) int {
	return C.SDL_ShowCursor(toggle)
}

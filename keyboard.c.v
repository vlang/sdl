// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_keyboard.h
//

[typedef]
struct C.SDL_Keysym {
pub:
	scancode Scancode // C.SDL_Scancode // SDL physical key code - see ::SDL_Scancode for details
	sym      Key      // C.SDL_Keycode // SDL virtual key code - see ::SDL_Keycode for details
	mod      u16      // current key modifiers
	unused   u32      //
}

pub type Keysym = C.SDL_Keysym

// extern DECLSPEC SDL_Window * SDLCALL SDL_GetKeyboardFocus(void)
fn C.SDL_GetKeyboardFocus() &C.SDL_Window
pub fn get_keyboard_focus() &Window {
	return C.SDL_GetKeyboardFocus()
}

// extern DECLSPEC const Uint8 *SDLCALL SDL_GetKeyboardState(int *numkeys)
fn C.SDL_GetKeyboardState(numkeys &int) &byte
pub fn get_keyboard_state(numkeys &int) &byte {
	return C.SDL_GetKeyboardState(numkeys)
}

// extern DECLSPEC SDL_Keymod SDLCALL SDL_GetModState(void)
fn C.SDL_GetModState() C.SDL_Keymod
pub fn get_mod_state() Keymod {
	return Keymod(int(C.SDL_GetModState()))
}

// extern DECLSPEC void SDLCALL SDL_SetModState(SDL_Keymod modstate)
fn C.SDL_SetModState(modstate C.SDL_Keymod)
pub fn set_mod_state(modstate Keymod) {
	C.SDL_SetModState(C.SDL_Keymod(modstate))
}

// extern DECLSPEC SDL_Keycode SDLCALL SDL_GetKeyFromScancode(SDL_Scancode scancode)
fn C.SDL_GetKeyFromScancode(scancode C.SDL_Scancode) C.SDL_Keycode
pub fn get_key_from_scancode(scancode Scancode) Keycode {
	return Keycode(int(C.SDL_GetKeyFromScancode(C.SDL_Scancode(scancode))))
}

// extern DECLSPEC SDL_Scancode SDLCALL SDL_GetScancodeFromKey(SDL_Keycode key)
fn C.SDL_GetScancodeFromKey(key C.SDL_Keycode) C.SDL_Scancode
pub fn get_scancode_from_key(key Keycode) Scancode {
	return Scancode(int(C.SDL_GetScancodeFromKey(C.SDL_Keycode(key))))
}

// extern DECLSPEC const char *SDLCALL SDL_GetScancodeName(SDL_Scancode scancode)
fn C.SDL_GetScancodeName(scancode C.SDL_Scancode) &char
pub fn get_scancode_name(scancode Scancode) string {
	return unsafe { cstring_to_vstring(C.SDL_GetScancodeName(C.SDL_Scancode(scancode))) }
}

// extern DECLSPEC SDL_Scancode SDLCALL SDL_GetScancodeFromName(const char *name)
fn C.SDL_GetScancodeFromName(name &char) C.SDL_Scancode
pub fn get_scancode_from_name(name string) Scancode {
	return Scancode(int(C.SDL_GetScancodeFromName(name.str)))
}

// extern DECLSPEC const char *SDLCALL SDL_GetKeyName(SDL_Keycode key)
fn C.SDL_GetKeyName(key C.SDL_Keycode) &char
pub fn get_key_name(key Keycode) string {
	return unsafe { cstring_to_vstring(C.SDL_GetKeyName(C.SDL_Keycode(key))) }
}

// extern DECLSPEC SDL_Keycode SDLCALL SDL_GetKeyFromName(const char *name)
fn C.SDL_GetKeyFromName(name &char) C.SDL_Keycode
pub fn get_key_from_name(name string) Keycode {
	return Keycode(int(C.SDL_GetKeyFromName(name.str)))
}

// extern DECLSPEC void SDLCALL SDL_StartTextInput(void)
fn C.SDL_StartTextInput()
pub fn start_text_input() {
	C.SDL_StartTextInput()
}

// extern DECLSPEC SDL_bool SDLCALL SDL_IsTextInputActive(void)
fn C.SDL_IsTextInputActive() bool
pub fn is_text_input_active() bool {
	return C.SDL_IsTextInputActive()
}

// extern DECLSPEC void SDLCALL SDL_StopTextInput(void)
fn C.SDL_StopTextInput()
pub fn stop_text_input() {
	C.SDL_StopTextInput()
}

// extern DECLSPEC void SDLCALL SDL_SetTextInputRect(SDL_Rect *rect)
fn C.SDL_SetTextInputRect(rect &C.SDL_Rect)
pub fn set_text_input_rect(rect &Rect) {
	C.SDL_SetTextInputRect(rect)
}

// extern DECLSPEC SDL_bool SDLCALL SDL_HasScreenKeyboardSupport(void)
fn C.SDL_HasScreenKeyboardSupport() bool
pub fn has_screen_keyboard_support() bool {
	return C.SDL_HasScreenKeyboardSupport()
}

// extern DECLSPEC SDL_bool SDLCALL SDL_IsScreenKeyboardShown(SDL_Window *window)
fn C.SDL_IsScreenKeyboardShown(window &C.SDL_Window) bool
pub fn is_screen_keyboard_shown(window &Window) bool {
	return C.SDL_IsScreenKeyboardShown(window)
}

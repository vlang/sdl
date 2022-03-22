// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_keyboard.h
//

// The SDL keysym structure, used in key events.
//
// NOTE  If you are looking for translated character input, see the ::SDL_TEXTINPUT event.
[typedef]
struct C.SDL_Keysym {
pub:
	scancode Scancode // C.SDL_Scancode // SDL physical key code - see ::SDL_Scancode for details
	sym      Keycode  // C.SDL_Keycode // SDL virtual key code - see ::SDL_Keycode for details
	mod      u16      // current key modifiers
	unused   u32      //
}

// Keysym is C.SDL_Keysym
pub type Keysym = C.SDL_Keysym

fn C.SDL_GetKeyboardFocus() &C.SDL_Window

// get_keyboard_focus queries the window which currently has keyboard focus.
//
// returns the window with keyboard focus.
//
// NOTE This function is available since SDL 2.0.0.
pub fn get_keyboard_focus() &Window {
	return C.SDL_GetKeyboardFocus()
}

fn C.SDL_GetKeyboardState(numkeys &int) &byte

// get_keyboard_state gets a snapshot of the current state of the keyboard.
//
// The pointer returned is a pointer to an internal SDL array. It will be
// valid for the whole lifetime of the application and should not be freed by
// the caller.
//
// A array element with a value of 1 means that the key is pressed and a value
// of 0 means that it is not. Indexes into this array are obtained by using
// SDL_Scancode values.
//
// Use SDL_PumpEvents() to update the state array.
//
// This function gives you the current state after all events have been
// processed, so if a key or button has been pressed and released before you
// process events, then the pressed state will never show up in the
// SDL_GetKeyboardState() calls.
//
// Note: This function doesn't take into account whether shift has been
// pressed or not.
//
// `numkeys` if non-NULL, receives the length of the returned array
// returns a pointer to an array of key states.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_PumpEvents
pub fn get_keyboard_state(numkeys &int) &byte {
	return C.SDL_GetKeyboardState(numkeys)
}

fn C.SDL_GetModState() C.SDL_Keymod

// get_mod_state gets the current key modifier state for the keyboard.
//
// returns an OR'd combination of the modifier keys for the keyboard. See
//          SDL_Keymod for details.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetKeyboardState
// See also: SDL_SetModState
pub fn get_mod_state() Keymod {
	return Keymod(int(C.SDL_GetModState()))
}

fn C.SDL_SetModState(modstate C.SDL_Keymod)

// set_mod_state sets the current key modifier state for the keyboard.
//
// The inverse of SDL_GetModState(), SDL_SetModState() allows you to impose
// modifier key states on your application. Simply pass your desired modifier
// states into `modstate`. This value may be a bitwise, OR'd combination of
// SDL_Keymod values.
//
// This does not change the keyboard state, only the key modifier flags that
// SDL reports.
//
// `modstate` the desired SDL_Keymod for the keyboard
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetModState
pub fn set_mod_state(modstate Keymod) {
	C.SDL_SetModState(C.SDL_Keymod(modstate))
}

fn C.SDL_GetKeyFromScancode(scancode C.SDL_Scancode) C.SDL_Keycode

// get_key_from_scancode gets the key code corresponding to the given scancode according to the
// current keyboard layout.
//
// See SDL_Keycode for details.
//
// `scancode` the desired SDL_Scancode to query
// returns the SDL_Keycode that corresponds to the given SDL_Scancode.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetKeyName
// See also: SDL_GetScancodeFromKey
pub fn get_key_from_scancode(scancode Scancode) Keycode {
	return Keycode(int(C.SDL_GetKeyFromScancode(C.SDL_Scancode(scancode))))
}

fn C.SDL_GetScancodeFromKey(key C.SDL_Keycode) C.SDL_Scancode

// get_scancode_from_key gets the scancode corresponding to the given key code according to the
// current keyboard layout.
//
// See SDL_Scancode for details.
//
// `key` the desired SDL_Keycode to query
// returns the SDL_Scancode that corresponds to the given SDL_Keycode.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetKeyFromScancode
// See also: SDL_GetScancodeName
pub fn get_scancode_from_key(key Keycode) Scancode {
	return Scancode(int(C.SDL_GetScancodeFromKey(C.SDL_Keycode(key))))
}

fn C.SDL_GetScancodeName(scancode C.SDL_Scancode) &char

// get_scancode_name gets a human-readable name for a scancode.
//
// See SDL_Scancode for details.
//
// **WARNING**: The returned name is by design not stable across platforms,
// e.g. the name for `SDL_SCANCODE_LGUI` is "Left GUI" under Linux but "Left
// Windows" under Microsoft Windows, and some scancodes like
// `SDL_SCANCODE_NONUSBACKSLASH` don't have any name at all. There are even
// scancodes that share names, e.g. `SDL_SCANCODE_RETURN` and
// `SDL_SCANCODE_RETURN2` (both called "Return"). This function is therefore
// unsuitable for creating a stable cross-platform two-way mapping between
// strings and scancodes.
//
// `scancode` the desired SDL_Scancode to query
// returns a pointer to the name for the scancode. If the scancode doesn't
//          have a name this function returns an empty string ("").
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetScancodeFromKey
// See also: SDL_GetScancodeFromName
pub fn get_scancode_name(scancode Scancode) &char {
	return C.SDL_GetScancodeName(C.SDL_Scancode(scancode))
}

fn C.SDL_GetScancodeFromName(name &char) C.SDL_Scancode

// get_scancode_from_name gets a scancode from a human-readable name.
//
// `name` the human-readable scancode name
// returns the SDL_Scancode, or `SDL_SCANCODE_UNKNOWN` if the name wasn't
//          recognized; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetKeyFromName
// See also: SDL_GetScancodeFromKey
// See also: SDL_GetScancodeName
pub fn get_scancode_from_name(name &char) Scancode {
	return Scancode(int(C.SDL_GetScancodeFromName(name)))
}

fn C.SDL_GetKeyName(key C.SDL_Keycode) &char

// get_key_name gets a human-readable name for a key.
//
// See SDL_Scancode and SDL_Keycode for details.
//
// `key` the desired SDL_Keycode to query
// returns a pointer to a UTF-8 string that stays valid at least until the
//          next call to this function. If you need it around any longer, you
//          must copy it. If the key doesn't have a name, this function
//          returns an empty string ("").
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetKeyFromName
// See also: SDL_GetKeyFromScancode
// See also: SDL_GetScancodeFromKey
pub fn get_key_name(key Keycode) &char {
	return C.SDL_GetKeyName(C.SDL_Keycode(key))
}

fn C.SDL_GetKeyFromName(name &char) C.SDL_Keycode

// get_key_from_name gets a key code from a human-readable name.
//
// `name` the human-readable key name
// returns key code, or `SDLK_UNKNOWN` if the name wasn't recognized; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetKeyFromScancode
// See also: SDL_GetKeyName
// See also: SDL_GetScancodeFromName
pub fn get_key_from_name(name &char) Keycode {
	return Keycode(int(C.SDL_GetKeyFromName(name)))
}

fn C.SDL_StartTextInput()

// start_text_input starts accepting Unicode text input events.
//
// This function will start accepting Unicode text input events in the focused
// SDL window, and start emitting SDL_TextInputEvent (SDL_TEXTINPUT) and
// SDL_TextEditingEvent (SDL_TEXTEDITING) events. Please use this function in
// pair with SDL_StopTextInput().
//
// On some platforms using this function activates the screen keyboard.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetTextInputRect
// See also: SDL_StopTextInput
pub fn start_text_input() {
	C.SDL_StartTextInput()
}

fn C.SDL_IsTextInputActive() bool

// is_text_input_active checks whether or not Unicode text input events are enabled.
//
// returns SDL_TRUE if text input events are enabled else SDL_FALSE.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_StartTextInput
pub fn is_text_input_active() bool {
	return C.SDL_IsTextInputActive()
}

fn C.SDL_StopTextInput()

// stop_text_input stops receiving any text input events.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_StartTextInput
pub fn stop_text_input() {
	C.SDL_StopTextInput()
}

fn C.SDL_SetTextInputRect(rect &C.SDL_Rect)

// set_text_input_rect sets the rectangle used to type Unicode text inputs.
//
// `rect` the SDL_Rect structure representing the rectangle to receive
//             text (ignored if NULL)
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_StartTextInput
pub fn set_text_input_rect(rect &Rect) {
	C.SDL_SetTextInputRect(rect)
}

fn C.SDL_HasScreenKeyboardSupport() bool

// has_screen_keyboard_support checks whether the platform has screen keyboard support.
//
// returns SDL_TRUE if the platform has some screen keyboard support or
//          SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_StartTextInput
// See also: SDL_IsScreenKeyboardShown
pub fn has_screen_keyboard_support() bool {
	return C.SDL_HasScreenKeyboardSupport()
}

fn C.SDL_IsScreenKeyboardShown(window &C.SDL_Window) bool

// is_screen_keyboard_shown checks whether the screen keyboard is shown for given window.
//
// `window` the window for which screen keyboard should be queried
// returns SDL_TRUE if screen keyboard is shown or SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_HasScreenKeyboardSupport
pub fn is_screen_keyboard_shown(window &Window) bool {
	return C.SDL_IsScreenKeyboardShown(window)
}

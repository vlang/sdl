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
pub struct C.SDL_Keysym {
pub:
	scancode Scancode // C.SDL_Scancode // SDL physical key code - see ::SDL_Scancode for details
	sym      Keycode  // C.SDL_Keycode // SDL virtual key code - see ::SDL_Keycode for details
	mod      u16      // current key modifiers
	unused   u32      //
}

// Keysym is C.SDL_Keysym
pub type Keysym = C.SDL_Keysym

fn C.SDL_GetKeyboardFocus() &C.SDL_Window

// get_keyboard_focus gets the window which currently has keyboard focus.
pub fn get_keyboard_focus() &Window {
	return C.SDL_GetKeyboardFocus()
}

fn C.SDL_GetKeyboardState(numkeys &int) &u8

// get_keyboard_state gets a snapshot of the current state of the keyboard.
//
// `numkeys` if non-NULL, receives the length of the returned array.
//
// returns An array of key states. Indexes into this array are obtained by using ::SDL_Scancode values.
//
// **Example**:
/*
```
const Uint8//state = SDL_GetKeyboardState(NULL);
if ( state[SDL_SCANCODE_RETURN] ) {
    printf("<RETURN> is pressed.\n");
}
```
*/
pub fn get_keyboard_state(numkeys &int) &u8 {
	return C.SDL_GetKeyboardState(numkeys)
}

fn C.SDL_GetModState() C.SDL_Keymod

// get_mod_state gets the current key modifier state for the keyboard.
pub fn get_mod_state() Keymod {
	return unsafe { Keymod(int(C.SDL_GetModState())) }
}

fn C.SDL_SetModState(modstate C.SDL_Keymod)

// set_mod_state sets the current key modifier state for the keyboard.
//
// NOTE This does not change the keyboard state, only the key modifier flags.
pub fn set_mod_state(modstate Keymod) {
	C.SDL_SetModState(C.SDL_Keymod(modstate))
}

fn C.SDL_GetKeyFromScancode(scancode C.SDL_Scancode) C.SDL_Keycode

// get_key_from_scancode gets the key code corresponding to the given scancode according
//        to the current keyboard layout.
//
// See ::SDL_Keycode for details.
//
// See also: SDL_GetKeyName()
pub fn get_key_from_scancode(scancode Scancode) Keycode {
	return Keycode(int(C.SDL_GetKeyFromScancode(C.SDL_Scancode(scancode))))
}

fn C.SDL_GetScancodeFromKey(key C.SDL_Keycode) C.SDL_Scancode

// get_scancode_from_key gets the scancode corresponding to the given key code according to the
//        current keyboard layout.
//
// See ::SDL_Scancode for details.
//
// See also: SDL_GetScancodeName()
pub fn get_scancode_from_key(key Keycode) Scancode {
	return unsafe { Scancode(int(C.SDL_GetScancodeFromKey(C.SDL_Keycode(key)))) }
}

fn C.SDL_GetScancodeName(scancode C.SDL_Scancode) &char

// get_scancode_name gets a human-readable name for a scancode.
//
// returns A pointer to the name for the scancode.
//         If the scancode doesn't have a name, this function returns
//         an empty string ("").
//
// See also: SDL_Scancode
pub fn get_scancode_name(scancode Scancode) &char {
	return C.SDL_GetScancodeName(C.SDL_Scancode(scancode))
}

fn C.SDL_GetScancodeFromName(name &char) C.SDL_Scancode

// get_scancode_from_name gets a scancode from a human-readable name
//
// returns scancode, or SDL_SCANCODE_UNKNOWN if the name wasn't recognized
//
// See also: SDL_Scancode
pub fn get_scancode_from_name(name &char) Scancode {
	return unsafe { Scancode(int(C.SDL_GetScancodeFromName(name))) }
}

fn C.SDL_GetKeyName(key C.SDL_Keycode) &char

// get_key_name gets a human-readable name for a key.
//
// returns A pointer to a UTF-8 string that stays valid at least until the next
//         call to this function. If you need it around any longer, you must
//         copy it.  If the key doesn't have a name, this function returns an
//         empty string ("").
//
// See also: SDL_Keycode
pub fn get_key_name(key Keycode) &char {
	return C.SDL_GetKeyName(C.SDL_Keycode(key))
}

fn C.SDL_GetKeyFromName(name &char) C.SDL_Keycode

// get_key_from_name gets a key code from a human-readable name
//
// returns key code, or SDLK_UNKNOWN if the name wasn't recognized
//
// See also: SDL_Keycode
pub fn get_key_from_name(name &char) Keycode {
	return Keycode(int(C.SDL_GetKeyFromName(name)))
}

fn C.SDL_StartTextInput()

// start_text_input starts accepting Unicode text input events.
//        This function will show the on-screen keyboard if supported.
//
// See also: SDL_StopTextInput()
// See also: SDL_SetTextInputRect()
// See also: SDL_HasScreenKeyboardSupport()
pub fn start_text_input() {
	C.SDL_StartTextInput()
}

fn C.SDL_IsTextInputActive() bool

// is_text_input_active returns whether or not Unicode text input events are enabled.
//
// See also: SDL_StartTextInput()
// See also: SDL_StopTextInput()
pub fn is_text_input_active() bool {
	return C.SDL_IsTextInputActive()
}

fn C.SDL_StopTextInput()

// stop_text_input stops receiving any text input events.
//        This function will hide the on-screen keyboard if supported.
//
// See also: SDL_StartTextInput()
// See also: SDL_HasScreenKeyboardSupport()
pub fn stop_text_input() {
	C.SDL_StopTextInput()
}

fn C.SDL_SetTextInputRect(rect &C.SDL_Rect)

// set_text_input_rect sets the rectangle used to type Unicode text inputs.
//        This is used as a hint for IME and on-screen keyboard placement.
//
// See also: SDL_StartTextInput()
pub fn set_text_input_rect(rect &Rect) {
	C.SDL_SetTextInputRect(rect)
}

fn C.SDL_HasScreenKeyboardSupport() bool

// has_screen_keyboard_support returns whether the platform has some screen keyboard support.
//
// returns SDL_TRUE if some keyboard support is available else SDL_FALSE.
//
// NOTE Not all screen keyboard functions are supported on all platforms.
//
// See also: SDL_IsScreenKeyboardShown()
pub fn has_screen_keyboard_support() bool {
	return C.SDL_HasScreenKeyboardSupport()
}

fn C.SDL_IsScreenKeyboardShown(window &C.SDL_Window) bool

// is_screen_keyboard_shown returns whether the screen keyboard is shown for given window.
//
// `window` The window for which screen keyboard should be queried.
//
// returns SDL_TRUE if screen keyboard is shown else SDL_FALSE.
//
// See also: SDL_HasScreenKeyboardSupport()
pub fn is_screen_keyboard_shown(window &Window) bool {
	return C.SDL_IsScreenKeyboardShown(window)
}

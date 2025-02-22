// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_keyboard.h
//

// SDL keyboard management.
//
// Please refer to the Best Keyboard Practices document for details on how
// best to accept keyboard input in various types of programs:
//
// https://wiki.libsdl.org/SDL3/BestKeyboardPractices

// This is a unique ID for a keyboard for the time it is connected to the
// system, and is never reused for the lifetime of the application.
//
// If the keyboard is disconnected and reconnected, it will get a new ID.
//
// The value 0 is an invalid ID.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type KeyboardID = u32

// C.SDL_HasKeyboard [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasKeyboard)
fn C.SDL_HasKeyboard() bool

// has_keyboard returns whether a keyboard is currently connected.
//
// returns true if a keyboard is connected, false otherwise.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_keyboards (SDL_GetKeyboards)
pub fn has_keyboard() bool {
	return C.SDL_HasKeyboard()
}

// C.SDL_GetKeyboards [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetKeyboards)
fn C.SDL_GetKeyboards(count &int) &KeyboardID

// get_keyboards gets a list of currently connected keyboards.
//
// Note that this will include any device or virtual driver that includes
// keyboard functionality, including some mice, KVM switches, motherboard
// power buttons, etc. You should wait for input from a device before you
// consider it actively in use.
//
// `count` count a pointer filled in with the number of keyboards returned, may
//              be NULL.
// returns a 0 terminated array of keyboards instance IDs or NULL on failure;
//          call SDL_GetError() for more information. This should be freed
//          with SDL_free() when it is no longer needed.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_keyboard_name_for_id (SDL_GetKeyboardNameForID)
// See also: has_keyboard (SDL_HasKeyboard)
pub fn get_keyboards(count &int) &KeyboardID {
	return C.SDL_GetKeyboards(count)
}

// C.SDL_GetKeyboardNameForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetKeyboardNameForID)
fn C.SDL_GetKeyboardNameForID(instance_id KeyboardID) &char

// get_keyboard_name_for_id gets the name of a keyboard.
//
// This function returns "" if the keyboard doesn't have a name.
//
// `instance_id` instance_id the keyboard instance ID.
// returns the name of the selected keyboard or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_keyboards (SDL_GetKeyboards)
pub fn get_keyboard_name_for_id(instance_id KeyboardID) &char {
	return &char(C.SDL_GetKeyboardNameForID(instance_id))
}

// C.SDL_GetKeyboardFocus [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetKeyboardFocus)
fn C.SDL_GetKeyboardFocus() &Window

// get_keyboard_focus querys the window which currently has keyboard focus.
//
// returns the window with keyboard focus.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_keyboard_focus() &Window {
	return C.SDL_GetKeyboardFocus()
}

// C.SDL_GetKeyboardState [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetKeyboardState)
fn C.SDL_GetKeyboardState(numkeys &int) &bool

// get_keyboard_state gets a snapshot of the current state of the keyboard.
//
// The pointer returned is a pointer to an internal SDL array. It will be
// valid for the whole lifetime of the application and should not be freed by
// the caller.
//
// A array element with a value of true means that the key is pressed and a
// value of false means that it is not. Indexes into this array are obtained
// by using SDL_Scancode values.
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
// `numkeys` numkeys if non-NULL, receives the length of the returned array.
// returns a pointer to an array of key states.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: pump_events (SDL_PumpEvents)
// See also: reset_keyboard (SDL_ResetKeyboard)
pub fn get_keyboard_state(numkeys &int) &bool {
	return &bool(C.SDL_GetKeyboardState(numkeys))
}

// C.SDL_ResetKeyboard [official documentation](https://wiki.libsdl.org/SDL3/SDL_ResetKeyboard)
fn C.SDL_ResetKeyboard()

// reset_keyboard clears the state of the keyboard.
//
// This function will generate key up events for all pressed keys.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_keyboard_state (SDL_GetKeyboardState)
pub fn reset_keyboard() {
	C.SDL_ResetKeyboard()
}

// C.SDL_GetModState [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetModState)
fn C.SDL_GetModState() Keymod

// get_mod_state gets the current key modifier state for the keyboard.
//
// returns an OR'd combination of the modifier keys for the keyboard. See
//          SDL_Keymod for details.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_keyboard_state (SDL_GetKeyboardState)
// See also: set_mod_state (SDL_SetModState)
pub fn get_mod_state() Keymod {
	return C.SDL_GetModState()
}

// C.SDL_SetModState [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetModState)
fn C.SDL_SetModState(modstate Keymod)

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
// `modstate` modstate the desired SDL_Keymod for the keyboard.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_mod_state (SDL_GetModState)
pub fn set_mod_state(modstate Keymod) {
	C.SDL_SetModState(modstate)
}

// C.SDL_GetKeyFromScancode [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetKeyFromScancode)
fn C.SDL_GetKeyFromScancode(scancode Scancode, modstate Keymod, key_event bool) Keycode

// get_key_from_scancode gets the key code corresponding to the given scancode according to the
// current keyboard layout.
//
// If you want to get the keycode as it would be delivered in key events,
// including options specified in SDL_HINT_KEYCODE_OPTIONS, then you should
// pass `key_event` as true. Otherwise this function simply translates the
// scancode based on the given modifier state.
//
// `scancode` scancode the desired SDL_Scancode to query.
// `modstate` modstate the modifier state to use when translating the scancode to
//                 a keycode.
// `key_event` key_event true if the keycode will be used in key events.
// returns the SDL_Keycode that corresponds to the given SDL_Scancode.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_key_name (SDL_GetKeyName)
// See also: get_scancode_from_key (SDL_GetScancodeFromKey)
pub fn get_key_from_scancode(scancode Scancode, modstate Keymod, key_event bool) Keycode {
	return C.SDL_GetKeyFromScancode(scancode, modstate, key_event)
}

// C.SDL_GetScancodeFromKey [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetScancodeFromKey)
fn C.SDL_GetScancodeFromKey(key Keycode, modstate &Keymod) Scancode

// get_scancode_from_key gets the scancode corresponding to the given key code according to the
// current keyboard layout.
//
// Note that there may be multiple scancode+modifier states that can generate
// this keycode, this will just return the first one found.
//
// `key` key the desired SDL_Keycode to query.
// `modstate` modstate a pointer to the modifier state that would be used when the
//                 scancode generates this key, may be NULL.
// returns the SDL_Scancode that corresponds to the given SDL_Keycode.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_key_from_scancode (SDL_GetKeyFromScancode)
// See also: get_scancode_name (SDL_GetScancodeName)
pub fn get_scancode_from_key(key Keycode, modstate &Keymod) Scancode {
	return C.SDL_GetScancodeFromKey(key, modstate)
}

// C.SDL_SetScancodeName [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetScancodeName)
fn C.SDL_SetScancodeName(scancode Scancode, const_name &char) bool

// set_scancode_name sets a human-readable name for a scancode.
//
// `scancode` scancode the desired SDL_Scancode.
// `name` name the name to use for the scancode, encoded as UTF-8. The string
//             is not copied, so the pointer given to this function must stay
//             valid while SDL is being used.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_scancode_name (SDL_GetScancodeName)
pub fn set_scancode_name(scancode Scancode, const_name &char) bool {
	return C.SDL_SetScancodeName(scancode, const_name)
}

// C.SDL_GetScancodeName [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetScancodeName)
fn C.SDL_GetScancodeName(scancode Scancode) &char

// get_scancode_name gets a human-readable name for a scancode.
//
// **Warning**: The returned name is by design not stable across platforms,
// e.g. the name for `SDL_SCANCODE_LGUI` is "Left GUI" under Linux but "Left
// Windows" under Microsoft Windows, and some scancodes like
// `SDL_SCANCODE_NONUSBACKSLASH` don't have any name at all. There are even
// scancodes that share names, e.g. `SDL_SCANCODE_RETURN` and
// `SDL_SCANCODE_RETURN2` (both called "Return"). This function is therefore
// unsuitable for creating a stable cross-platform two-way mapping between
// strings and scancodes.
//
// `scancode` scancode the desired SDL_Scancode to query.
// returns a pointer to the name for the scancode. If the scancode doesn't
//          have a name this function returns an empty string ("").
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_scancode_from_key (SDL_GetScancodeFromKey)
// See also: get_scancode_from_name (SDL_GetScancodeFromName)
// See also: set_scancode_name (SDL_SetScancodeName)
pub fn get_scancode_name(scancode Scancode) &char {
	return &char(C.SDL_GetScancodeName(scancode))
}

// C.SDL_GetScancodeFromName [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetScancodeFromName)
fn C.SDL_GetScancodeFromName(const_name &char) Scancode

// get_scancode_from_name gets a scancode from a human-readable name.
//
// `name` name the human-readable scancode name.
// returns the SDL_Scancode, or `SDL_SCANCODE_UNKNOWN` if the name wasn't
//          recognized; call SDL_GetError() for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_key_from_name (SDL_GetKeyFromName)
// See also: get_scancode_from_key (SDL_GetScancodeFromKey)
// See also: get_scancode_name (SDL_GetScancodeName)
pub fn get_scancode_from_name(const_name &char) Scancode {
	return C.SDL_GetScancodeFromName(const_name)
}

// C.SDL_GetKeyName [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetKeyName)
fn C.SDL_GetKeyName(key Keycode) &char

// get_key_name gets a human-readable name for a key.
//
// If the key doesn't have a name, this function returns an empty string ("").
//
// Letters will be presented in their uppercase form, if applicable.
//
// `key` key the desired SDL_Keycode to query.
// returns a UTF-8 encoded string of the key name.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_key_from_name (SDL_GetKeyFromName)
// See also: get_key_from_scancode (SDL_GetKeyFromScancode)
// See also: get_scancode_from_key (SDL_GetScancodeFromKey)
pub fn get_key_name(key Keycode) &char {
	return &char(C.SDL_GetKeyName(key))
}

// C.SDL_GetKeyFromName [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetKeyFromName)
fn C.SDL_GetKeyFromName(const_name &char) Keycode

// get_key_from_name gets a key code from a human-readable name.
//
// `name` name the human-readable key name.
// returns key code, or `SDLK_UNKNOWN` if the name wasn't recognized; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_key_from_scancode (SDL_GetKeyFromScancode)
// See also: get_key_name (SDL_GetKeyName)
// See also: get_scancode_from_name (SDL_GetScancodeFromName)
pub fn get_key_from_name(const_name &char) Keycode {
	return C.SDL_GetKeyFromName(const_name)
}

// C.SDL_StartTextInput [official documentation](https://wiki.libsdl.org/SDL3/SDL_StartTextInput)
fn C.SDL_StartTextInput(window &Window) bool

// start_text_input starts accepting Unicode text input events in a window.
//
// This function will enable text input (SDL_EVENT_TEXT_INPUT and
// SDL_EVENT_TEXT_EDITING events) in the specified window. Please use this
// function paired with SDL_StopTextInput().
//
// Text input events are not received by default.
//
// On some platforms using this function shows the screen keyboard and/or
// activates an IME, which can prevent some key press events from being passed
// through.
//
// `window` window the window to enable text input.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_text_input_area (SDL_SetTextInputArea)
// See also: start_text_input_with_properties (SDL_StartTextInputWithProperties)
// See also: stop_text_input (SDL_StopTextInput)
// See also: text_input_active (SDL_TextInputActive)
pub fn start_text_input(window &Window) bool {
	return C.SDL_StartTextInput(window)
}

// TextInputType is C.SDL_TextInputType
pub enum TextInputType {
	text                    = C.SDL_TEXTINPUT_TYPE_TEXT                    // `text` The input is text
	text_name               = C.SDL_TEXTINPUT_TYPE_TEXT_NAME               // `text_name` The input is a person's name
	text_email              = C.SDL_TEXTINPUT_TYPE_TEXT_EMAIL              // `text_email` The input is an e-mail address
	text_username           = C.SDL_TEXTINPUT_TYPE_TEXT_USERNAME           // `text_username` The input is a username
	text_password_hidden    = C.SDL_TEXTINPUT_TYPE_TEXT_PASSWORD_HIDDEN    // `text_password_hidden` The input is a secure password that is hidden
	text_password_visible   = C.SDL_TEXTINPUT_TYPE_TEXT_PASSWORD_VISIBLE   // `text_password_visible` The input is a secure password that is visible
	number                  = C.SDL_TEXTINPUT_TYPE_NUMBER                  // `number` The input is a number
	number_password_hidden  = C.SDL_TEXTINPUT_TYPE_NUMBER_PASSWORD_HIDDEN  // `number_password_hidden` The input is a secure PIN that is hidden
	number_password_visible = C.SDL_TEXTINPUT_TYPE_NUMBER_PASSWORD_VISIBLE // `number_password_visible` The input is a secure PIN that is visible
}

// Capitalization is C.SDL_Capitalization
pub enum Capitalization {
	none      = C.SDL_CAPITALIZE_NONE      // `none` No auto-capitalization will be done
	sentences = C.SDL_CAPITALIZE_SENTENCES // `sentences` The first letter of sentences will be capitalized
	words     = C.SDL_CAPITALIZE_WORDS     // `words` The first letter of words will be capitalized
	letters   = C.SDL_CAPITALIZE_LETTERS   // `letters` All letters will be capitalized
}

// C.SDL_StartTextInputWithProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_StartTextInputWithProperties)
fn C.SDL_StartTextInputWithProperties(window &Window, props PropertiesID) bool

// start_text_input_with_properties starts accepting Unicode text input events in a window, with properties
// describing the input.
//
// This function will enable text input (SDL_EVENT_TEXT_INPUT and
// SDL_EVENT_TEXT_EDITING events) in the specified window. Please use this
// function paired with SDL_StopTextInput().
//
// Text input events are not received by default.
//
// On some platforms using this function shows the screen keyboard and/or
// activates an IME, which can prevent some key press events from being passed
// through.
//
// These are the supported properties:
//
// - `SDL_PROP_TEXTINPUT_TYPE_NUMBER` - an SDL_TextInputType value that
//   describes text being input, defaults to SDL_TEXTINPUT_TYPE_TEXT.
// - `SDL_PROP_TEXTINPUT_CAPITALIZATION_NUMBER` - an SDL_Capitalization value
//   that describes how text should be capitalized, defaults to
//   SDL_CAPITALIZE_SENTENCES for normal text entry, SDL_CAPITALIZE_WORDS for
//   SDL_TEXTINPUT_TYPE_TEXT_NAME, and SDL_CAPITALIZE_NONE for e-mail
//   addresses, usernames, and passwords.
// - `SDL_PROP_TEXTINPUT_AUTOCORRECT_BOOLEAN` - true to enable auto completion
//   and auto correction, defaults to true.
// - `SDL_PROP_TEXTINPUT_MULTILINE_BOOLEAN` - true if multiple lines of text
//   are allowed. This defaults to true if SDL_HINT_RETURN_KEY_HIDES_IME is
//   "0" or is not set, and defaults to false if SDL_HINT_RETURN_KEY_HIDES_IME
//   is "1".
//
// On Android you can directly specify the input type:
//
// - `SDL_PROP_TEXTINPUT_ANDROID_INPUTTYPE_NUMBER` - the text input type to
//   use, overriding other properties. This is documented at
//   https://developer.android.com/reference/android/text/InputType
//
// `window` window the window to enable text input.
// `props` props the properties to use.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_text_input_area (SDL_SetTextInputArea)
// See also: start_text_input (SDL_StartTextInput)
// See also: stop_text_input (SDL_StopTextInput)
// See also: text_input_active (SDL_TextInputActive)
pub fn start_text_input_with_properties(window &Window, props PropertiesID) bool {
	return C.SDL_StartTextInputWithProperties(window, props)
}

pub const prop_textinput_type_number = C.SDL_PROP_TEXTINPUT_TYPE_NUMBER // 'SDL.textinput.type'

pub const prop_textinput_capitalization_number = C.SDL_PROP_TEXTINPUT_CAPITALIZATION_NUMBER // 'SDL.textinput.capitalization'

pub const prop_textinput_autocorrect_boolean = C.SDL_PROP_TEXTINPUT_AUTOCORRECT_BOOLEAN // 'SDL.textinput.autocorrect'

pub const prop_textinput_multiline_boolean = C.SDL_PROP_TEXTINPUT_MULTILINE_BOOLEAN // 'SDL.textinput.multiline'

pub const prop_textinput_android_inputtype_number = C.SDL_PROP_TEXTINPUT_ANDROID_INPUTTYPE_NUMBER // 'SDL.textinput.android.inputtype'

// C.SDL_TextInputActive [official documentation](https://wiki.libsdl.org/SDL3/SDL_TextInputActive)
fn C.SDL_TextInputActive(window &Window) bool

// text_input_active checks whether or not Unicode text input events are enabled for a window.
//
// `window` window the window to check.
// returns true if text input events are enabled else false.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: start_text_input (SDL_StartTextInput)
pub fn text_input_active(window &Window) bool {
	return C.SDL_TextInputActive(window)
}

// C.SDL_StopTextInput [official documentation](https://wiki.libsdl.org/SDL3/SDL_StopTextInput)
fn C.SDL_StopTextInput(window &Window) bool

// stop_text_input stops receiving any text input events in a window.
//
// If SDL_StartTextInput() showed the screen keyboard, this function will hide
// it.
//
// `window` window the window to disable text input.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: start_text_input (SDL_StartTextInput)
pub fn stop_text_input(window &Window) bool {
	return C.SDL_StopTextInput(window)
}

// C.SDL_ClearComposition [official documentation](https://wiki.libsdl.org/SDL3/SDL_ClearComposition)
fn C.SDL_ClearComposition(window &Window) bool

// clear_composition dismiss the composition window/IME without disabling the subsystem.
//
// `window` window the window to affect.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: start_text_input (SDL_StartTextInput)
// See also: stop_text_input (SDL_StopTextInput)
pub fn clear_composition(window &Window) bool {
	return C.SDL_ClearComposition(window)
}

// C.SDL_SetTextInputArea [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetTextInputArea)
fn C.SDL_SetTextInputArea(window &Window, const_rect &Rect, cursor int) bool

// set_text_input_area sets the area used to type Unicode text input.
//
// Native input methods may place a window with word suggestions near the
// cursor, without covering the text being entered.
//
// `window` window the window for which to set the text input area.
// `rect` rect the SDL_Rect representing the text input area, in window
//             coordinates, or NULL to clear it.
// `cursor` cursor the offset of the current cursor location relative to
//               `rect->x`, in window coordinates.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_text_input_area (SDL_GetTextInputArea)
// See also: start_text_input (SDL_StartTextInput)
pub fn set_text_input_area(window &Window, const_rect &Rect, cursor int) bool {
	return C.SDL_SetTextInputArea(window, const_rect, cursor)
}

// C.SDL_GetTextInputArea [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTextInputArea)
fn C.SDL_GetTextInputArea(window &Window, rect &Rect, cursor &int) bool

// get_text_input_area gets the area used to type Unicode text input.
//
// This returns the values previously set by SDL_SetTextInputArea().
//
// `window` window the window for which to query the text input area.
// `rect` rect a pointer to an SDL_Rect filled in with the text input area,
//             may be NULL.
// `cursor` cursor a pointer to the offset of the current cursor location
//               relative to `rect->x`, may be NULL.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_text_input_area (SDL_SetTextInputArea)
pub fn get_text_input_area(window &Window, rect &Rect, cursor &int) bool {
	return C.SDL_GetTextInputArea(window, rect, cursor)
}

// C.SDL_HasScreenKeyboardSupport [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasScreenKeyboardSupport)
fn C.SDL_HasScreenKeyboardSupport() bool

// has_screen_keyboard_support checks whether the platform has screen keyboard support.
//
// returns true if the platform has some screen keyboard support or false if
//          not.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: start_text_input (SDL_StartTextInput)
// See also: screen_keyboard_shown (SDL_ScreenKeyboardShown)
pub fn has_screen_keyboard_support() bool {
	return C.SDL_HasScreenKeyboardSupport()
}

// C.SDL_ScreenKeyboardShown [official documentation](https://wiki.libsdl.org/SDL3/SDL_ScreenKeyboardShown)
fn C.SDL_ScreenKeyboardShown(window &Window) bool

// screen_keyboard_shown checks whether the screen keyboard is shown for given window.
//
// `window` window the window for which screen keyboard should be queried.
// returns true if screen keyboard is shown or false if not.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_screen_keyboard_support (SDL_HasScreenKeyboardSupport)
pub fn screen_keyboard_shown(window &Window) bool {
	return C.SDL_ScreenKeyboardShown(window)
}

// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_clipboard.h
//

/**
 * \brief Put UTF-8 text into the clipboard
 *
 * \sa SDL_GetClipboardText()
*/
fn C.SDL_SetClipboardText(text &char) int
pub fn set_clipboard_text(text string) int {
	return C.SDL_SetClipboardText(text.str)
}

/**
 * \brief Get UTF-8 text from the clipboard, which must be freed with SDL_free()
 *
 * \sa SDL_SetClipboardText()
*/
fn C.SDL_GetClipboardText() &char
pub fn get_clipboard_text() string {
	return unsafe { cstring_to_vstring(C.SDL_GetClipboardText()) }
}

/**
 * \brief Returns a flag indicating whether the clipboard exists and contains a text string that is non-empty
 *
 * \sa SDL_GetClipboardText()
*/
fn C.SDL_HasClipboardText() bool
pub fn has_clipboard_text() bool {
	return C.SDL_HasClipboardText()
}

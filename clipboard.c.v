// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_clipboard.h
//

fn C.SDL_SetClipboardText(text &char) int

// set_clipboard_text puts UTF-8 text into the clipboard.
//
// `text` the text to store in the clipboard
// returns 0 on success or a negative error code on failure; call
//         SDL_GetError() for more information.
//
// See also: SDL_GetClipboardText
// See also: SDL_HasClipboardText
pub fn set_clipboard_text(text &char) int {
	return C.SDL_SetClipboardText(text)
}

fn C.SDL_GetClipboardText() &char

// get_clipboard_text gets UTF-8 text from the clipboard, which must be freed with SDL_free().
//
// This functions returns NULL if there was not enough memory left for a copy
// of the clipboard's content.
//
// returns the clipboard text on success or NULL on failure; call
//         SDL_GetError() for more information. Caller must call SDL_free()
//         on the returned pointer when done with it.
//
// See also: SDL_HasClipboardText
// See also: SDL_SetClipboardText
pub fn get_clipboard_text() &char {
	return C.SDL_GetClipboardText()
}

fn C.SDL_HasClipboardText() bool

// has_clipboard_text queries whether the clipboard exists and contains a non-empty text string.
//
// returns SDL_TRUE if the clipboard has text, or SDL_FALSE if it does not.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetClipboardText
// See also: SDL_SetClipboardText
pub fn has_clipboard_text() bool {
	return C.SDL_HasClipboardText()
}

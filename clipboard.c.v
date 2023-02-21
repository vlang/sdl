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
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetClipboardText
// See also: SDL_HasClipboardText
pub fn set_clipboard_text(text &char) int {
	return C.SDL_SetClipboardText(text)
}

fn C.SDL_GetClipboardText() &char

// get_clipboard_text gets UTF-8 text from the clipboard, which must be freed with SDL_free().
//
// This functions returns empty string if there was not enough memory left for
// a copy of the clipboard's content.
//
// returns the clipboard text on success or an empty string on failure; call
//         SDL_GetError() for more information. Caller must call SDL_free()
//         on the returned pointer when done with it (even if there was an
//         error).
//
// NOTE This function is available since SDL 2.0.0.
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

fn C.SDL_SetPrimarySelectionText(const_text &char) int

// set_primary_selection_text puts UTF-8 text into the primary selection.
//
// `text` the text to store in the primary selection
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.26.0.
//
// See also: SDL_GetPrimarySelectionText
// See also: SDL_HasPrimarySelectionText
pub fn set_primary_selection_text(const_text &char) int {
	return C.SDL_SetPrimarySelectionText(const_text)
}

fn C.SDL_GetPrimarySelectionText() &char

// get_primary_selection_text gets UTF-8 text from the primary selection, which must be freed with
// SDL_free().
//
// This functions returns empty string if there was not enough memory left for
// a copy of the primary selection's content.
//
// returns the primary selection text on success or an empty string on
//          failure; call SDL_GetError() for more information. Caller must
//          call SDL_free() on the returned pointer when done with it (even if
//          there was an error).
//
// NOTE This function is available since SDL 2.26.0.
//
// See also: SDL_HasPrimarySelectionText
// See also: SDL_SetPrimarySelectionText
pub fn get_primary_selection_text() &char {
	return C.SDL_GetPrimarySelectionText()
}

fn C.SDL_HasPrimarySelectionText() bool

// has_primary_selection_text querys whether the primary selection exists and contains a non-empty text
// string.
//
// returns SDL_TRUE if the primary selection has text, or SDL_FALSE if it
//          does not.
//
// NOTE This function is available since SDL 2.26.0.
//
// See also: SDL_GetPrimarySelectionText
// See also: SDL_SetPrimarySelectionText
pub fn has_primary_selection_text() bool {
	return C.SDL_HasPrimarySelectionText()
}

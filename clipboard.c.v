// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_clipboard.h
//

fn C.SDL_SetClipboardText(text &char) int

// set_clipboard_text puts UTF-8 text into the clipboard
//
// See also: SDL_GetClipboardText()
pub fn set_clipboard_text(text &char) int {
	return C.SDL_SetClipboardText(text)
}

fn C.SDL_GetClipboardText() &char

// get_clipboard_text gets UTF-8 text from the clipboard, which must be freed with SDL_free()
//
// See also: SDL_SetClipboardText()
pub fn get_clipboard_text() &char {
	return C.SDL_GetClipboardText()
}

fn C.SDL_HasClipboardText() bool

// has_clipboard_text returns a flag indicating whether the clipboard exists and contains a text string that is non-empty
//
// See also: SDL_GetClipboardText()
pub fn has_clipboard_text() bool {
	return C.SDL_HasClipboardText()
}

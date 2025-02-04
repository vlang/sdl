// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_clipboard.h
//

// SDL provides access to the system clipboard, both for reading information
// from other processes and publishing information of its own.
//
// This is not just text! SDL apps can access and publish data by mimetype.
//
// ## Basic use (text)
//
// Obtaining and publishing simple text to the system clipboard is as easy as
// calling SDL_GetClipboardText() and SDL_SetClipboardText(), respectively.
// These deal with C strings in UTF-8 encoding. Data transmission and encoding
// conversion is completely managed by SDL.
//
// ## Clipboard callbacks (data other than text)
//
// Things get more complicated when the clipboard contains something other
// than text. Not only can the system clipboard contain data of any type, in
// some cases it can contain the same data in different formats! For example,
// an image painting app might let the user copy a graphic to the clipboard,
// and offers it in .BMP, .JPG, or .PNG format for other apps to consume.
//
// Obtaining clipboard data ("pasting") like this is a matter of calling
// SDL_GetClipboardData() and telling it the mimetype of the data you want.
// But how does one know if that format is available? SDL_HasClipboardData()
// can report if a specific mimetype is offered, and
// SDL_GetClipboardMimeTypes() can provide the entire list of mimetypes
// available, so the app can decide what to do with the data and what formats
// it can support.
//
// Setting the clipboard ("copying") to arbitrary data is done with
// SDL_SetClipboardData. The app does not provide the data in this call, but
// rather the mimetypes it is willing to provide and a callback function.
// During the callback, the app will generate the data. This allows massive
// data sets to be provided to the clipboard, without any data being copied
// before it is explicitly requested. More specifically, it allows an app to
// offer data in multiple formats without providing a copy of all of them
// upfront. If the app has an image that it could provide in PNG or JPG
// format, it doesn't have to encode it to either of those unless and until
// something tries to paste it.
//
// ## Primary Selection
//
// The X11 and Wayland video targets have a concept of the "primary selection"
// in addition to the usual clipboard. This is generally highlighted (but not
// explicitly copied) text from various apps. SDL offers APIs for this through
// SDL_GetPrimarySelectionText() and SDL_SetPrimarySelectionText(). SDL offers
// these APIs on platforms without this concept, too, but only so far that it
// will keep a copy of a string that the app sets for later retrieval; the
// operating system will not ever attempt to change the string externally if
// it doesn't support a primary selection.

// C.SDL_SetClipboardText [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetClipboardText)
fn C.SDL_SetClipboardText(const_text &char) bool

// set_clipboard_text puts UTF-8 text into the clipboard.
//
// `text` text the text to store in the clipboard.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_clipboard_text (SDL_GetClipboardText)
// See also: has_clipboard_text (SDL_HasClipboardText)
pub fn set_clipboard_text(const_text &char) bool {
	return C.SDL_SetClipboardText(const_text)
}

// C.SDL_GetClipboardText [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetClipboardText)
fn C.SDL_GetClipboardText() &char

// get_clipboard_text gets UTF-8 text from the clipboard.
//
// This functions returns an empty string if there was not enough memory left
// for a copy of the clipboard's content.
//
// returns the clipboard text on success or an empty string on failure; call
//          SDL_GetError() for more information. This should be freed with
//          SDL_free() when it is no longer needed.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_clipboard_text (SDL_HasClipboardText)
// See also: set_clipboard_text (SDL_SetClipboardText)
pub fn get_clipboard_text() &char {
	return C.SDL_GetClipboardText()
}

// C.SDL_HasClipboardText [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasClipboardText)
fn C.SDL_HasClipboardText() bool

// has_clipboard_text querys whether the clipboard exists and contains a non-empty text string.
//
// returns true if the clipboard has text, or false if it does not.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_clipboard_text (SDL_GetClipboardText)
// See also: set_clipboard_text (SDL_SetClipboardText)
pub fn has_clipboard_text() bool {
	return C.SDL_HasClipboardText()
}

// C.SDL_SetPrimarySelectionText [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetPrimarySelectionText)
fn C.SDL_SetPrimarySelectionText(const_text &char) bool

// set_primary_selection_text puts UTF-8 text into the primary selection.
//
// `text` text the text to store in the primary selection.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_primary_selection_text (SDL_GetPrimarySelectionText)
// See also: has_primary_selection_text (SDL_HasPrimarySelectionText)
pub fn set_primary_selection_text(const_text &char) bool {
	return C.SDL_SetPrimarySelectionText(const_text)
}

// C.SDL_GetPrimarySelectionText [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetPrimarySelectionText)
fn C.SDL_GetPrimarySelectionText() &char

// get_primary_selection_text gets UTF-8 text from the primary selection.
//
// This functions returns an empty string if there was not enough memory left
// for a copy of the primary selection's content.
//
// returns the primary selection text on success or an empty string on
//          failure; call SDL_GetError() for more information. This should be
//          freed with SDL_free() when it is no longer needed.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_primary_selection_text (SDL_HasPrimarySelectionText)
// See also: set_primary_selection_text (SDL_SetPrimarySelectionText)
pub fn get_primary_selection_text() &char {
	return C.SDL_GetPrimarySelectionText()
}

// C.SDL_HasPrimarySelectionText [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasPrimarySelectionText)
fn C.SDL_HasPrimarySelectionText() bool

// has_primary_selection_text querys whether the primary selection exists and contains a non-empty text
// string.
//
// returns true if the primary selection has text, or false if it does not.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_primary_selection_text (SDL_GetPrimarySelectionText)
// See also: set_primary_selection_text (SDL_SetPrimarySelectionText)
pub fn has_primary_selection_text() bool {
	return C.SDL_HasPrimarySelectionText()
}

// ClipboardDataCallback callbacks function that will be called when data for the specified mime-type
// is requested by the OS.
//
// The callback function is called with NULL as the mime_type when the
// clipboard is cleared or new data is set. The clipboard is automatically
// cleared in SDL_Quit().
//
// `userdata` userdata a pointer to provided user data.
// `mime_type` mime_type the requested mime-type.
// `size` size a pointer filled in with the length of the returned data.
// returns a pointer to the data for the provided mime-type. Returning NULL
//          or setting length to 0 will cause no data to be sent to the
//          "receiver". It is up to the receiver to handle this. Essentially
//          returning no data is more or less undefined behavior and may cause
//          breakage in receiving applications. The returned data will not be
//          freed so it needs to be retained and dealt with internally.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_clipboard_data (SDL_SetClipboardData)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_ClipboardDataCallback)
pub type ClipboardDataCallback = fn (userdata voidptr, const_mime_type &char, size &usize) voidptr

// ClipboardCleanupCallback callbacks function that will be called when the clipboard is cleared, or new
// data is set.
//
// `userdata` userdata a pointer to provided user data.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_clipboard_data (SDL_SetClipboardData)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_ClipboardCleanupCallback)
pub type ClipboardCleanupCallback = fn (userdata voidptr)

// C.SDL_SetClipboardData [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetClipboardData)
fn C.SDL_SetClipboardData(callback ClipboardDataCallback, cleanup ClipboardCleanupCallback, userdata voidptr, const_mime_types &&char, num_mime_types usize) bool

// set_clipboard_data offers clipboard data to the OS.
//
// Tell the operating system that the application is offering clipboard data
// for each of the provided mime-types. Once another application requests the
// data the callback function will be called, allowing it to generate and
// respond with the data for the requested mime-type.
//
// The size of text data does not include any terminator, and the text does
// not need to be null terminated (e.g. you can directly copy a portion of a
// document).
//
// `callback` callback a function pointer to the function that provides the
//                 clipboard data.
// `cleanup` cleanup a function pointer to the function that cleans up the
//                clipboard data.
// `userdata` userdata an opaque pointer that will be forwarded to the callbacks.
// `mime_types` mime_types a list of mime-types that are being offered.
// `num_mime_types` num_mime_types the number of mime-types in the mime_types list.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: clear_clipboard_data (SDL_ClearClipboardData)
// See also: get_clipboard_data (SDL_GetClipboardData)
// See also: has_clipboard_data (SDL_HasClipboardData)
pub fn set_clipboard_data(callback ClipboardDataCallback, cleanup ClipboardCleanupCallback, userdata voidptr, const_mime_types &&char, num_mime_types usize) bool {
	return C.SDL_SetClipboardData(callback, cleanup, userdata, const_mime_types, num_mime_types)
}

// C.SDL_ClearClipboardData [official documentation](https://wiki.libsdl.org/SDL3/SDL_ClearClipboardData)
fn C.SDL_ClearClipboardData() bool

// clear_clipboard_data clears the clipboard data.
//
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_clipboard_data (SDL_SetClipboardData)
pub fn clear_clipboard_data() bool {
	return C.SDL_ClearClipboardData()
}

// C.SDL_GetClipboardData [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetClipboardData)
fn C.SDL_GetClipboardData(const_mime_type &char, size &usize) voidptr

// get_clipboard_data gets the data from clipboard for a given mime type.
//
// The size of text data does not include the terminator, but the text is
// guaranteed to be null terminated.
//
// `mime_type` mime_type the mime type to read from the clipboard.
// `size` size a pointer filled in with the length of the returned data.
// returns the retrieved data buffer or NULL on failure; call SDL_GetError()
//          for more information. This should be freed with SDL_free() when it
//          is no longer needed.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_clipboard_data (SDL_HasClipboardData)
// See also: set_clipboard_data (SDL_SetClipboardData)
pub fn get_clipboard_data(const_mime_type &char, size &usize) voidptr {
	return C.SDL_GetClipboardData(const_mime_type, size)
}

// C.SDL_HasClipboardData [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasClipboardData)
fn C.SDL_HasClipboardData(const_mime_type &char) bool

// has_clipboard_data querys whether there is data in the clipboard for the provided mime type.
//
// `mime_type` mime_type the mime type to check for data for.
// returns true if there exists data in clipboard for the provided mime type,
//          false if it does not.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_clipboard_data (SDL_SetClipboardData)
// See also: get_clipboard_data (SDL_GetClipboardData)
pub fn has_clipboard_data(const_mime_type &char) bool {
	return C.SDL_HasClipboardData(const_mime_type)
}

// C.SDL_GetClipboardMimeTypes [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetClipboardMimeTypes)
fn C.SDL_GetClipboardMimeTypes(num_mime_types &usize) &&char

// get_clipboard_mime_types retrieves the list of mime types available in the clipboard.
//
// `num_mime_types` num_mime_types a pointer filled with the number of mime types, may
//                       be NULL.
// returns a null terminated array of strings with mime types, or NULL on
//          failure; call SDL_GetError() for more information. This should be
//          freed with SDL_free() when it is no longer needed.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_clipboard_data (SDL_SetClipboardData)
pub fn get_clipboard_mime_types(num_mime_types &usize) &&char {
	return C.SDL_GetClipboardMimeTypes(num_mime_types)
}

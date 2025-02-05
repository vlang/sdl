// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_guid.h
//

// A GUID is a 128-bit value that represents something that is uniquely
// identifiable by this value: "globally unique."
//
// SDL provides functions to convert a GUID to/from a string.

@[typedef]
pub struct C.SDL_GUID {
	data [16]u8
}

pub type GUID = C.SDL_GUID

// C.SDL_GUIDToString [official documentation](https://wiki.libsdl.org/SDL3/SDL_GUIDToString)
fn C.SDL_GUIDToString(guid GUID, psz_guid &char, cb_guid int)

// guid_to_string gets an ASCII string representation for a given SDL_GUID.
//
// `guid` guid the SDL_GUID you wish to convert to string.
// `psz_guid` pszGUID buffer in which to write the ASCII string.
// `cb_guid` cbGUID the size of pszGUID, should be at least 33 bytes.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: string_to_guid (SDL_StringToGUID)
pub fn guid_to_string(guid GUID, psz_guid &char, cb_guid int) {
	C.SDL_GUIDToString(guid, psz_guid, cb_guid)
}

// C.SDL_StringToGUID [official documentation](https://wiki.libsdl.org/SDL3/SDL_StringToGUID)
fn C.SDL_StringToGUID(const_pch_guid &char) GUID

// string_to_guid converts a GUID string into a SDL_GUID structure.
//
// Performs no error checking. If this function is given a string containing
// an invalid GUID, the function will silently succeed, but the GUID generated
// will not be useful.
//
// `pch_guid` pchGUID string containing an ASCII representation of a GUID.
// returns a SDL_GUID structure.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: guid_to_string (SDL_GUIDToString)
pub fn string_to_guid(const_pch_guid &char) GUID {
	return C.SDL_StringToGUID(const_pch_guid)
}

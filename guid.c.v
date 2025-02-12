// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_guid.h
//

// A GUID is a 128-bit value that represents something that is uniquely
// identifiable by this value: "globally unique."

// GUID
// An SDL_GUID is a 128-bit identifier.
//
// This is an acronym for "Globally Unique ID."
//
// While a GUID can be used to assign a unique value to almost anything, in
// SDL these are largely used to identify input devices across runs of SDL
// programs on the same platform.If the device is detached and then
// re-attached to a different port, or if the base system is rebooted, the
// device should still report the same GUID.
//
// GUIDs are as precise as possible but are not guaranteed to distinguish
// physically distinct but equivalent devices. For example, two game
// controllers from the same vendor with the same product ID and revision may
// have the same GUID.
//
// GUIDs may be platform-dependent (i.e., the same device may report different
// GUIDs on different operating systems).
@[typedef]
struct C.SDL_GUID {
	data [16]u8
}

pub type GUID = C.SDL_GUID

fn C.SDL_GUIDToString(guid C.SDL_GUID, psz_guid &char, cb_guid int)

// guid_to_string gets an ASCII string representation for a given SDL_GUID.
//
// You should supply at least 33 bytes for pszGUID.
//
// `guid` the SDL_GUID you wish to convert to string.
// `pszGUID` buffer in which to write the ASCII string.
// `cbGUID` the size of pszGUID.
//
// NOTE: This function is available since SDL 2.24.0.
//
// See also: SDL_GUIDFromString
pub fn guid_to_string(guid GUID, psz_guid &char, cb_guid int) {
	C.SDL_GUIDToString(guid, psz_guid, cb_guid)
}

fn C.SDL_GUIDFromString(const_pch_guid &char) C.SDL_GUID

// guid_from_string converts a GUID string into a SDL_GUID structure.
//
// Performs no error checking. If this function is given a string containing
// an invalid GUID, the function will silently succeed, but the GUID generated
// will not be useful.
//
// `pchGUID` string containing an ASCII representation of a GUID.
// returns a SDL_GUID structure.
//
// NOTE: This function is available since SDL 2.24.0.
//
// See also: SDL_GUIDToString
pub fn guid_from_string(const_pch_guid &char) GUID {
	return C.SDL_GUIDFromString(const_pch_guid)
}

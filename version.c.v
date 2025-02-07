// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_version.h
//

// Functionality to query the current SDL version, both as headers the app was
// compiled against, and a library the app is linked to.

// compiled_version_string is a function added by the V wrapper to make it easier to
// transition from the `Version` struct used in SDL2.
pub fn compiled_version_string() string {
	return '${u8(major_version)}.${u8(minor_version)}.${u8(micro_version)}'
}

// linked_version_string is a function added by the V wrapper to make it easier to
// transition from the `Version` struct used in SDL2.
pub fn linked_version_string() string {
	sdl_version := get_version()
	major := versionnum_major(sdl_version)
	minor := versionnum_minor(sdl_version)
	micro := versionnum_micro(sdl_version)
	return '${major}.${minor}.${micro}'
}

// The current major version of SDL headers.
//
// If this were SDL version 3.2.1, this value would be 3.
//
// NOTE: This macro is available since SDL 3.2.0.
pub const major_version = C.SDL_MAJOR_VERSION // 3

// The current minor version of the SDL headers.
//
// If this were SDL version 3.2.1, this value would be 2.
//
// NOTE: This macro is available since SDL 3.2.0.
pub const minor_version = C.SDL_MINOR_VERSION // 2

// The current micro (or patchlevel) version of the SDL headers.
//
// If this were SDL version 3.2.1, this value would be 1.
//
// NOTE: This macro is available since SDL 3.2.0.
pub const micro_version = C.SDL_MICRO_VERSION // 0

// C.SDL_VERSIONNUM [official documentation](https://wiki.libsdl.org/SDL3/SDL_VERSIONNUM)
fn C.SDL_VERSIONNUM(x int, y int, z int) int

// This macro turns the version numbers into a numeric value.
//
// (1,2,3) becomes 1002003.
//
// `major` the major version number.
// `minor` the minorversion number.
// `patch` the patch version number.
//
// NOTE: This macro is available since SDL 3.2.0.
pub fn versionnum(x int, y int, z int) int {
	return C.SDL_VERSIONNUM(x, y, z)
}

// C.SDL_VERSIONNUM_MAJOR [official documentation](https://wiki.libsdl.org/SDL3/SDL_VERSIONNUM_MAJOR)
fn C.SDL_VERSIONNUM_MAJOR(version int) int

// This macro extracts the major version from a version number
//
// 1002003 becomes 1.
//
// `version` the version number.
//
// NOTE: This macro is available since SDL 3.2.0.
pub fn versionnum_major(version int) int {
	return C.SDL_VERSIONNUM_MAJOR(version)
}

// C.SDL_VERSIONNUM_MINOR [official documentation](https://wiki.libsdl.org/SDL3/SDL_VERSIONNUM_MINOR)
fn C.SDL_VERSIONNUM_MINOR(version int) int

// This macro extracts the minor version from a version number
//
// 1002003 becomes 2.
//
// `version` the version number.
//
// NOTE: This macro is available since SDL 3.2.0.
pub fn versionnum_minor(version int) int {
	return C.SDL_VERSIONNUM_MINOR(version)
}

// C.SDL_VERSIONNUM_MICRO [official documentation](https://wiki.libsdl.org/SDL3/SDL_VERSIONNUM_MICRO)
fn C.SDL_VERSIONNUM_MICRO(version int) int

// This macro extracts the micro version from a version number
//
// 1002003 becomes 3.
//
// `version` the version number.
//
// NOTE: This macro is available since SDL 3.2.0.
pub fn versionnum_micro(version int) int {
	return C.SDL_VERSIONNUM_MICRO(version)
}

// C.SDL_VERSION [official documentation](https://wiki.libsdl.org/SDL3/SDL_VERSION)
fn C.SDL_VERSION() int

// This is the version number macro for the current SDL version.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: get_version (SDL_GetVersion)
pub fn version() int {
	// return C.SDL_VERSION()
	return versionnum(major_version, minor_version, micro_version)
}

// C.SDL_VERSION_ATLEAST [official documentation](https://wiki.libsdl.org/SDL3/SDL_VERSION_ATLEAST)
fn C.SDL_VERSION_ATLEAST(x int, y int, z int) bool

// This macro will evaluate to true if compiled with SDL at least X.Y.Z.
//
// NOTE: This macro is available since SDL 3.2.0.
pub fn version_atleast(x int, y int, z int) bool {
	return C.SDL_VERSION_ATLEAST(x, y, z)
}

// C.SDL_GetVersion [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetVersion)
fn C.SDL_GetVersion() int

// get_version gets the version of SDL that is linked against your program.
//
// If you are linking to SDL dynamically, then it is possible that the current
// version will be different than the version you compiled against. This
// function returns the current version, while SDL_VERSION is the version you
// compiled with.
//
// This function may be called safely at any time, even before SDL_Init().
//
// returns the version of the linked library.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_revision (SDL_GetRevision)
pub fn get_version() int {
	return C.SDL_GetVersion()
}

// C.SDL_GetRevision [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRevision)
fn C.SDL_GetRevision() &char

// get_revision gets the code revision of SDL that is linked against your program.
//
// This value is the revision of the code you are linked with and may be
// different from the code you are compiling with, which is found in the
// constant SDL_REVISION.
//
// The revision is arbitrary string (a hash value) uniquely identifying the
// exact revision of the SDL library in use, and is only useful in comparing
// against other revisions. It is NOT an incrementing number.
//
// If SDL wasn't built from a git repository with the appropriate tools, this
// will return an empty string.
//
// You shouldn't use this function for anything but logging it for debugging
// purposes. The string is not intended to be reliable in any way.
//
// returns an arbitrary string, uniquely identifying the exact revision of
//          the SDL library in use.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_version (SDL_GetVersion)
pub fn get_revision() &char {
	return C.SDL_GetRevision()
}

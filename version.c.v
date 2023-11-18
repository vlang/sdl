// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_version.h
//

pub const (
	major_version = C.SDL_MAJOR_VERSION // 2
	minor_version = C.SDL_MINOR_VERSION // 28
	patchlevel    = C.SDL_PATCHLEVEL // 0
)

// Version is information about the version of SDL in use.
//
// Represents the library's version as three levels: major revision
// (increments with massive changes, additions, and enhancements),
// minor revision (increments with backwards-compatible changes to the
// major revision), and patchlevel (increments with fixes to the minor
// revision).
//
// See also: SDL_VERSION
// See also: SDL_GetVersion
@[typedef]
pub struct C.SDL_version {
pub:
	major u8 // major version
	minor u8 // minor version
	patch u8 // update version
}

pub fn (ver C.SDL_version) str() string {
	return '${ver.major}.${ver.minor}.${ver.patch}'
}

pub type Version = C.SDL_version

fn C.SDL_VERSION(ver &C.SDL_version)

// SDL_VERSION is a macro to determine SDL version program was compiled against.
//
// This macro fills in a SDL_version structure with the version of the
// library you compiled against. This is determined by what header the
// compiler uses. Note that if you dynamically linked the library, you might
// have a slightly newer or older version at runtime. That version can be
// determined with SDL_GetVersion(), which, unlike SDL_VERSION(),
// is not a macro.
//
// `x` A pointer to a SDL_version struct to initialize.
//
// See also: SDL_version
// See also: SDL_GetVersion
pub fn version(mut ver Version) {
	C.SDL_VERSION(&ver)
}

// This macro turns the version numbers into a numeric value:
/*
```
    (1,2,3) -> (1203)
```
*/
//
// This assumes that there will never be more than 100 patchlevels.
//
// In versions higher than 2.9.0, the minor version overflows into
// the thousands digit: for example, 2.23.0 is encoded as 4300,
// and 2.255.99 would be encoded as 25799.
// This macro will not be available in SDL 3.x.
pub fn C.SDL_VERSIONNUM(x int, y int, z int) int

// SDL_COMPILEDVERSION is the version number macro for the current SDL version.
//
// In versions higher than 2.9.0, the minor version overflows into
// the thousands digit: for example, 2.23.0 is encoded as 4300.
// This macro will not be available in SDL 3.x.
//
// Deprecated, use SDL_VERSION_ATLEAST or SDL_VERSION instead.
pub fn C.SDL_COMPILEDVERSION() int

// SDL_VERSION_ATLEAST macro will evaluate to true if compiled with SDL at least X.Y.Z.
pub fn C.SDL_VERSION_ATLEAST(x int, y int, z int) bool

fn C.SDL_GetVersion(ver &C.SDL_version)

// get_version gets the version of SDL that is linked against your program.
//
// If you are linking to SDL dynamically, then it is possible that the
// current version will be different than the version you compiled against.
// This function returns the current version, while SDL_VERSION() is a
// macro that tells you what version you compiled with.
//
/*
```
SDL_version compiled;
SDL_version linked;

SDL_VERSION(&compiled);
SDL_GetVersion(&linked);
printf("We compiled against SDL version %d.%d.%d ...\n", compiled.major, compiled.minor, compiled.patch);
printf("But we linked against SDL version %d.%d.%d.\n", linked.major, linked.minor, linked.patch);
```
*/
//
// This function may be called safely at any time, even before SDL_Init().
//
// `ver` the SDL_version structure that contains the version information
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_VERSION
// Seealso: SDL_GetRevision
pub fn get_version(mut ver Version) {
	C.SDL_GetVersion(&ver)
}

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
// Prior to SDL 2.0.16, before development moved to GitHub, this returned a
// hash for a Mercurial repository.
//
// You shouldn't use this function for anything but logging it for debugging
// purposes. The string is not intended to be reliable in any way.
//
// returns an arbitrary string, uniquely identifying the exact revision of
//          the SDL library in use.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetVersion
pub fn get_revision() &char {
	return C.SDL_GetRevision()
}

fn C.SDL_GetRevisionNumber() int

// get_revision_number is an obsolete function, do not use.
//
// When SDL was hosted in a Mercurial repository, and was built carefully,
// this would return the revision number that the build was created from. This
// number was not reliable for several reasons, but more importantly, SDL is
// now hosted in a git repository, which does not offer numbers at all, only
// hashes. This function only ever returns zero now. Don't use it.
//
// Before SDL 2.0.16, this might have returned an unreliable, but non-zero
// number.
//
// deprecated Use SDL_GetRevision() instead; if SDL was carefully built, it
//             will return a git hash.
//
// returns zero, always, in modern SDL releases.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also SDL_GetRevision
@[deprecated: 'Use SDL_GetRevision() instead; if SDL was carefully built, it will return a git hash.']
pub fn get_revision_number() int {
	return C.SDL_GetRevisionNumber()
}

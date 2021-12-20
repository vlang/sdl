// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_version.h
//

const (
major_version                       = C.SDL_MAJOR_VERSION // 2
minor_version                       = C.SDL_MINOR_VERSION // 0
patchlevel                       = C.SDL_PATCHLEVEL      // 8
)

/**
 *  \brief Information the version of SDL in use.
 *
 *  Represents the library's version as three levels: major revision
 *  (increments with massive changes, additions, and enhancements),
 *  minor revision (increments with backwards-compatible changes to the
 *  major revision), and patchlevel (increments with fixes to the minor
 *  revision).
 *
 *  \sa SDL_VERSION
 *  \sa SDL_GetVersion
 */
[typedef]
struct C.SDL_version {
	major byte // major version
	minor byte // minor version
	patch byte // update version
}
pub type Version = C.SDL_version

/**
 *  \brief Macro to determine SDL version program was compiled against.
 *
 *  This macro fills in a SDL_version structure with the version of the
 *  library you compiled against. This is determined by what header the
 *  compiler uses. Note that if you dynamically linked the library, you might
 *  have a slightly newer or older version at runtime. That version can be
 *  determined with SDL_GetVersion(), which, unlike SDL_VERSION(),
 *  is not a macro.
 *
 *  \param x A pointer to a SDL_version struct to initialize.
 *
 *  \sa SDL_version
 *  \sa SDL_GetVersion
 */
pub fn C.SDL_VERSION(ver &C.SDL_version)

/**
 *  This macro turns the version numbers into a numeric value:
 *  \verbatim
    (1,2,3) -> (1203)
    \endverbatim
 *
 *  This assumes that there will never be more than 100 patchlevels.
 */
pub fn C.SDL_VERSIONNUM(x int, y int, z int) int

/**
 *  This is the version number macro for the current SDL version.
 */
pub fn C.SDL_COMPILEDVERSION() int

/**
 *  This macro will evaluate to true if compiled with SDL at least X.Y.Z.
 */
pub fn C.SDL_VERSION_ATLEAST(x int, y int, z int) bool

/**
 *  \brief Get the version of SDL that is linked against your program.
 *
 *  If you are linking to SDL dynamically, then it is possible that the
 *  current version will be different than the version you compiled against.
 *  This function returns the current version, while SDL_VERSION() is a
 *  macro that tells you what version you compiled with.
 *
 *  \code
 *  SDL_version compiled;
 *  SDL_version linked;
 *
 *  SDL_VERSION(&compiled);
 *  SDL_GetVersion(&linked);
 *  printf("We compiled against SDL version %d.%d.%d ...\n",
 *         compiled.major, compiled.minor, compiled.patch);
 *  printf("But we linked against SDL version %d.%d.%d.\n",
 *         linked.major, linked.minor, linked.patch);
 *  \endcode
 *
 *  This function may be called safely at any time, even before SDL_Init().
 *
 *  \sa SDL_VERSION
 */
fn C.SDL_GetVersion(ver &C.SDL_version)
pub fn get_version(ver &Version){
	 C.SDL_GetVersion(ver)
}

/**
 *  \brief Get the code revision of SDL that is linked against your program.
 *
 *  Returns an arbitrary string (a hash value) uniquely identifying the
 *  exact revision of the SDL library in use, and is only useful in comparing
 *  against other revisions. It is NOT an incrementing number.
 */
fn C.SDL_GetRevision() &char
pub fn get_revision() string {
	return unsafe { cstring_to_vstring(C.SDL_GetRevision()) }
}

/**
 *  \brief Get the revision number of SDL that is linked against your program.
 *
 *  Returns a number uniquely identifying the exact revision of the SDL
 *  library in use. It is an incrementing number based on commits to
 *  hg.libsdl.org.
 */
fn C.SDL_GetRevisionNumber() int
pub fn get_revision_number() int{
	return C.SDL_GetRevisionNumber()
}

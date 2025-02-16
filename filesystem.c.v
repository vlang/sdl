// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_filesystem.h
//

// SDL offers an API for examining and manipulating the system's filesystem.
// This covers most things one would need to do with directories, except for
// actual file I/O (which is covered by [CategoryIOStream](CategoryIOStream)
// and [CategoryAsyncIO](CategoryAsyncIO) instead).
//
// There are functions to answer necessary path questions:
//
// - Where is my app's data? SDL_GetBasePath().
// - Where can I safely write files? SDL_GetPrefPath().
// - Where are paths like Downloads, Desktop, Music? SDL_GetUserFolder().
// - What is this thing at this location? SDL_GetPathInfo().
// - What items live in this folder? SDL_EnumerateDirectory().
// - What items live in this folder by wildcard? SDL_GlobDirectory().
// - What is my current working directory? SDL_GetCurrentDirectory().
//
// SDL also offers functions to manipulate the directory tree: renaming,
// removing, copying files.

// Flags for path matching.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: glob_directory (SDL_GlobDirectory)
// See also: glob_storage_directory (SDL_GlobStorageDirectory)
pub type GlobFlags = u32

// C.SDL_GetBasePath [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetBasePath)
fn C.SDL_GetBasePath() &char

// get_base_path gets the directory where the application was run from.
//
// SDL caches the result of this call internally, but the first call to this
// function is not necessarily fast, so plan accordingly.
//
// **macOS and iOS Specific Functionality**: If the application is in a ".app"
// bundle, this function returns the Resource directory (e.g.
// MyApp.app/Contents/Resources/). This behaviour can be overridden by adding
// a property to the Info.plist file. Adding a string key with the name
// SDL_FILESYSTEM_BASE_DIR_TYPE with a supported value will change the
// behaviour.
//
// Supported values for the SDL_FILESYSTEM_BASE_DIR_TYPE property (Given an
// application in /Applications/SDLApp/MyApp.app):
//
// - `resource`: bundle resource directory (the default). For example:
//   `/Applications/SDLApp/MyApp.app/Contents/Resources`
// - `bundle`: the Bundle directory. For example:
//   `/Applications/SDLApp/MyApp.app/`
// - `parent`: the containing directory of the bundle. For example:
//   `/Applications/SDLApp/`
//
// **Nintendo 3DS Specific Functionality**: This function returns "romfs"
// directory of the application as it is uncommon to store resources outside
// the executable. As such it is not a writable directory.
//
// The returned path is guaranteed to end with a path separator ('\\' on
// Windows, '/' on most other platforms).
//
// returns an absolute path in UTF-8 encoding to the application data
//          directory. NULL will be returned on error or when the platform
//          doesn't implement this functionality, call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_pref_path (SDL_GetPrefPath)
pub fn get_base_path() &char {
	return C.SDL_GetBasePath()
}

// C.SDL_GetPrefPath [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetPrefPath)
fn C.SDL_GetPrefPath(const_org &char, const_app &char) &char

// get_pref_path gets the user-and-app-specific path where files can be written.
//
// Get the "pref dir". This is meant to be where users can write personal
// files (preferences and save games, etc) that are specific to your
// application. This directory is unique per user, per application.
//
// This function will decide the appropriate location in the native
// filesystem, create the directory if necessary, and return a string of the
// absolute path to the directory in UTF-8 encoding.
//
// On Windows, the string might look like:
//
// `C:\\Users\\bob\\AppData\\Roaming\\My Company\\My Program Name\\`
//
// On Linux, the string might look like:
//
// `/home/bob/.local/share/My Program Name/`
//
// On macOS, the string might look like:
//
// `/Users/bob/Library/Application Support/My Program Name/`
//
// You should assume the path returned by this function is the only safe place
// to write files (and that SDL_GetBasePath(), while it might be writable, or
// even the parent of the returned path, isn't where you should be writing
// things).
//
// Both the org and app strings may become part of a directory name, so please
// follow these rules:
//
// - Try to use the same org string (_including case-sensitivity_) for all
//   your applications that use this function.
// - Always use a unique app string for each one, and make sure it never
//   changes for an app once you've decided on it.
// - Unicode characters are legal, as long as they are UTF-8 encoded, but...
// - ...only use letters, numbers, and spaces. Avoid punctuation like "Game
//   Name 2: Bad Guy's Revenge!" ... "Game Name 2" is sufficient.
//
// The returned path is guaranteed to end with a path separator ('\\' on
// Windows, '/' on most other platforms).
//
// `org` org the name of your organization.
// `app` app the name of your application.
// returns a UTF-8 string of the user directory in platform-dependent
//          notation. NULL if there's a problem (creating directory failed,
//          etc.). This should be freed with SDL_free() when it is no longer
//          needed.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_base_path (SDL_GetBasePath)
pub fn get_pref_path(const_org &char, const_app &char) &char {
	return C.SDL_GetPrefPath(const_org, const_app)
}

// Folder is C.SDL_Folder
pub enum Folder {
	home        = C.SDL_FOLDER_HOME        // `home` The folder which contains all of the current user's data, preferences, and documents. It usually contains most of the other folders. If a requested folder does not exist, the home folder can be considered a safe fallback to store a user's documents.
	desktop     = C.SDL_FOLDER_DESKTOP     // `desktop` The folder of files that are displayed on the desktop. Note that the existence of a desktop folder does not guarantee that the system does show icons on its desktop; certain GNU/Linux distros with a graphical environment may not have desktop icons.
	documents   = C.SDL_FOLDER_DOCUMENTS   // `documents` User document files, possibly application-specific. This is a good place to save a user's projects.
	downloads   = C.SDL_FOLDER_DOWNLOADS   // `downloads` Standard folder for user files downloaded from the internet.
	music       = C.SDL_FOLDER_MUSIC       // `music` Music files that can be played using a standard music player (mp3, ogg...).
	pictures    = C.SDL_FOLDER_PICTURES    // `pictures` Image files that can be displayed using a standard viewer (png, jpg...).
	publicshare = C.SDL_FOLDER_PUBLICSHARE // `publicshare` Files that are meant to be shared with other users on the same computer.
	savedgames  = C.SDL_FOLDER_SAVEDGAMES  // `savedgames` Save files for games.
	screenshots = C.SDL_FOLDER_SCREENSHOTS // `screenshots` Application screenshots.
	templates   = C.SDL_FOLDER_TEMPLATES   // `templates` Template files to be used when the user requests the desktop environment to create a new file in a certain folder, such as "New Text File.txt".Any file in the Templates folder can be used as a starting point for a new file.
	videos      = C.SDL_FOLDER_VIDEOS      // `videos` Video files that can be played using a standard video player (mp4, webm...).
	count       = C.SDL_FOLDER_COUNT       // `count` Total number of types in this enum, not a folder type by itself.
}

// C.SDL_GetUserFolder [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetUserFolder)
fn C.SDL_GetUserFolder(folder Folder) &char

// get_user_folder finds the most suitable user folder for a specific purpose.
//
// Many OSes provide certain standard folders for certain purposes, such as
// storing pictures, music or videos for a certain user. This function gives
// the path for many of those special locations.
//
// This function is specifically for _user_ folders, which are meant for the
// user to access and manage. For application-specific folders, meant to hold
// data for the application to manage, see SDL_GetBasePath() and
// SDL_GetPrefPath().
//
// The returned path is guaranteed to end with a path separator ('\\' on
// Windows, '/' on most other platforms).
//
// If NULL is returned, the error may be obtained with SDL_GetError().
//
// `folder` folder the type of folder to find.
// returns either a null-terminated C string containing the full path to the
//          folder, or NULL if an error happened.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_user_folder(folder Folder) &char {
	return C.SDL_GetUserFolder(folder)
}

// PathType is C.SDL_PathType
pub enum PathType {
	none      = C.SDL_PATHTYPE_NONE      // `none` path does not exist
	file      = C.SDL_PATHTYPE_FILE      // `file` a normal file
	directory = C.SDL_PATHTYPE_DIRECTORY // `directory` a directory
	other     = C.SDL_PATHTYPE_OTHER     // `other` something completely different like a device node (not a symlink, those are always followed)
}

@[typedef]
pub struct C.SDL_PathInfo {
pub mut:
	type        PathType // the path type
	size        u64      // the file size in bytes
	create_time Time     // the time when the path was created
	modify_time Time     // the last time the path was modified
	access_time Time     // the last time the path was read
}

pub type PathInfo = C.SDL_PathInfo

pub const glob_caseinsensitive = C.SDL_GLOB_CASEINSENSITIVE // (1u << 0)

// C.SDL_CreateDirectory [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateDirectory)
fn C.SDL_CreateDirectory(const_path &char) bool

// create_directory creates a directory, and any missing parent directories.
//
// This reports success if `path` already exists as a directory.
//
// If parent directories are missing, it will also create them. Note that if
// this fails, it will not remove any parent directories it already made.
//
// `path` path the path of the directory to create.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn create_directory(const_path &char) bool {
	return C.SDL_CreateDirectory(const_path)
}

// EnumerationResult is C.SDL_EnumerationResult
pub enum EnumerationResult {
	continue = C.SDL_ENUM_CONTINUE // `continue` Value that requests that enumeration continue.
	success  = C.SDL_ENUM_SUCCESS  // `success` Value that requests that enumeration stop, successfully.
	failure  = C.SDL_ENUM_FAILURE  // `failure` Value that requests that enumeration stop, as a failure.
}

// EnumerateDirectoryCallback callbacks for directory enumeration.
//
// Enumeration of directory entries will continue until either all entries
// have been provided to the callback, or the callback has requested a stop
// through its return value.
//
// Returning SDL_ENUM_CONTINUE will let enumeration proceed, calling the
// callback with further entries. SDL_ENUM_SUCCESS and SDL_ENUM_FAILURE will
// terminate the enumeration early, and dictate the return value of the
// enumeration function itself.
//
// `dirname` is guaranteed to end with a path separator ('\\' on Windows, '/'
// on most other platforms).
//
// `userdata` userdata an app-controlled pointer that is passed to the callback.
// `dirname` dirname the directory that is being enumerated.
// `fname` fname the next entry in the enumeration.
// returns how the enumeration should proceed.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: enumerate_directory (SDL_EnumerateDirectory)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_EnumerateDirectoryCallback)
pub type EnumerateDirectoryCallback = fn (userdata voidptr, const_dirname &char, const_fname &char) EnumerationResult

// C.SDL_EnumerateDirectory [official documentation](https://wiki.libsdl.org/SDL3/SDL_EnumerateDirectory)
fn C.SDL_EnumerateDirectory(const_path &char, callback EnumerateDirectoryCallback, userdata voidptr) bool

// enumerate_directory enumerates a directory through a callback function.
//
// This function provides every directory entry through an app-provided
// callback, called once for each directory entry, until all results have been
// provided or the callback returns either SDL_ENUM_SUCCESS or
// SDL_ENUM_FAILURE.
//
// This will return false if there was a system problem in general, or if a
// callback returns SDL_ENUM_FAILURE. A successful return means a callback
// returned SDL_ENUM_SUCCESS to halt enumeration, or all directory entries
// were enumerated.
//
// `path` path the path of the directory to enumerate.
// `callback` callback a function that is called for each entry in the directory.
// `userdata` userdata a pointer that is passed to `callback`.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn enumerate_directory(const_path &char, callback EnumerateDirectoryCallback, userdata voidptr) bool {
	return C.SDL_EnumerateDirectory(const_path, callback, userdata)
}

// C.SDL_RemovePath [official documentation](https://wiki.libsdl.org/SDL3/SDL_RemovePath)
fn C.SDL_RemovePath(const_path &char) bool

// remove_path removes a file or an empty directory.
//
// Directories that are not empty will fail; this function will not recursely
// delete directory trees.
//
// `path` path the path to remove from the filesystem.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn remove_path(const_path &char) bool {
	return C.SDL_RemovePath(const_path)
}

// C.SDL_RenamePath [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenamePath)
fn C.SDL_RenamePath(const_oldpath &char, const_newpath &char) bool

// rename_path renames a file or directory.
//
// If the file at `newpath` already exists, it will replaced.
//
// Note that this will not copy files across filesystems/drives/volumes, as
// that is a much more complicated (and possibly time-consuming) operation.
//
// Which is to say, if this function fails, SDL_CopyFile() to a temporary file
// in the same directory as `newpath`, then SDL_RenamePath() from the
// temporary file to `newpath` and SDL_RemovePath() on `oldpath` might work
// for files. Renaming a non-empty directory across filesystems is
// dramatically more complex, however.
//
// `oldpath` oldpath the old path.
// `newpath` newpath the new path.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn rename_path(const_oldpath &char, const_newpath &char) bool {
	return C.SDL_RenamePath(const_oldpath, const_newpath)
}

// C.SDL_CopyFile [official documentation](https://wiki.libsdl.org/SDL3/SDL_CopyFile)
fn C.SDL_CopyFile(const_oldpath &char, const_newpath &char) bool

// copy_file copys a file.
//
// If the file at `newpath` already exists, it will be overwritten with the
// contents of the file at `oldpath`.
//
// This function will block until the copy is complete, which might be a
// significant time for large files on slow disks. On some platforms, the copy
// can be handed off to the OS itself, but on others SDL might just open both
// paths, and read from one and write to the other.
//
// Note that this is not an atomic operation! If something tries to read from
// `newpath` while the copy is in progress, it will see an incomplete copy of
// the data, and if the calling thread terminates (or the power goes out)
// during the copy, `newpath`'s previous contents will be gone, replaced with
// an incomplete copy of the data. To avoid this risk, it is recommended that
// the app copy to a temporary file in the same directory as `newpath`, and if
// the copy is successful, use SDL_RenamePath() to replace `newpath` with the
// temporary file. This will ensure that reads of `newpath` will either see a
// complete copy of the data, or it will see the pre-copy state of `newpath`.
//
// This function attempts to synchronize the newly-copied data to disk before
// returning, if the platform allows it, so that the renaming trick will not
// have a problem in a system crash or power failure, where the file could be
// renamed but the contents never made it from the system file cache to the
// physical disk.
//
// If the copy fails for any reason, the state of `newpath` is undefined. It
// might be half a copy, it might be the untouched data of what was already
// there, or it might be a zero-byte file, etc.
//
// `oldpath` oldpath the old path.
// `newpath` newpath the new path.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn copy_file(const_oldpath &char, const_newpath &char) bool {
	return C.SDL_CopyFile(const_oldpath, const_newpath)
}

// C.SDL_GetPathInfo [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetPathInfo)
fn C.SDL_GetPathInfo(const_path &char, info &PathInfo) bool

// get_path_info gets information about a filesystem path.
//
// `path` path the path to query.
// `info` info a pointer filled in with information about the path, or NULL to
//             check for the existence of a file.
// returns true on success or false if the file doesn't exist, or another
//          failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_path_info(const_path &char, info &PathInfo) bool {
	return C.SDL_GetPathInfo(const_path, info)
}

// C.SDL_GlobDirectory [official documentation](https://wiki.libsdl.org/SDL3/SDL_GlobDirectory)
fn C.SDL_GlobDirectory(const_path &char, const_pattern &char, flags GlobFlags, count &int) &&char

// glob_directory enumerates a directory tree, filtered by pattern, and return a list.
//
// Files are filtered out if they don't match the string in `pattern`, which
// may contain wildcard characters '\*' (match everything) and '?' (match one
// character). If pattern is NULL, no filtering is done and all results are
// returned. Subdirectories are permitted, and are specified with a path
// separator of '/'. Wildcard characters '\*' and '?' never match a path
// separator.
//
// `flags` may be set to SDL_GLOB_CASEINSENSITIVE to make the pattern matching
// case-insensitive.
//
// The returned array is always NULL-terminated, for your iterating
// convenience, but if `count` is non-NULL, on return it will contain the
// number of items in the array, not counting the NULL terminator.
//
// `path` path the path of the directory to enumerate.
// `pattern` pattern the pattern that files in the directory must match. Can be
//                NULL.
// `flags` flags `SDL_GLOB_*` bitflags that affect this search.
// `count` count on return, will be set to the number of items in the returned
//              array. Can be NULL.
// returns an array of strings on success or NULL on failure; call
//          SDL_GetError() for more information. This is a single allocation
//          that should be freed with SDL_free() when it is no longer needed.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn glob_directory(const_path &char, const_pattern &char, flags GlobFlags, count &int) &&char {
	return C.SDL_GlobDirectory(const_path, const_pattern, flags, count)
}

// C.SDL_GetCurrentDirectory [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCurrentDirectory)
fn C.SDL_GetCurrentDirectory() &char

// get_current_directory gets what the system believes is the "current working directory."
//
// For systems without a concept of a current working directory, this will
// still attempt to provide something reasonable.
//
// SDL does not provide a means to _change_ the current working directory; for
// platforms without this concept, this would cause surprises with file access
// outside of SDL.
//
// The returned path is guaranteed to end with a path separator ('\\' on
// Windows, '/' on most other platforms).
//
// returns a UTF-8 string of the current working directory in
//          platform-dependent notation. NULL if there's a problem. This
//          should be freed with SDL_free() when it is no longer needed.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_current_directory() &char {
	return C.SDL_GetCurrentDirectory()
}

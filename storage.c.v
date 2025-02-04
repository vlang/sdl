// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_storage.h
//

// The storage API is a high-level API designed to abstract away the
// portability issues that come up when using something lower-level (in SDL's
// case, this sits on top of the [Filesystem](CategoryFilesystem) and
// [IOStream](CategoryIOStream) subsystems). It is significantly more
// restrictive than a typical filesystem API, for a number of reasons:
//
// 1. **What to Access:** A common pitfall with existing filesystem APIs is
// the assumption that all storage is monolithic. However, many other
// platforms (game consoles in particular) are more strict about what _type_
// of filesystem is being accessed; for example, game content and user data
// are usually two separate storage devices with entirely different
// characteristics (and possibly different low-level APIs altogether!).
//
// 2. **How to Access:** Another common mistake is applications assuming that
// all storage is universally writeable - again, many platforms treat game
// content and user data as two separate storage devices, and only user data
// is writeable while game content is read-only.
//
// 3. **When to Access:** The most common portability issue with filesystem
// access is _timing_ - you cannot always assume that the storage device is
// always accessible all of the time, nor can you assume that there are no
// limits to how long you have access to a particular device.
//
// Consider the following example:
//
// ```c
// void ReadGameData(void)
// {
//     extern char** fileNames;
//     extern size_t numFiles;
//     for (size_t i = 0; i < numFiles; i += 1) {
//         FILE *data = fopen(fileNames[i], "rwb");
//         if (data == NULL) {
//             // Something bad happened!
//         } else {
//             // A bunch of stuff happens here
//             fclose(data);
//         }
//     }
// }
//
// void ReadSave(void)
// {
//     FILE *save = fopen("saves/save0.sav", "rb");
//     if (save == NULL) {
//         // Something bad happened!
//     } else {
//         // A bunch of stuff happens here
//         fclose(save);
//     }
// }
//
// void WriteSave(void)
// {
//     FILE *save = fopen("saves/save0.sav", "wb");
//     if (save == NULL) {
//         // Something bad happened!
//     } else {
//         // A bunch of stuff happens here
//         fclose(save);
//     }
// }
// ```
//
// Going over the bullet points again:
//
// 1. **What to Access:** This code accesses a global filesystem; game data
// and saves are all presumed to be in the current working directory (which
// may or may not be the game's installation folder!).
//
// 2. **How to Access:** This code assumes that content paths are writeable,
// and that save data is also writeable despite being in the same location as
// the game data.
//
// 3. **When to Access:** This code assumes that they can be called at any
// time, since the filesystem is always accessible and has no limits on how
// long the filesystem is being accessed.
//
// Due to these assumptions, the filesystem code is not portable and will fail
// under these common scenarios:
//
// - The game is installed on a device that is read-only, both content loading
//   and game saves will fail or crash outright
// - Game/User storage is not implicitly mounted, so no files will be found
//   for either scenario when a platform requires explicitly mounting
//   filesystems
// - Save data may not be safe since the I/O is not being flushed or
//   validated, so an error occurring elsewhere in the program may result in
//   missing/corrupted save data
//
// When using SDL_Storage, these types of problems are virtually impossible to
// trip over:
//
// ```c
// void ReadGameData(void)
// {
//     extern char** fileNames;
//     extern size_t numFiles;
//
//     SDL_Storage *title = SDL_OpenTitleStorage(NULL, 0);
//     if (title == NULL) {
//         // Something bad happened!
//     }
//     while (!SDL_StorageReady(title)) {
//         SDL_Delay(1);
//     }
//
//     for (size_t i = 0; i < numFiles; i += 1) {
//         void* dst;
//         Uint64 dstLen = 0;
//
//         if (SDL_GetStorageFileSize(title, fileNames[i], &dstLen) && dstLen > 0) {
//             dst = SDL_malloc(dstLen);
//             if (SDL_ReadStorageFile(title, fileNames[i], dst, dstLen)) {
//                 // A bunch of stuff happens here
//             } else {
//                 // Something bad happened!
//             }
//             SDL_free(dst);
//         } else {
//             // Something bad happened!
//         }
//     }
//
//     SDL_CloseStorage(title);
// }
//
// void ReadSave(void)
// {
//     SDL_Storage *user = SDL_OpenUserStorage("libsdl", "Storage Example", 0);
//     if (user == NULL) {
//         // Something bad happened!
//     }
//     while (!SDL_StorageReady(user)) {
//         SDL_Delay(1);
//     }
//
//     Uint64 saveLen = 0;
//     if (SDL_GetStorageFileSize(user, "save0.sav", &saveLen) && saveLen > 0) {
//         void* dst = SDL_malloc(saveLen);
//         if (SDL_ReadStorageFile(user, "save0.sav", dst, saveLen)) {
//             // A bunch of stuff happens here
//         } else {
//             // Something bad happened!
//         }
//         SDL_free(dst);
//     } else {
//         // Something bad happened!
//     }
//
//     SDL_CloseStorage(user);
// }
//
// void WriteSave(void)
// {
//     SDL_Storage *user = SDL_OpenUserStorage("libsdl", "Storage Example", 0);
//     if (user == NULL) {
//         // Something bad happened!
//     }
//     while (!SDL_StorageReady(user)) {
//         SDL_Delay(1);
//     }
//
//     extern void *saveData; // A bunch of stuff happened here...
//     extern Uint64 saveLen;
//     if (!SDL_WriteStorageFile(user, "save0.sav", saveData, saveLen)) {
//         // Something bad happened!
//     }
//
//     SDL_CloseStorage(user);
// }
// ```
//
// Note the improvements that SDL_Storage makes:
//
// 1. **What to Access:** This code explicitly reads from a title or user
// storage device based on the context of the function.
//
// 2. **How to Access:** This code explicitly uses either a read or write
// function based on the context of the function.
//
// 3. **When to Access:** This code explicitly opens the device when it needs
// to, and closes it when it is finished working with the filesystem.
//
// The result is an application that is significantly more robust against the
// increasing demands of platforms and their filesystems!
//
// A publicly available example of an SDL_Storage backend is the
// [Steam Cloud](https://partner.steamgames.com/doc/features/cloud)
// backend - you can initialize Steamworks when starting the program, and then
// SDL will recognize that Steamworks is initialized and automatically use
// ISteamRemoteStorage when the application opens user storage. More
// importantly, when you _open_ storage it knows to begin a "batch" of
// filesystem operations, and when you _close_ storage it knows to end and
// flush the batch. This is used by Steam to support
// [Dynamic Cloud Sync](https://steamcommunity.com/groups/steamworks/announcements/detail/3142949576401813670)
// ; users can save data on one PC, put the device to sleep, and then continue
// playing on another PC (and vice versa) with the save data fully
// synchronized across all devices, allowing for a seamless experience without
// having to do full restarts of the program.
//
// ## Notes on valid paths
//
// All paths in the Storage API use Unix-style path separators ('/'). Using a
// different path separator will not work, even if the underlying platform
// would otherwise accept it. This is to keep code using the Storage API
// portable between platforms and Storage implementations and simplify app
// code.
//
// Paths with relative directories ("." and "..") are forbidden by the Storage
// API.
//
// All valid UTF-8 strings (discounting the NULL terminator character and the
// '/' path separator) are usable for filenames, however, an underlying
// Storage implementation may not support particularly strange sequences and
// refuse to create files with those names, etc.

@[typedef]
pub struct C.SDL_StorageInterface {
pub mut:
	// The version of this interface
	version         u32                        // Called when the storage is closed
	close           fn (userdata voidptr) bool // close)(void* Optional, returns whether the storage is currently ready for access
	ready           fn (userdata voidptr) bool // ready)(void* Enumerate a directory, optional for write-only storage
	enumerate       fn (userdata voidptr, const_path &char, callback EnumerateDirectoryCallback, callback_userdata voidptr) bool // enumerate)(void* Get path information, optional for write-only storage
	info            fn (userdata voidptr, const_path &char, info &PathInfo) bool                   // info)(void* Read a file from storage, optional for write-only storage
	read_file       fn (userdata voidptr, const_path &char, destination voidptr, length u64) bool  // read_file)(void* Write a file to storage, optional for read-only storage
	write_file      fn (userdata voidptr, const_path &char, const_source voidptr, length u64) bool // write_file)(void* Create a directory, optional for read-only storage
	mkdir           fn (userdata voidptr, const_path &char) bool                         // mkdir)(void* Remove a file or empty directory, optional for read-only storage
	remove          fn (userdata voidptr, const_path &char) bool                         // remove)(void* Rename a path, optional for read-only storage
	rename          fn (userdata voidptr, const_oldpath &char, const_newpath &char) bool // rename)(void* Copy a file, optional for read-only storage
	copy            fn (userdata voidptr, const_oldpath &char, const_newpath &char) bool // copy)(void* Get the space remaining, optional for read-only storage
	space_remaining fn (userdata voidptr) u64 // space_remaining)(void*
}

pub type StorageInterface = C.SDL_StorageInterface

@[noinit; typedef]
pub struct C.SDL_Storage {
	// NOTE: Opaque type
}

pub type Storage = C.SDL_Storage

// C.SDL_OpenTitleStorage [official documentation](https://wiki.libsdl.org/SDL3/SDL_OpenTitleStorage)
fn C.SDL_OpenTitleStorage(const_override &char, props PropertiesID) &Storage

// open_title_storage opens up a read-only container for the application's filesystem.
//
// `override` override a path to override the backend's default title root.
// `props` props a property list that may contain backend-specific information.
// returns a title storage container on success or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: close_storage (SDL_CloseStorage)
// See also: get_storage_file_size (SDL_GetStorageFileSize)
// See also: open_user_storage (SDL_OpenUserStorage)
// See also: read_storage_file (SDL_ReadStorageFile)
pub fn open_title_storage(const_override &char, props PropertiesID) &Storage {
	return C.SDL_OpenTitleStorage(const_override, props)
}

// C.SDL_OpenUserStorage [official documentation](https://wiki.libsdl.org/SDL3/SDL_OpenUserStorage)
fn C.SDL_OpenUserStorage(const_org &char, const_app &char, props PropertiesID) &Storage

// open_user_storage opens up a container for a user's unique read/write filesystem.
//
// While title storage can generally be kept open throughout runtime, user
// storage should only be opened when the client is ready to read/write files.
// This allows the backend to properly batch file operations and flush them
// when the container has been closed; ensuring safe and optimal save I/O.
//
// `org` org the name of your organization.
// `app` app the name of your application.
// `props` props a property list that may contain backend-specific information.
// returns a user storage container on success or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: close_storage (SDL_CloseStorage)
// See also: get_storage_file_size (SDL_GetStorageFileSize)
// See also: get_storage_space_remaining (SDL_GetStorageSpaceRemaining)
// See also: open_title_storage (SDL_OpenTitleStorage)
// See also: read_storage_file (SDL_ReadStorageFile)
// See also: storage_ready (SDL_StorageReady)
// See also: write_storage_file (SDL_WriteStorageFile)
pub fn open_user_storage(const_org &char, const_app &char, props PropertiesID) &Storage {
	return C.SDL_OpenUserStorage(const_org, const_app, props)
}

// C.SDL_OpenFileStorage [official documentation](https://wiki.libsdl.org/SDL3/SDL_OpenFileStorage)
fn C.SDL_OpenFileStorage(const_path &char) &Storage

// open_file_storage opens up a container for local filesystem storage.
//
// This is provided for development and tools. Portable applications should
// use SDL_OpenTitleStorage() for access to game data and
// SDL_OpenUserStorage() for access to user data.
//
// `path` path the base path prepended to all storage paths, or NULL for no
//             base path.
// returns a filesystem storage container on success or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: close_storage (SDL_CloseStorage)
// See also: get_storage_file_size (SDL_GetStorageFileSize)
// See also: get_storage_space_remaining (SDL_GetStorageSpaceRemaining)
// See also: open_title_storage (SDL_OpenTitleStorage)
// See also: open_user_storage (SDL_OpenUserStorage)
// See also: read_storage_file (SDL_ReadStorageFile)
// See also: write_storage_file (SDL_WriteStorageFile)
pub fn open_file_storage(const_path &char) &Storage {
	return C.SDL_OpenFileStorage(const_path)
}

// C.SDL_OpenStorage [official documentation](https://wiki.libsdl.org/SDL3/SDL_OpenStorage)
fn C.SDL_OpenStorage(const_iface &StorageInterface, userdata voidptr) &Storage

// open_storage opens up a container using a client-provided storage interface.
//
// Applications do not need to use this function unless they are providing
// their own SDL_Storage implementation. If you just need an SDL_Storage, you
// should use the built-in implementations in SDL, like SDL_OpenTitleStorage()
// or SDL_OpenUserStorage().
//
// This function makes a copy of `iface` and the caller does not need to keep
// it around after this call.
//
// `iface` iface the interface that implements this storage, initialized using
//              SDL_INIT_INTERFACE().
// `userdata` userdata the pointer that will be passed to the interface functions.
// returns a storage container on success or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: close_storage (SDL_CloseStorage)
// See also: get_storage_file_size (SDL_GetStorageFileSize)
// See also: get_storage_space_remaining (SDL_GetStorageSpaceRemaining)
// See also: initinterface (SDL_INIT_INTERFACE)
// See also: read_storage_file (SDL_ReadStorageFile)
// See also: storage_ready (SDL_StorageReady)
// See also: write_storage_file (SDL_WriteStorageFile)
pub fn open_storage(const_iface &StorageInterface, userdata voidptr) &Storage {
	return C.SDL_OpenStorage(const_iface, userdata)
}

// C.SDL_CloseStorage [official documentation](https://wiki.libsdl.org/SDL3/SDL_CloseStorage)
fn C.SDL_CloseStorage(storage &Storage) bool

// close_storage closes and frees a storage container.
//
// `storage` storage a storage container to close.
// returns true if the container was freed with no errors, false otherwise;
//          call SDL_GetError() for more information. Even if the function
//          returns an error, the container data will be freed; the error is
//          only for informational purposes.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: open_file_storage (SDL_OpenFileStorage)
// See also: open_storage (SDL_OpenStorage)
// See also: open_title_storage (SDL_OpenTitleStorage)
// See also: open_user_storage (SDL_OpenUserStorage)
pub fn close_storage(storage &Storage) bool {
	return C.SDL_CloseStorage(storage)
}

// C.SDL_StorageReady [official documentation](https://wiki.libsdl.org/SDL3/SDL_StorageReady)
fn C.SDL_StorageReady(storage &Storage) bool

// storage_ready checks if the storage container is ready to use.
//
// This function should be called in regular intervals until it returns true -
// however, it is not recommended to spinwait on this call, as the backend may
// depend on a synchronous message loop.
//
// `storage` storage a storage container to query.
// returns true if the container is ready, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn storage_ready(storage &Storage) bool {
	return C.SDL_StorageReady(storage)
}

// C.SDL_GetStorageFileSize [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetStorageFileSize)
fn C.SDL_GetStorageFileSize(storage &Storage, const_path &char, length &u64) bool

// get_storage_file_size querys the size of a file within a storage container.
//
// `storage` storage a storage container to query.
// `path` path the relative path of the file to query.
// `length` length a pointer to be filled with the file's length.
// returns true if the file could be queried or false on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: read_storage_file (SDL_ReadStorageFile)
// See also: storage_ready (SDL_StorageReady)
pub fn get_storage_file_size(storage &Storage, const_path &char, length &u64) bool {
	return C.SDL_GetStorageFileSize(storage, const_path, length)
}

// C.SDL_ReadStorageFile [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadStorageFile)
fn C.SDL_ReadStorageFile(storage &Storage, const_path &char, destination voidptr, length u64) bool

// read_storage_file synchronouslys read a file from a storage container into a client-provided
// buffer.
//
// The value of `length` must match the length of the file exactly; call
// SDL_GetStorageFileSize() to get this value. This behavior may be relaxed in
// a future release.
//
// `storage` storage a storage container to read from.
// `path` path the relative path of the file to read.
// `destination` destination a client-provided buffer to read the file into.
// `length` length the length of the destination buffer.
// returns true if the file was read or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_storage_file_size (SDL_GetStorageFileSize)
// See also: storage_ready (SDL_StorageReady)
// See also: write_storage_file (SDL_WriteStorageFile)
pub fn read_storage_file(storage &Storage, const_path &char, destination voidptr, length u64) bool {
	return C.SDL_ReadStorageFile(storage, const_path, destination, length)
}

// C.SDL_WriteStorageFile [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteStorageFile)
fn C.SDL_WriteStorageFile(storage &Storage, const_path &char, const_source voidptr, length u64) bool

// write_storage_file synchronouslys write a file from client memory into a storage container.
//
// `storage` storage a storage container to write to.
// `path` path the relative path of the file to write.
// `source` source a client-provided buffer to write from.
// `length` length the length of the source buffer.
// returns true if the file was written or false on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_storage_space_remaining (SDL_GetStorageSpaceRemaining)
// See also: read_storage_file (SDL_ReadStorageFile)
// See also: storage_ready (SDL_StorageReady)
pub fn write_storage_file(storage &Storage, const_path &char, const_source voidptr, length u64) bool {
	return C.SDL_WriteStorageFile(storage, const_path, const_source, length)
}

// C.SDL_CreateStorageDirectory [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateStorageDirectory)
fn C.SDL_CreateStorageDirectory(storage &Storage, const_path &char) bool

// create_storage_directory creates a directory in a writable storage container.
//
// `storage` storage a storage container.
// `path` path the path of the directory to create.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: storage_ready (SDL_StorageReady)
pub fn create_storage_directory(storage &Storage, const_path &char) bool {
	return C.SDL_CreateStorageDirectory(storage, const_path)
}

// C.SDL_EnumerateStorageDirectory [official documentation](https://wiki.libsdl.org/SDL3/SDL_EnumerateStorageDirectory)
fn C.SDL_EnumerateStorageDirectory(storage &Storage, const_path &char, callback EnumerateDirectoryCallback, userdata voidptr) bool

// enumerate_storage_directory enumerates a directory in a storage container through a callback function.
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
// If `path` is NULL, this is treated as a request to enumerate the root of
// the storage container's tree. An empty string also works for this.
//
// `storage` storage a storage container.
// `path` path the path of the directory to enumerate, or NULL for the root.
// `callback` callback a function that is called for each entry in the directory.
// `userdata` userdata a pointer that is passed to `callback`.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: storage_ready (SDL_StorageReady)
pub fn enumerate_storage_directory(storage &Storage, const_path &char, callback EnumerateDirectoryCallback, userdata voidptr) bool {
	return C.SDL_EnumerateStorageDirectory(storage, const_path, callback, userdata)
}

// C.SDL_RemoveStoragePath [official documentation](https://wiki.libsdl.org/SDL3/SDL_RemoveStoragePath)
fn C.SDL_RemoveStoragePath(storage &Storage, const_path &char) bool

// remove_storage_path removes a file or an empty directory in a writable storage container.
//
// `storage` storage a storage container.
// `path` path the path of the directory to enumerate.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: storage_ready (SDL_StorageReady)
pub fn remove_storage_path(storage &Storage, const_path &char) bool {
	return C.SDL_RemoveStoragePath(storage, const_path)
}

// C.SDL_RenameStoragePath [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenameStoragePath)
fn C.SDL_RenameStoragePath(storage &Storage, const_oldpath &char, const_newpath &char) bool

// rename_storage_path renames a file or directory in a writable storage container.
//
// `storage` storage a storage container.
// `oldpath` oldpath the old path.
// `newpath` newpath the new path.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: storage_ready (SDL_StorageReady)
pub fn rename_storage_path(storage &Storage, const_oldpath &char, const_newpath &char) bool {
	return C.SDL_RenameStoragePath(storage, const_oldpath, const_newpath)
}

// C.SDL_CopyStorageFile [official documentation](https://wiki.libsdl.org/SDL3/SDL_CopyStorageFile)
fn C.SDL_CopyStorageFile(storage &Storage, const_oldpath &char, const_newpath &char) bool

// copy_storage_file copys a file in a writable storage container.
//
// `storage` storage a storage container.
// `oldpath` oldpath the old path.
// `newpath` newpath the new path.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: storage_ready (SDL_StorageReady)
pub fn copy_storage_file(storage &Storage, const_oldpath &char, const_newpath &char) bool {
	return C.SDL_CopyStorageFile(storage, const_oldpath, const_newpath)
}

// C.SDL_GetStoragePathInfo [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetStoragePathInfo)
fn C.SDL_GetStoragePathInfo(storage &Storage, const_path &char, info &PathInfo) bool

// get_storage_path_info gets information about a filesystem path in a storage container.
//
// `storage` storage a storage container.
// `path` path the path to query.
// `info` info a pointer filled in with information about the path, or NULL to
//             check for the existence of a file.
// returns true on success or false if the file doesn't exist, or another
//          failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: storage_ready (SDL_StorageReady)
pub fn get_storage_path_info(storage &Storage, const_path &char, info &PathInfo) bool {
	return C.SDL_GetStoragePathInfo(storage, const_path, info)
}

// C.SDL_GetStorageSpaceRemaining [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetStorageSpaceRemaining)
fn C.SDL_GetStorageSpaceRemaining(storage &Storage) u64

// get_storage_space_remaining queries the remaining space in a storage container.
//
// `storage` storage a storage container to query.
// returns the amount of remaining space, in bytes.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: storage_ready (SDL_StorageReady)
// See also: write_storage_file (SDL_WriteStorageFile)
pub fn get_storage_space_remaining(storage &Storage) u64 {
	return C.SDL_GetStorageSpaceRemaining(storage)
}

// C.SDL_GlobStorageDirectory [official documentation](https://wiki.libsdl.org/SDL3/SDL_GlobStorageDirectory)
fn C.SDL_GlobStorageDirectory(storage &Storage, const_path &char, const_pattern &char, flags GlobFlags, count &int) &&char

// glob_storage_directory enumerates a directory tree, filtered by pattern, and return a list.
//
// Files are filtered out if they don't match the string in `pattern`, which
// may contain wildcard characters '*' (match everything) and '?' (match one
// character). If pattern is NULL, no filtering is done and all results are
// returned. Subdirectories are permitted, and are specified with a path
// separator of '/'. Wildcard characters '*' and '?' never match a path
// separator.
//
// `flags` may be set to SDL_GLOB_CASEINSENSITIVE to make the pattern matching
// case-insensitive.
//
// The returned array is always NULL-terminated, for your iterating
// convenience, but if `count` is non-NULL, on return it will contain the
// number of items in the array, not counting the NULL terminator.
//
// If `path` is NULL, this is treated as a request to enumerate the root of
// the storage container's tree. An empty string also works for this.
//
// `storage` storage a storage container.
// `path` path the path of the directory to enumerate, or NULL for the root.
// `pattern` pattern the pattern that files in the directory must match. Can be
//                NULL.
// `flags` flags `SDL_GLOB_*` bitflags that affect this search.
// `count` count on return, will be set to the number of items in the returned
//              array. Can be NULL.
// returns an array of strings on success or NULL on failure; call
//          SDL_GetError() for more information. The caller should pass the
//          returned pointer to SDL_free when done with it. This is a single
//          allocation that should be freed with SDL_free() when it is no
//          longer needed.
//
// NOTE: (thread safety) It is safe to call this function from any thread, assuming
//               the `storage` object is thread-safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn glob_storage_directory(storage &Storage, const_path &char, const_pattern &char, flags GlobFlags, count &int) &&char {
	return C.SDL_GlobStorageDirectory(storage, const_path, const_pattern, flags, count)
}

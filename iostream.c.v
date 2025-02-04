// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_iostream.h
//

// SDL provides an abstract interface for reading and writing data streams. It
// offers implementations for files, memory, etc, and the app can provide
// their own implementations, too.
//
// SDL_IOStream is not related to the standard C++ iostream class, other than
// both are abstract interfaces to read/write data.

// IOStatus is C.SDL_IOStatus
pub enum IOStatus {
	ready     = C.SDL_IO_STATUS_READY     // `ready` Everything is ready (no errors and not EOF).
	error     = C.SDL_IO_STATUS_ERROR     // `error` Read or write I/O error
	eof       = C.SDL_IO_STATUS_EOF       // `eof` End of file
	not_ready = C.SDL_IO_STATUS_NOT_READY // `not_ready` Non blocking I/O, not ready
	readonly  = C.SDL_IO_STATUS_READONLY  // `readonly` Tried to write a read-only buffer
	writeonly = C.SDL_IO_STATUS_WRITEONLY // `writeonly` Tried to read a write-only buffer
}

// IOWhence is C.SDL_IOWhence
pub enum IOWhence {
	set = C.SDL_IO_SEEK_SET // `set` Seek from the beginning of data
	cur = C.SDL_IO_SEEK_CUR // `cur` Seek relative to current read point
	end = C.SDL_IO_SEEK_END // `end` Seek relative to the end of data
}

@[typedef]
pub struct C.SDL_IOStreamInterface {
pub mut:
	version u32 // The version of this interface
	// size returns the number of bytes in this SDL_IOStream
	// return the total size of the data stream, or -1 on error.
	size fn (userdata voidptr) i64
	// seek seeks to `offset` relative to `whence`, one of stdio's whence values:
	// SDL_IO_SEEK_SET, SDL_IO_SEEK_CUR, SDL_IO_SEEK_END
	// returns the final offset in the data stream, or -1 on error.
	seek fn (userdata voidptr, offset i64, whence IOWhence) i64
	// read reads up to `size` bytes from the data stream to the area pointed at by `ptr`.
	// On an incomplete read, you should set `*status` to a value from the
	// SDL_IOStatus enum. You do not have to explicitly set this on
	// a complete, successful read.
	// returns the number of bytes read.
	read fn (userdata voidptr, ptr voidptr, size usize, status &IOStatus) usize
	// write writes exactly `size` bytes from the area pointed at by `ptr` to data stream.
	// On an incomplete write, you should set `*status` to a value from the SDL_IOStatus enum.
	// You do not have to explicitly set SDL_PROP_IOSTREAM_WINDOWS_HANDLE_POINTERis on a complete, successful write.
	// returns the number of bytes written.
	write fn (userdata voidptr, const_ptr voidptr, size usize, status &IOStatus) usize
	// flush if the stream is buffering, make sure the data is written out.
	// On failure, you should set `*status` to a value from the * SDL_IOStatus enum.
	// You do not have to explicitly set this on a successful flush.
	// returns true if successful or false on write error when flushing data.
	flush fn (userdata voidptr, status &IOStatus) bool
	// close closes and free any allocated resources.
	// This does not guarantee file writes will sync to physical media.
	close fn (userdata voidptr) bool
}

pub type IOStreamInterface = C.SDL_IOStreamInterface

@[noinit; typedef]
pub struct C.SDL_IOStream {
	// NOTE: Opaque type
}

pub type IOStream = C.SDL_IOStream

// C.SDL_IOFromFile [official documentation](https://wiki.libsdl.org/SDL3/SDL_IOFromFile)
fn C.SDL_IOFromFile(const_file &char, const_mode &char) &IOStream

// io_from_file uses this function to create a new SDL_IOStream structure for reading from
// and/or writing to a named file.
//
// The `mode` string is treated roughly the same as in a call to the C
// library's fopen(), even if SDL doesn't happen to use fopen() behind the
// scenes.
//
// Available `mode` strings:
//
// - "r": Open a file for reading. The file must exist.
// - "w": Create an empty file for writing. If a file with the same name
//   already exists its content is erased and the file is treated as a new
//   empty file.
// - "a": Append to a file. Writing operations append data at the end of the
//   file. The file is created if it does not exist.
// - "r+": Open a file for update both reading and writing. The file must
//   exist.
// - "w+": Create an empty file for both reading and writing. If a file with
//   the same name already exists its content is erased and the file is
//   treated as a new empty file.
// - "a+": Open a file for reading and appending. All writing operations are
//   performed at the end of the file, protecting the previous content to be
//   overwritten. You can reposition (fseek, rewind) the internal pointer to
//   anywhere in the file for reading, but writing operations will move it
//   back to the end of file. The file is created if it does not exist.
//
// **NOTE**: In order to open a file as a binary file, a "b" character has to
// be included in the `mode` string. This additional "b" character can either
// be appended at the end of the string (thus making the following compound
// modes: "rb", "wb", "ab", "r+b", "w+b", "a+b") or be inserted between the
// letter and the "+" sign for the mixed modes ("rb+", "wb+", "ab+").
// Additional characters may follow the sequence, although they should have no
// effect. For example, "t" is sometimes appended to make explicit the file is
// a text file.
//
// This function supports Unicode filenames, but they must be encoded in UTF-8
// format, regardless of the underlying operating system.
//
// In Android, SDL_IOFromFile() can be used to open content:// URIs. As a
// fallback, SDL_IOFromFile() will transparently open a matching filename in
// the app's `assets`.
//
// Closing the SDL_IOStream will close SDL's internal file handle.
//
// The following properties may be set at creation time by SDL:
//
// - `SDL_PROP_IOSTREAM_WINDOWS_HANDLE_POINTER`: a pointer, that can be cast
//   to a win32 `HANDLE`, that this SDL_IOStream is using to access the
//   filesystem. If the program isn't running on Windows, or SDL used some
//   other method to access the filesystem, this property will not be set.
// - `SDL_PROP_IOSTREAM_STDIO_FILE_POINTER`: a pointer, that can be cast to a
//   stdio `FILE *`, that this SDL_IOStream is using to access the filesystem.
//   If SDL used some other method to access the filesystem, this property
//   will not be set. PLEASE NOTE that if SDL is using a different C runtime
//   than your app, trying to use this pointer will almost certainly result in
//   a crash! This is mostly a problem on Windows; make sure you build SDL and
//   your app with the same compiler and settings to avoid it.
// - `SDL_PROP_IOSTREAM_FILE_DESCRIPTOR_NUMBER`: a file descriptor that this
//   SDL_IOStream is using to access the filesystem.
// - `SDL_PROP_IOSTREAM_ANDROID_AASSET_POINTER`: a pointer, that can be cast
//   to an Android NDK `AAsset *`, that this SDL_IOStream is using to access
//   the filesystem. If SDL used some other method to access the filesystem,
//   this property will not be set.
//
// `file` file a UTF-8 string representing the filename to open.
// `mode` mode an ASCII string representing the mode to be used for opening
//             the file.
// returns a pointer to the SDL_IOStream structure that is created or NULL on
//          failure; call SDL_GetError() for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: close_io (SDL_CloseIO)
// See also: flush_io (SDL_FlushIO)
// See also: read_io (SDL_ReadIO)
// See also: seek_io (SDL_SeekIO)
// See also: tell_io (SDL_TellIO)
// See also: write_io (SDL_WriteIO)
pub fn io_from_file(const_file &char, const_mode &char) &IOStream {
	return C.SDL_IOFromFile(const_file, const_mode)
}

pub const prop_iostream_windows_handle_pointer = C.SDL_PROP_IOSTREAM_WINDOWS_HANDLE_POINTER // 'SDL.iostream.windows.handle'

pub const prop_iostream_stdio_file_pointer = C.SDL_PROP_IOSTREAM_STDIO_FILE_POINTER // 'SDL.iostream.stdio.file'

pub const prop_iostream_file_descriptor_number = C.SDL_PROP_IOSTREAM_FILE_DESCRIPTOR_NUMBER // 'SDL.iostream.file_descriptor'

pub const prop_iostream_android_aasset_pointer = C.SDL_PROP_IOSTREAM_ANDROID_AASSET_POINTER // 'SDL.iostream.android.aasset'

// C.SDL_IOFromMem [official documentation](https://wiki.libsdl.org/SDL3/SDL_IOFromMem)
fn C.SDL_IOFromMem(mem voidptr, size usize) &IOStream

// io_from_mem uses this function to prepare a read-write memory buffer for use with
// SDL_IOStream.
//
// This function sets up an SDL_IOStream struct based on a memory area of a
// certain size, for both read and write access.
//
// This memory buffer is not copied by the SDL_IOStream; the pointer you
// provide must remain valid until you close the stream. Closing the stream
// will not free the original buffer.
//
// If you need to make sure the SDL_IOStream never writes to the memory
// buffer, you should use SDL_IOFromConstMem() with a read-only buffer of
// memory instead.
//
// The following properties will be set at creation time by SDL:
//
// - `SDL_PROP_IOSTREAM_MEMORY_POINTER`: this will be the `mem` parameter that
//   was passed to this function.
// - `SDL_PROP_IOSTREAM_MEMORY_SIZE_NUMBER`: this will be the `size` parameter
//   that was passed to this function.
//
// `mem` mem a pointer to a buffer to feed an SDL_IOStream stream.
// `size` size the buffer size, in bytes.
// returns a pointer to a new SDL_IOStream structure or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: io_from_const_mem (SDL_IOFromConstMem)
// See also: close_io (SDL_CloseIO)
// See also: flush_io (SDL_FlushIO)
// See also: read_io (SDL_ReadIO)
// See also: seek_io (SDL_SeekIO)
// See also: tell_io (SDL_TellIO)
// See also: write_io (SDL_WriteIO)
pub fn io_from_mem(mem voidptr, size usize) &IOStream {
	return C.SDL_IOFromMem(mem, size)
}

pub const prop_iostream_memory_pointer = C.SDL_PROP_IOSTREAM_MEMORY_POINTER // 'SDL.iostream.memory.base'

pub const prop_iostream_memory_size_number = C.SDL_PROP_IOSTREAM_MEMORY_SIZE_NUMBER // 'SDL.iostream.memory.size'

// C.SDL_IOFromConstMem [official documentation](https://wiki.libsdl.org/SDL3/SDL_IOFromConstMem)
fn C.SDL_IOFromConstMem(const_mem voidptr, size usize) &IOStream

// io_from_const_mem uses this function to prepare a read-only memory buffer for use with
// SDL_IOStream.
//
// This function sets up an SDL_IOStream struct based on a memory area of a
// certain size. It assumes the memory area is not writable.
//
// Attempting to write to this SDL_IOStream stream will report an error
// without writing to the memory buffer.
//
// This memory buffer is not copied by the SDL_IOStream; the pointer you
// provide must remain valid until you close the stream. Closing the stream
// will not free the original buffer.
//
// If you need to write to a memory buffer, you should use SDL_IOFromMem()
// with a writable buffer of memory instead.
//
// The following properties will be set at creation time by SDL:
//
// - `SDL_PROP_IOSTREAM_MEMORY_POINTER`: this will be the `mem` parameter that
//   was passed to this function.
// - `SDL_PROP_IOSTREAM_MEMORY_SIZE_NUMBER`: this will be the `size` parameter
//   that was passed to this function.
//
// `mem` mem a pointer to a read-only buffer to feed an SDL_IOStream stream.
// `size` size the buffer size, in bytes.
// returns a pointer to a new SDL_IOStream structure or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: io_from_mem (SDL_IOFromMem)
// See also: close_io (SDL_CloseIO)
// See also: read_io (SDL_ReadIO)
// See also: seek_io (SDL_SeekIO)
// See also: tell_io (SDL_TellIO)
pub fn io_from_const_mem(const_mem voidptr, size usize) &IOStream {
	return C.SDL_IOFromConstMem(const_mem, size)
}

// C.SDL_IOFromDynamicMem [official documentation](https://wiki.libsdl.org/SDL3/SDL_IOFromDynamicMem)
fn C.SDL_IOFromDynamicMem() &IOStream

// io_from_dynamic_mem uses this function to create an SDL_IOStream that is backed by dynamically
// allocated memory.
//
// This supports the following properties to provide access to the memory and
// control over allocations:
//
// - `SDL_PROP_IOSTREAM_DYNAMIC_MEMORY_POINTER`: a pointer to the internal
//   memory of the stream. This can be set to NULL to transfer ownership of
//   the memory to the application, which should free the memory with
//   SDL_free(). If this is done, the next operation on the stream must be
//   SDL_CloseIO().
// - `SDL_PROP_IOSTREAM_DYNAMIC_CHUNKSIZE_NUMBER`: memory will be allocated in
//   multiples of this size, defaulting to 1024.
//
// returns a pointer to a new SDL_IOStream structure or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: close_io (SDL_CloseIO)
// See also: read_io (SDL_ReadIO)
// See also: seek_io (SDL_SeekIO)
// See also: tell_io (SDL_TellIO)
// See also: write_io (SDL_WriteIO)
pub fn io_from_dynamic_mem() &IOStream {
	return C.SDL_IOFromDynamicMem()
}

pub const prop_iostream_dynamic_memory_pointer = C.SDL_PROP_IOSTREAM_DYNAMIC_MEMORY_POINTER // 'SDL.iostream.dynamic.memory'

pub const prop_iostream_dynamic_chunksize_number = C.SDL_PROP_IOSTREAM_DYNAMIC_CHUNKSIZE_NUMBER // 'SDL.iostream.dynamic.chunksize'

// C.SDL_OpenIO [official documentation](https://wiki.libsdl.org/SDL3/SDL_OpenIO)
fn C.SDL_OpenIO(const_iface &IOStreamInterface, userdata voidptr) &IOStream

// open_io creates a custom SDL_IOStream.
//
// Applications do not need to use this function unless they are providing
// their own SDL_IOStream implementation. If you just need an SDL_IOStream to
// read/write a common data source, you should use the built-in
// implementations in SDL, like SDL_IOFromFile() or SDL_IOFromMem(), etc.
//
// This function makes a copy of `iface` and the caller does not need to keep
// it around after this call.
//
// `iface` iface the interface that implements this SDL_IOStream, initialized
//              using SDL_INIT_INTERFACE().
// `userdata` userdata the pointer that will be passed to the interface functions.
// returns a pointer to the allocated memory on success or NULL on failure;
//          call SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: close_io (SDL_CloseIO)
// See also: initinterface (SDL_INIT_INTERFACE)
// See also: io_from_const_mem (SDL_IOFromConstMem)
// See also: io_from_file (SDL_IOFromFile)
// See also: io_from_mem (SDL_IOFromMem)
pub fn open_io(const_iface &IOStreamInterface, userdata voidptr) &IOStream {
	return C.SDL_OpenIO(const_iface, userdata)
}

// C.SDL_CloseIO [official documentation](https://wiki.libsdl.org/SDL3/SDL_CloseIO)
fn C.SDL_CloseIO(context &IOStream) bool

// close_io closes and free an allocated SDL_IOStream structure.
//
// SDL_CloseIO() closes and cleans up the SDL_IOStream stream. It releases any
// resources used by the stream and frees the SDL_IOStream itself. This
// returns true on success, or false if the stream failed to flush to its
// output (e.g. to disk).
//
// Note that if this fails to flush the stream for any reason, this function
// reports an error, but the SDL_IOStream is still invalid once this function
// returns.
//
// This call flushes any buffered writes to the operating system, but there
// are no guarantees that those writes have gone to physical media; they might
// be in the OS's file cache, waiting to go to disk later. If it's absolutely
// crucial that writes go to disk immediately, so they are definitely stored
// even if the power fails before the file cache would have caught up, one
// should call SDL_FlushIO() before closing. Note that flushing takes time and
// makes the system and your app operate less efficiently, so do so sparingly.
//
// `context` context SDL_IOStream structure to close.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: open_io (SDL_OpenIO)
pub fn close_io(context &IOStream) bool {
	return C.SDL_CloseIO(context)
}

// C.SDL_GetIOProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetIOProperties)
fn C.SDL_GetIOProperties(context &IOStream) PropertiesID

// get_io_properties gets the properties associated with an SDL_IOStream.
//
// `context` context a pointer to an SDL_IOStream structure.
// returns a valid property ID on success or 0 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_io_properties(context &IOStream) PropertiesID {
	return C.SDL_GetIOProperties(context)
}

// C.SDL_GetIOStatus [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetIOStatus)
fn C.SDL_GetIOStatus(context &IOStream) IOStatus

// get_io_status querys the stream status of an SDL_IOStream.
//
// This information can be useful to decide if a short read or write was due
// to an error, an EOF, or a non-blocking operation that isn't yet ready to
// complete.
//
// An SDL_IOStream's status is only expected to change after a SDL_ReadIO or
// SDL_WriteIO call; don't expect it to change if you just call this query
// function in a tight loop.
//
// `context` context the SDL_IOStream to query.
// returns an SDL_IOStatus enum with the current state.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_io_status(context &IOStream) IOStatus {
	return C.SDL_GetIOStatus(context)
}

// C.SDL_GetIOSize [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetIOSize)
fn C.SDL_GetIOSize(context &IOStream) i64

// get_io_size uses this function to get the size of the data stream in an SDL_IOStream.
//
// `context` context the SDL_IOStream to get the size of the data stream from.
// returns the size of the data stream in the SDL_IOStream on success or a
//          negative error code on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_io_size(context &IOStream) i64 {
	return C.SDL_GetIOSize(context)
}

// C.SDL_SeekIO [official documentation](https://wiki.libsdl.org/SDL3/SDL_SeekIO)
fn C.SDL_SeekIO(context &IOStream, offset i64, whence IOWhence) i64

// seek_io seeks within an SDL_IOStream data stream.
//
// This function seeks to byte `offset`, relative to `whence`.
//
// `whence` may be any of the following values:
//
// - `SDL_IO_SEEK_SET`: seek from the beginning of data
// - `SDL_IO_SEEK_CUR`: seek relative to current read point
// - `SDL_IO_SEEK_END`: seek relative to the end of data
//
// If this stream can not seek, it will return -1.
//
// `context` context a pointer to an SDL_IOStream structure.
// `offset` offset an offset in bytes, relative to `whence` location; can be
//               negative.
// `whence` whence any of `SDL_IO_SEEK_SET`, `SDL_IO_SEEK_CUR`,
//               `SDL_IO_SEEK_END`.
// returns the final offset in the data stream after the seek or -1 on
//          failure; call SDL_GetError() for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: tell_io (SDL_TellIO)
pub fn seek_io(context &IOStream, offset i64, whence IOWhence) i64 {
	return C.SDL_SeekIO(context, offset, whence)
}

// C.SDL_TellIO [official documentation](https://wiki.libsdl.org/SDL3/SDL_TellIO)
fn C.SDL_TellIO(context &IOStream) i64

// tell_io determines the current read/write offset in an SDL_IOStream data stream.
//
// SDL_TellIO is actually a wrapper function that calls the SDL_IOStream's
// `seek` method, with an offset of 0 bytes from `SDL_IO_SEEK_CUR`, to
// simplify application development.
//
// `context` context an SDL_IOStream data stream object from which to get the
//                current offset.
// returns the current offset in the stream, or -1 if the information can not
//          be determined.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: seek_io (SDL_SeekIO)
pub fn tell_io(context &IOStream) i64 {
	return C.SDL_TellIO(context)
}

// C.SDL_ReadIO [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadIO)
fn C.SDL_ReadIO(context &IOStream, ptr voidptr, size usize) usize

// read_io reads from a data source.
//
// This function reads up `size` bytes from the data source to the area
// pointed at by `ptr`. This function may read less bytes than requested.
//
// This function will return zero when the data stream is completely read, and
// SDL_GetIOStatus() will return SDL_IO_STATUS_EOF. If zero is returned and
// the stream is not at EOF, SDL_GetIOStatus() will return a different error
// value and SDL_GetError() will offer a human-readable message.
//
// `context` context a pointer to an SDL_IOStream structure.
// `ptr` ptr a pointer to a buffer to read data into.
// `size` size the number of bytes to read from the data source.
// returns the number of bytes read, or 0 on end of file or other failure;
//          call SDL_GetError() for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: write_io (SDL_WriteIO)
// See also: get_io_status (SDL_GetIOStatus)
pub fn read_io(context &IOStream, ptr voidptr, size usize) usize {
	return C.SDL_ReadIO(context, ptr, size)
}

// C.SDL_WriteIO [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteIO)
fn C.SDL_WriteIO(context &IOStream, const_ptr voidptr, size usize) usize

// write_io writes to an SDL_IOStream data stream.
//
// This function writes exactly `size` bytes from the area pointed at by `ptr`
// to the stream. If this fails for any reason, it'll return less than `size`
// to demonstrate how far the write progressed. On success, it returns `size`.
//
// On error, this function still attempts to write as much as possible, so it
// might return a positive value less than the requested write size.
//
// The caller can use SDL_GetIOStatus() to determine if the problem is
// recoverable, such as a non-blocking write that can simply be retried later,
// or a fatal error.
//
// `context` context a pointer to an SDL_IOStream structure.
// `ptr` ptr a pointer to a buffer containing data to write.
// `size` size the number of bytes to write.
// returns the number of bytes written, which will be less than `size` on
//          failure; call SDL_GetError() for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: i_oprintf (SDL_IOprintf)
// See also: read_io (SDL_ReadIO)
// See also: seek_io (SDL_SeekIO)
// See also: flush_io (SDL_FlushIO)
// See also: get_io_status (SDL_GetIOStatus)
pub fn write_io(context &IOStream, const_ptr voidptr, size usize) usize {
	return C.SDL_WriteIO(context, const_ptr, size)
}

/*
TODO:
extern SDL_DECLSPEC size_t SDLCALL SDL_IOprintf(SDL_IOStream *context, SDL_PRINTF_FORMAT_STRING const char *fmt, ...)  SDL_PRINTF_VARARG_FUNC(2);
*/

// /* TODO: */ prints to an SDL_IOStream data stream.
//
// This function does formatted printing to the stream.
//
// `context` context a pointer to an SDL_IOStream structure.
// `fmt` fmt a printf() style format string.
// `...` ... additional parameters matching % tokens in the `fmt` string, if
//            any.
// returns the number of bytes written or 0 on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: i_ovprintf (SDL_IOvprintf)
// See also: write_io (SDL_WriteIO)
//
/*
TODO:
extern SDL_DECLSPEC size_t SDLCALL SDL_IOprintf(SDL_IOStream *context, SDL_PRINTF_FORMAT_STRING const char *fmt, ...)  SDL_PRINTF_VARARG_FUNC(2);
*/

/*
TODO:
extern SDL_DECLSPEC size_t SDLCALL SDL_IOvprintf(SDL_IOStream *context, SDL_PRINTF_FORMAT_STRING const char *fmt, va_list ap) SDL_PRINTF_VARARG_FUNCV(2);
*/

// /* TODO: */ prints to an SDL_IOStream data stream.
//
// This function does formatted printing to the stream.
//
// `context` context a pointer to an SDL_IOStream structure.
// `fmt` fmt a printf() style format string.
// `ap` ap a variable argument list.
// returns the number of bytes written or 0 on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: i_oprintf (SDL_IOprintf)
// See also: write_io (SDL_WriteIO)
//
/*
TODO:
extern SDL_DECLSPEC size_t SDLCALL SDL_IOvprintf(SDL_IOStream *context, SDL_PRINTF_FORMAT_STRING const char *fmt, va_list ap) SDL_PRINTF_VARARG_FUNCV(2);
*/

// C.SDL_FlushIO [official documentation](https://wiki.libsdl.org/SDL3/SDL_FlushIO)
fn C.SDL_FlushIO(context &IOStream) bool

// flush_io flushs any buffered data in the stream.
//
// This function makes sure that any buffered data is written to the stream.
// Normally this isn't necessary but if the stream is a pipe or socket it
// guarantees that any pending data is sent.
//
// `context` context SDL_IOStream structure to flush.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: open_io (SDL_OpenIO)
// See also: write_io (SDL_WriteIO)
pub fn flush_io(context &IOStream) bool {
	return C.SDL_FlushIO(context)
}

// C.SDL_LoadFile_IO [official documentation](https://wiki.libsdl.org/SDL3/SDL_LoadFile_IO)
fn C.SDL_LoadFile_IO(src &IOStream, datasize &usize, closeio bool) voidptr

// load_file_io loads all the data from an SDL data stream.
//
// The data is allocated with a zero byte at the end (null terminated) for
// convenience. This extra byte is not included in the value reported via
// `datasize`.
//
// The data should be freed with SDL_free().
//
// `src` src the SDL_IOStream to read all available data from.
// `datasize` datasize a pointer filled in with the number of bytes read, may be
//                 NULL.
// `closeio` closeio if true, calls SDL_CloseIO() on `src` before returning, even
//                in the case of an error.
// returns the data or NULL on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: load_file (SDL_LoadFile)
// See also: save_file_io (SDL_SaveFile_IO)
pub fn load_file_io(src &IOStream, datasize &usize, closeio bool) voidptr {
	return C.SDL_LoadFile_IO(src, datasize, closeio)
}

// C.SDL_LoadFile [official documentation](https://wiki.libsdl.org/SDL3/SDL_LoadFile)
fn C.SDL_LoadFile(const_file &char, datasize &usize) voidptr

// load_file loads all the data from a file path.
//
// The data is allocated with a zero byte at the end (null terminated) for
// convenience. This extra byte is not included in the value reported via
// `datasize`.
//
// The data should be freed with SDL_free().
//
// `file` file the path to read all available data from.
// `datasize` datasize if not NULL, will store the number of bytes read.
// returns the data or NULL on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: load_file_io (SDL_LoadFile_IO)
// See also: save_file (SDL_SaveFile)
pub fn load_file(const_file &char, datasize &usize) voidptr {
	return C.SDL_LoadFile(const_file, datasize)
}

// C.SDL_SaveFile_IO [official documentation](https://wiki.libsdl.org/SDL3/SDL_SaveFile_IO)
fn C.SDL_SaveFile_IO(src &IOStream, const_data voidptr, datasize usize, closeio bool) bool

// save_file_io saves all the data into an SDL data stream.
//
// `src` src the SDL_IOStream to write all data to.
// `data` data the data to be written. If datasize is 0, may be NULL or a
//             invalid pointer.
// `datasize` datasize the number of bytes to be written.
// `closeio` closeio if true, calls SDL_CloseIO() on `src` before returning, even
//                in the case of an error.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: save_file (SDL_SaveFile)
// See also: load_file_io (SDL_LoadFile_IO)
pub fn save_file_io(src &IOStream, const_data voidptr, datasize usize, closeio bool) bool {
	return C.SDL_SaveFile_IO(src, const_data, datasize, closeio)
}

// C.SDL_SaveFile [official documentation](https://wiki.libsdl.org/SDL3/SDL_SaveFile)
fn C.SDL_SaveFile(const_file &char, const_data voidptr, datasize usize) bool

// save_file saves all the data into a file path.
//
// `file` file the path to write all available data into.
// `data` data the data to be written. If datasize is 0, may be NULL or a
//             invalid pointer.
// `datasize` datasize the number of bytes to be written.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: save_file_io (SDL_SaveFile_IO)
// See also: load_file (SDL_LoadFile)
pub fn save_file(const_file &char, const_data voidptr, datasize usize) bool {
	return C.SDL_SaveFile(const_file, const_data, datasize)
}

// C.SDL_ReadU8 [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadU8)
fn C.SDL_ReadU8(src &IOStream, value &u8) bool

// read_u8 uses this function to read a byte from an SDL_IOStream.
//
// This function will return false when the data stream is completely read,
// and SDL_GetIOStatus() will return SDL_IO_STATUS_EOF. If false is returned
// and the stream is not at EOF, SDL_GetIOStatus() will return a different
// error value and SDL_GetError() will offer a human-readable message.
//
// `src` src the SDL_IOStream to read from.
// `value` value a pointer filled in with the data read.
// returns true on success or false on failure or EOF; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn read_u8(src &IOStream, value &u8) bool {
	return C.SDL_ReadU8(src, value)
}

// C.SDL_ReadS8 [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadS8)
fn C.SDL_ReadS8(src &IOStream, value &i8) bool

// read_s8 uses this function to read a signed byte from an SDL_IOStream.
//
// This function will return false when the data stream is completely read,
// and SDL_GetIOStatus() will return SDL_IO_STATUS_EOF. If false is returned
// and the stream is not at EOF, SDL_GetIOStatus() will return a different
// error value and SDL_GetError() will offer a human-readable message.
//
// `src` src the SDL_IOStream to read from.
// `value` value a pointer filled in with the data read.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn read_s8(src &IOStream, value &i8) bool {
	return C.SDL_ReadS8(src, value)
}

// C.SDL_ReadU16LE [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadU16LE)
fn C.SDL_ReadU16LE(src &IOStream, value &u16) bool

// read_u16_le uses this function to read 16 bits of little-endian data from an
// SDL_IOStream and return in native format.
//
// SDL byteswaps the data only if necessary, so the data returned will be in
// the native byte order.
//
// This function will return false when the data stream is completely read,
// and SDL_GetIOStatus() will return SDL_IO_STATUS_EOF. If false is returned
// and the stream is not at EOF, SDL_GetIOStatus() will return a different
// error value and SDL_GetError() will offer a human-readable message.
//
// `src` src the stream from which to read data.
// `value` value a pointer filled in with the data read.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn read_u16_le(src &IOStream, value &u16) bool {
	return C.SDL_ReadU16LE(src, value)
}

// C.SDL_ReadS16LE [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadS16LE)
fn C.SDL_ReadS16LE(src &IOStream, value &i16) bool

// read_s16_le uses this function to read 16 bits of little-endian data from an
// SDL_IOStream and return in native format.
//
// SDL byteswaps the data only if necessary, so the data returned will be in
// the native byte order.
//
// This function will return false when the data stream is completely read,
// and SDL_GetIOStatus() will return SDL_IO_STATUS_EOF. If false is returned
// and the stream is not at EOF, SDL_GetIOStatus() will return a different
// error value and SDL_GetError() will offer a human-readable message.
//
// `src` src the stream from which to read data.
// `value` value a pointer filled in with the data read.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn read_s16_le(src &IOStream, value &i16) bool {
	return C.SDL_ReadS16LE(src, value)
}

// C.SDL_ReadU16BE [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadU16BE)
fn C.SDL_ReadU16BE(src &IOStream, value &u16) bool

// read_u16_be uses this function to read 16 bits of big-endian data from an SDL_IOStream
// and return in native format.
//
// SDL byteswaps the data only if necessary, so the data returned will be in
// the native byte order.
//
// This function will return false when the data stream is completely read,
// and SDL_GetIOStatus() will return SDL_IO_STATUS_EOF. If false is returned
// and the stream is not at EOF, SDL_GetIOStatus() will return a different
// error value and SDL_GetError() will offer a human-readable message.
//
// `src` src the stream from which to read data.
// `value` value a pointer filled in with the data read.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn read_u16_be(src &IOStream, value &u16) bool {
	return C.SDL_ReadU16BE(src, value)
}

// C.SDL_ReadS16BE [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadS16BE)
fn C.SDL_ReadS16BE(src &IOStream, value &i16) bool

// read_s16_be uses this function to read 16 bits of big-endian data from an SDL_IOStream
// and return in native format.
//
// SDL byteswaps the data only if necessary, so the data returned will be in
// the native byte order.
//
// This function will return false when the data stream is completely read,
// and SDL_GetIOStatus() will return SDL_IO_STATUS_EOF. If false is returned
// and the stream is not at EOF, SDL_GetIOStatus() will return a different
// error value and SDL_GetError() will offer a human-readable message.
//
// `src` src the stream from which to read data.
// `value` value a pointer filled in with the data read.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn read_s16_be(src &IOStream, value &i16) bool {
	return C.SDL_ReadS16BE(src, value)
}

// C.SDL_ReadU32LE [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadU32LE)
fn C.SDL_ReadU32LE(src &IOStream, value &u32) bool

// read_u32_le uses this function to read 32 bits of little-endian data from an
// SDL_IOStream and return in native format.
//
// SDL byteswaps the data only if necessary, so the data returned will be in
// the native byte order.
//
// This function will return false when the data stream is completely read,
// and SDL_GetIOStatus() will return SDL_IO_STATUS_EOF. If false is returned
// and the stream is not at EOF, SDL_GetIOStatus() will return a different
// error value and SDL_GetError() will offer a human-readable message.
//
// `src` src the stream from which to read data.
// `value` value a pointer filled in with the data read.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn read_u32_le(src &IOStream, value &u32) bool {
	return C.SDL_ReadU32LE(src, value)
}

// C.SDL_ReadS32LE [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadS32LE)
fn C.SDL_ReadS32LE(src &IOStream, value &int) bool

// read_s32_le uses this function to read 32 bits of little-endian data from an
// SDL_IOStream and return in native format.
//
// SDL byteswaps the data only if necessary, so the data returned will be in
// the native byte order.
//
// This function will return false when the data stream is completely read,
// and SDL_GetIOStatus() will return SDL_IO_STATUS_EOF. If false is returned
// and the stream is not at EOF, SDL_GetIOStatus() will return a different
// error value and SDL_GetError() will offer a human-readable message.
//
// `src` src the stream from which to read data.
// `value` value a pointer filled in with the data read.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn read_s32_le(src &IOStream, value &int) bool {
	return C.SDL_ReadS32LE(src, value)
}

// C.SDL_ReadU32BE [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadU32BE)
fn C.SDL_ReadU32BE(src &IOStream, value &u32) bool

// read_u32_be uses this function to read 32 bits of big-endian data from an SDL_IOStream
// and return in native format.
//
// SDL byteswaps the data only if necessary, so the data returned will be in
// the native byte order.
//
// This function will return false when the data stream is completely read,
// and SDL_GetIOStatus() will return SDL_IO_STATUS_EOF. If false is returned
// and the stream is not at EOF, SDL_GetIOStatus() will return a different
// error value and SDL_GetError() will offer a human-readable message.
//
// `src` src the stream from which to read data.
// `value` value a pointer filled in with the data read.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn read_u32_be(src &IOStream, value &u32) bool {
	return C.SDL_ReadU32BE(src, value)
}

// C.SDL_ReadS32BE [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadS32BE)
fn C.SDL_ReadS32BE(src &IOStream, value &int) bool

// read_s32_be uses this function to read 32 bits of big-endian data from an SDL_IOStream
// and return in native format.
//
// SDL byteswaps the data only if necessary, so the data returned will be in
// the native byte order.
//
// This function will return false when the data stream is completely read,
// and SDL_GetIOStatus() will return SDL_IO_STATUS_EOF. If false is returned
// and the stream is not at EOF, SDL_GetIOStatus() will return a different
// error value and SDL_GetError() will offer a human-readable message.
//
// `src` src the stream from which to read data.
// `value` value a pointer filled in with the data read.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn read_s32_be(src &IOStream, value &int) bool {
	return C.SDL_ReadS32BE(src, value)
}

// C.SDL_ReadU64LE [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadU64LE)
fn C.SDL_ReadU64LE(src &IOStream, value &u64) bool

// read_u64_le uses this function to read 64 bits of little-endian data from an
// SDL_IOStream and return in native format.
//
// SDL byteswaps the data only if necessary, so the data returned will be in
// the native byte order.
//
// This function will return false when the data stream is completely read,
// and SDL_GetIOStatus() will return SDL_IO_STATUS_EOF. If false is returned
// and the stream is not at EOF, SDL_GetIOStatus() will return a different
// error value and SDL_GetError() will offer a human-readable message.
//
// `src` src the stream from which to read data.
// `value` value a pointer filled in with the data read.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn read_u64_le(src &IOStream, value &u64) bool {
	return C.SDL_ReadU64LE(src, value)
}

// C.SDL_ReadS64LE [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadS64LE)
fn C.SDL_ReadS64LE(src &IOStream, value &i64) bool

// read_s64_le uses this function to read 64 bits of little-endian data from an
// SDL_IOStream and return in native format.
//
// SDL byteswaps the data only if necessary, so the data returned will be in
// the native byte order.
//
// This function will return false when the data stream is completely read,
// and SDL_GetIOStatus() will return SDL_IO_STATUS_EOF. If false is returned
// and the stream is not at EOF, SDL_GetIOStatus() will return a different
// error value and SDL_GetError() will offer a human-readable message.
//
// `src` src the stream from which to read data.
// `value` value a pointer filled in with the data read.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn read_s64_le(src &IOStream, value &i64) bool {
	return C.SDL_ReadS64LE(src, value)
}

// C.SDL_ReadU64BE [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadU64BE)
fn C.SDL_ReadU64BE(src &IOStream, value &u64) bool

// read_u64_be uses this function to read 64 bits of big-endian data from an SDL_IOStream
// and return in native format.
//
// SDL byteswaps the data only if necessary, so the data returned will be in
// the native byte order.
//
// This function will return false when the data stream is completely read,
// and SDL_GetIOStatus() will return SDL_IO_STATUS_EOF. If false is returned
// and the stream is not at EOF, SDL_GetIOStatus() will return a different
// error value and SDL_GetError() will offer a human-readable message.
//
// `src` src the stream from which to read data.
// `value` value a pointer filled in with the data read.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn read_u64_be(src &IOStream, value &u64) bool {
	return C.SDL_ReadU64BE(src, value)
}

// C.SDL_ReadS64BE [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadS64BE)
fn C.SDL_ReadS64BE(src &IOStream, value &i64) bool

// read_s64_be uses this function to read 64 bits of big-endian data from an SDL_IOStream
// and return in native format.
//
// SDL byteswaps the data only if necessary, so the data returned will be in
// the native byte order.
//
// This function will return false when the data stream is completely read,
// and SDL_GetIOStatus() will return SDL_IO_STATUS_EOF. If false is returned
// and the stream is not at EOF, SDL_GetIOStatus() will return a different
// error value and SDL_GetError() will offer a human-readable message.
//
// `src` src the stream from which to read data.
// `value` value a pointer filled in with the data read.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn read_s64_be(src &IOStream, value &i64) bool {
	return C.SDL_ReadS64BE(src, value)
}

// C.SDL_WriteU8 [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteU8)
fn C.SDL_WriteU8(dst &IOStream, value u8) bool

// write_u8 uses this function to write a byte to an SDL_IOStream.
//
// `dst` dst the SDL_IOStream to write to.
// `value` value the byte value to write.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn write_u8(dst &IOStream, value u8) bool {
	return C.SDL_WriteU8(dst, value)
}

// C.SDL_WriteS8 [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteS8)
fn C.SDL_WriteS8(dst &IOStream, value i8) bool

// write_s8 uses this function to write a signed byte to an SDL_IOStream.
//
// `dst` dst the SDL_IOStream to write to.
// `value` value the byte value to write.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn write_s8(dst &IOStream, value i8) bool {
	return C.SDL_WriteS8(dst, value)
}

// C.SDL_WriteU16LE [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteU16LE)
fn C.SDL_WriteU16LE(dst &IOStream, value u16) bool

// write_u16_le uses this function to write 16 bits in native format to an SDL_IOStream as
// little-endian data.
//
// SDL byteswaps the data only if necessary, so the application always
// specifies native format, and the data written will be in little-endian
// format.
//
// `dst` dst the stream to which data will be written.
// `value` value the data to be written, in native format.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn write_u16_le(dst &IOStream, value u16) bool {
	return C.SDL_WriteU16LE(dst, value)
}

// C.SDL_WriteS16LE [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteS16LE)
fn C.SDL_WriteS16LE(dst &IOStream, value i16) bool

// write_s16_le uses this function to write 16 bits in native format to an SDL_IOStream as
// little-endian data.
//
// SDL byteswaps the data only if necessary, so the application always
// specifies native format, and the data written will be in little-endian
// format.
//
// `dst` dst the stream to which data will be written.
// `value` value the data to be written, in native format.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn write_s16_le(dst &IOStream, value i16) bool {
	return C.SDL_WriteS16LE(dst, value)
}

// C.SDL_WriteU16BE [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteU16BE)
fn C.SDL_WriteU16BE(dst &IOStream, value u16) bool

// write_u16_be uses this function to write 16 bits in native format to an SDL_IOStream as
// big-endian data.
//
// SDL byteswaps the data only if necessary, so the application always
// specifies native format, and the data written will be in big-endian format.
//
// `dst` dst the stream to which data will be written.
// `value` value the data to be written, in native format.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn write_u16_be(dst &IOStream, value u16) bool {
	return C.SDL_WriteU16BE(dst, value)
}

// C.SDL_WriteS16BE [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteS16BE)
fn C.SDL_WriteS16BE(dst &IOStream, value i16) bool

// write_s16_be uses this function to write 16 bits in native format to an SDL_IOStream as
// big-endian data.
//
// SDL byteswaps the data only if necessary, so the application always
// specifies native format, and the data written will be in big-endian format.
//
// `dst` dst the stream to which data will be written.
// `value` value the data to be written, in native format.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn write_s16_be(dst &IOStream, value i16) bool {
	return C.SDL_WriteS16BE(dst, value)
}

// C.SDL_WriteU32LE [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteU32LE)
fn C.SDL_WriteU32LE(dst &IOStream, value u32) bool

// write_u32_le uses this function to write 32 bits in native format to an SDL_IOStream as
// little-endian data.
//
// SDL byteswaps the data only if necessary, so the application always
// specifies native format, and the data written will be in little-endian
// format.
//
// `dst` dst the stream to which data will be written.
// `value` value the data to be written, in native format.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn write_u32_le(dst &IOStream, value u32) bool {
	return C.SDL_WriteU32LE(dst, value)
}

// C.SDL_WriteS32LE [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteS32LE)
fn C.SDL_WriteS32LE(dst &IOStream, value int) bool

// write_s32_le uses this function to write 32 bits in native format to an SDL_IOStream as
// little-endian data.
//
// SDL byteswaps the data only if necessary, so the application always
// specifies native format, and the data written will be in little-endian
// format.
//
// `dst` dst the stream to which data will be written.
// `value` value the data to be written, in native format.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn write_s32_le(dst &IOStream, value int) bool {
	return C.SDL_WriteS32LE(dst, value)
}

// C.SDL_WriteU32BE [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteU32BE)
fn C.SDL_WriteU32BE(dst &IOStream, value u32) bool

// write_u32_be uses this function to write 32 bits in native format to an SDL_IOStream as
// big-endian data.
//
// SDL byteswaps the data only if necessary, so the application always
// specifies native format, and the data written will be in big-endian format.
//
// `dst` dst the stream to which data will be written.
// `value` value the data to be written, in native format.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn write_u32_be(dst &IOStream, value u32) bool {
	return C.SDL_WriteU32BE(dst, value)
}

// C.SDL_WriteS32BE [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteS32BE)
fn C.SDL_WriteS32BE(dst &IOStream, value int) bool

// write_s32_be uses this function to write 32 bits in native format to an SDL_IOStream as
// big-endian data.
//
// SDL byteswaps the data only if necessary, so the application always
// specifies native format, and the data written will be in big-endian format.
//
// `dst` dst the stream to which data will be written.
// `value` value the data to be written, in native format.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn write_s32_be(dst &IOStream, value int) bool {
	return C.SDL_WriteS32BE(dst, value)
}

// C.SDL_WriteU64LE [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteU64LE)
fn C.SDL_WriteU64LE(dst &IOStream, value u64) bool

// write_u64_le uses this function to write 64 bits in native format to an SDL_IOStream as
// little-endian data.
//
// SDL byteswaps the data only if necessary, so the application always
// specifies native format, and the data written will be in little-endian
// format.
//
// `dst` dst the stream to which data will be written.
// `value` value the data to be written, in native format.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn write_u64_le(dst &IOStream, value u64) bool {
	return C.SDL_WriteU64LE(dst, value)
}

// C.SDL_WriteS64LE [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteS64LE)
fn C.SDL_WriteS64LE(dst &IOStream, value i64) bool

// write_s64_le uses this function to write 64 bits in native format to an SDL_IOStream as
// little-endian data.
//
// SDL byteswaps the data only if necessary, so the application always
// specifies native format, and the data written will be in little-endian
// format.
//
// `dst` dst the stream to which data will be written.
// `value` value the data to be written, in native format.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn write_s64_le(dst &IOStream, value i64) bool {
	return C.SDL_WriteS64LE(dst, value)
}

// C.SDL_WriteU64BE [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteU64BE)
fn C.SDL_WriteU64BE(dst &IOStream, value u64) bool

// write_u64_be uses this function to write 64 bits in native format to an SDL_IOStream as
// big-endian data.
//
// SDL byteswaps the data only if necessary, so the application always
// specifies native format, and the data written will be in big-endian format.
//
// `dst` dst the stream to which data will be written.
// `value` value the data to be written, in native format.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn write_u64_be(dst &IOStream, value u64) bool {
	return C.SDL_WriteU64BE(dst, value)
}

// C.SDL_WriteS64BE [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteS64BE)
fn C.SDL_WriteS64BE(dst &IOStream, value i64) bool

// write_s64_be uses this function to write 64 bits in native format to an SDL_IOStream as
// big-endian data.
//
// SDL byteswaps the data only if necessary, so the application always
// specifies native format, and the data written will be in big-endian format.
//
// `dst` dst the stream to which data will be written.
// `value` value the data to be written, in native format.
// returns true on successful write or false on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn write_s64_be(dst &IOStream, value i64) bool {
	return C.SDL_WriteS64BE(dst, value)
}

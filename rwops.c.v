// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_rwops.h
//

pub const (
	rwops_unknown   = C.SDL_RWOPS_UNKNOWN // 0U, Unknown stream type
	rwops_winfile   = C.SDL_RWOPS_WINFILE // 1U, Win32 file
	rwops_stdfile   = C.SDL_RWOPS_STDFILE // 2U, Stdio file
	rwops_jnifile   = C.SDL_RWOPS_JNIFILE // 3U, Android asset
	rwops_memory    = C.SDL_RWOPS_MEMORY // 4U, Memory stream
	rwops_memory_ro = C.SDL_RWOPS_MEMORY_RO // 5U, Read-Only memory stream
)

pub const (
	rw_seek_set = C.RW_SEEK_SET // 0, Seek from the beginning of data
	rw_seek_cur = C.RW_SEEK_CUR // 1, Seek relative to current read point
	rw_seek_end = C.RW_SEEK_END // 2, Seek relative to the end of data
)

fn C.SDL_RWsize(context &C.SDL_RWops) i64

// rw_size uses this macro to get the size of the data stream in an SDL_RWops.
//
// `context` the SDL_RWops to get the size of the data stream from
// returns the size of the data stream in the SDL_RWops on success, -1 if
//          unknown or a negative error code on failure; call SDL_GetError()
//          for more information.
//
// NOTE This function is available since SDL 2.0.0.
pub fn rw_size(context &RWops) i64 {
	return C.SDL_RWsize(context)
}

fn C.SDL_RWseek(context &C.SDL_RWops, offset i64, whence int) i64

// rw_seek seeks within an SDL_RWops data stream.
//
// This function seeks to byte `offset`, relative to `whence`.
//
// `whence` may be any of the following values:
//
// - `RW_SEEK_SET`: seek from the beginning of data
// - `RW_SEEK_CUR`: seek relative to current read point
// - `RW_SEEK_END`: seek relative to the end of data
//
// If this stream can not seek, it will return -1.
//
// SDL_RWseek() is actually a wrapper function that calls the SDL_RWops's
// `seek` method appropriately, to simplify application development.
//
// `context` a pointer to an SDL_RWops structure
// `offset` an offset in bytes, relative to **whence** location; can be
//               negative
// `whence` any of `RW_SEEK_SET`, `RW_SEEK_CUR`, `RW_SEEK_END`
// returns the final offset in the data stream after the seek or -1 on error.
//
// See also: SDL_RWclose
// See also: SDL_RWFromConstMem
// See also: SDL_RWFromFile
// See also: SDL_RWFromFP
// See also: SDL_RWFromMem
// See also: SDL_RWread
// See also: SDL_RWtell
// See also: SDL_RWwrite
pub fn rw_seek(context &RWops, offset i64, whence int) i64 {
	return C.SDL_RWseek(context, offset, whence)
}

fn C.SDL_RWtell(context &C.SDL_RWops) i64

// rw_tell determines the current read/write offset in an SDL_RWops data stream.
//
// SDL_RWtell is actually a wrapper function that calls the SDL_RWops's `seek`
// method, with an offset of 0 bytes from `RW_SEEK_CUR`, to simplify
// application development.
//
// `context` a SDL_RWops data stream object from which to get the current
//                offset
// returns the current offset in the stream, or -1 if the information can not
//          be determined.
//
// See also: SDL_RWclose
// See also: SDL_RWFromConstMem
// See also: SDL_RWFromFile
// See also: SDL_RWFromFP
// See also: SDL_RWFromMem
// See also: SDL_RWread
// See also: SDL_RWseek
// See also: SDL_RWwrite
pub fn rw_tell(context &RWops) i64 {
	return C.SDL_RWtell(context)
}

fn C.SDL_RWread(context &C.SDL_RWops, ptr voidptr, size usize, maxnum usize) usize

// rw_read reads from a data source.
//
// This function reads up to `maxnum` objects each of size `size` from the
// data source to the area pointed at by `ptr`. This function may read less
// objects than requested. It will return zero when there has been an error or
// the data stream is completely read.
//
// SDL_RWread() is actually a function wrapper that calls the SDL_RWops's
// `read` method appropriately, to simplify application development.
//
// `context` a pointer to an SDL_RWops structure
// `ptr` a pointer to a buffer to read data into
// `size` the size of each object to read, in bytes
// `maxnum` the maximum number of objects to be read
// returns the number of objects read, or 0 at error or end of file; call
//          SDL_GetError() for more information.
//
// See also: SDL_RWclose
// See also: SDL_RWFromConstMem
// See also: SDL_RWFromFile
// See also: SDL_RWFromFP
// See also: SDL_RWFromMem
// See also: SDL_RWseek
// See also: SDL_RWwrite
pub fn rw_read(context &RWops, ptr voidptr, size usize, maxnum usize) usize {
	return C.SDL_RWread(context, ptr, size, maxnum)
}

fn C.SDL_RWwrite(context &C.SDL_RWops, ptr voidptr, size usize, num usize) usize

// rw_write writes to an SDL_RWops data stream.
//
// This function writes exactly `num` objects each of size `size` from the
// area pointed at by `ptr` to the stream. If this fails for any reason, it'll
// return less than `num` to demonstrate how far the write progressed. On
// success, it returns `num`.
//
// SDL_RWwrite is actually a function wrapper that calls the SDL_RWops's
// `write` method appropriately, to simplify application development.
//
// `context` a pointer to an SDL_RWops structure
// `ptr` a pointer to a buffer containing data to write
// `size` the size of an object to write, in bytes
// `num` the number of objects to write
// returns the number of objects written, which will be less than **num** on
//          error; call SDL_GetError() for more information.
//
// See also: SDL_RWclose
// See also: SDL_RWFromConstMem
// See also: SDL_RWFromFile
// See also: SDL_RWFromFP
// See also: SDL_RWFromMem
// See also: SDL_RWread
// See also: SDL_RWseek
pub fn rw_write(context &RWops, ptr voidptr, size usize, num usize) usize {
	return C.SDL_RWwrite(context, ptr, size, num)
}

fn C.SDL_RWclose(context &C.SDL_RWops) int

// rw_close closes and free an allocated SDL_RWops structure.
//
// SDL_RWclose() closes and cleans up the SDL_RWops stream. It releases any
// resources used by the stream and frees the SDL_RWops itself with
// SDL_FreeRW(). This returns 0 on success, or -1 if the stream failed to
// flush to its output (e.g. to disk).
//
// Note that if this fails to flush the stream to disk, this function reports
// an error, but the SDL_RWops is still invalid once this function returns.
//
// SDL_RWclose() is actually a macro that calls the SDL_RWops's `close` method
// appropriately, to simplify application development.
//
// `context` SDL_RWops structure to close
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// See also: SDL_RWFromConstMem
// See also: SDL_RWFromFile
// See also: SDL_RWFromFP
// See also: SDL_RWFromMem
// See also: SDL_RWread
// See also: SDL_RWseek
// See also: SDL_RWwrite
pub fn rw_close(context &RWops) int {
	return C.SDL_RWclose(context)
}

// This is the read/write operation structure -- very basic.
[typedef]
struct C.SDL_RWops {
pub:
	// Returns the size of the file in this rwops, or -1 if unknown
	// `Sint64 (SDLCALL * size) (struct SDL_RWops * context);`
	size fn (context &C.SDL_RWops) i64
	// Seeks to `offset` relative to `whence`, one of stdio's whence values:
	// RW_SEEK_SET, RW_SEEK_CUR, RW_SEEK_END
	//
	// returns the final offset in the data stream, or -1 on error.
	// `Sint64 (SDLCALL * seek) (struct SDL_RWops * context, Sint64 offset, int whence);`
	seek fn (context &C.SDL_RWops, offset i64, whence int) i64
	// Reads up to `maxnum` objects each of size `size` from the data
	// stream to the area pointed at by `ptr`.
	//
	// returns the number of objects read, or 0 at error or end of file.
	// `size_t (SDLCALL * read) (struct SDL_RWops * context, void *ptr, size_t size, size_t maxnum);`
	read fn (context &C.SDL_RWops, ptr voidptr, size usize, maxnum usize) usize
	// Writes exactly `num` objects each of size `size` from the area
	// pointed at by `ptr` to data stream.
	//
	// returns the number of objects written, or 0 at error or end of file.
	// `size_t (SDLCALL * write) (struct SDL_RWops * context, const void *ptr, size_t size, size_t num);`
	write fn (context &C.SDL_RWops, const_ptr voidptr, size usize, num usize) usize
	// Closes and frees an allocated SDL_RWops structure.
	//
	// returns 0 if successful or -1 on write error when flushing data.
	// `int (SDLCALL * close) (struct SDL_RWops * context);`
	close fn (context &C.SDL_RWops) int

	@type u32
}

pub type RWops = C.SDL_RWops

// size returns the size of the file in this rwops, or -1 if unknown
pub fn (rwo &RWops) size() i64 {
	return C.SDL_RWsize(rwo)
}

// seek seeks to `offset` relative to `whence`, one of stdio's whence values:
// RW_SEEK_SET, RW_SEEK_CUR, RW_SEEK_END
//
// returns the final offset in the data stream, or -1 on error.
pub fn (rwo &RWops) seek(offset i64, whence int) i64 {
	return C.SDL_RWseek(rwo, offset, whence)
}

// read reads up to `maxnum` objects each of size `size` from the data
// stream to the area pointed at by `ptr`.
//
// returns the number of objects read, or 0 at error or end of file.
pub fn (rwo &RWops) read(ptr voidptr, size usize, maxnum usize) usize {
	return C.SDL_RWread(rwo, ptr, size, maxnum)
}

// write writes exactly `num` objects each of size `size` from the area
// pointed at by `ptr` to data stream.
//
// returns the number of objects written, or 0 at error or end of file.
// `size_t (SDLCALL * write) (struct SDL_RWops * context, const void *ptr, size_t size, size_t num);`
pub fn (rwo &RWops) write(ptr voidptr, size usize, num usize) usize {
	return C.SDL_RWwrite(rwo, ptr, size, num)
}

// close closes and frees an allocated SDL_RWops structure.
//
// returns 0 if successful or -1 on write error when flushing data.
// `int (SDLCALL * close) (struct SDL_RWops * context);`
pub fn (rwo &RWops) close() int {
	return C.SDL_RWclose(rwo)
}

// RWFrom functions
//
// Functions to create SDL_RWops structures from various data streams.
fn C.SDL_RWFromFile(const_file &char, const_mode &char) &C.SDL_RWops
pub fn rw_from_file(const_file &char, const_mode &char) &RWops {
	return C.SDL_RWFromFile(const_file, const_mode)
}

/*
#ifdef HAVE_STDIO_H
// extern DECLSPEC SDL_RWops *SDLCALL SDL_RWFromFP(FILE * fp, SDL_bool autoclose)
fn C.SDL_RWFromFP(fp &C.FILE, autoclose bool) &C.SDL_RWops
pub fn rw_from_fp(fp &C.FILE, autoclose bool) &RWops{
	return C.SDL_RWFromFP(fp, autoclose)
}
*/
fn C.SDL_RWFromFP(fp voidptr, autoclose bool) &C.SDL_RWops
pub fn rw_from_fp(fp voidptr, autoclose bool) &RWops {
	return C.SDL_RWFromFP(fp, autoclose)
}

fn C.SDL_RWFromMem(mem voidptr, size int) &C.SDL_RWops
pub fn rw_from_mem(mem voidptr, size int) &RWops {
	return C.SDL_RWFromMem(mem, size)
}

fn C.SDL_RWFromConstMem(mem voidptr, size int) &C.SDL_RWops
pub fn rw_from_const_mem(mem voidptr, size int) &RWops {
	return C.SDL_RWFromConstMem(mem, size)
}

fn C.SDL_AllocRW() &C.SDL_RWops
pub fn alloc_rw() &RWops {
	return C.SDL_AllocRW()
}

fn C.SDL_FreeRW(area &C.SDL_RWops)
pub fn free_rw(area &RWops) {
	C.SDL_FreeRW(area)
}

fn C.SDL_LoadFile_RW(src &C.SDL_RWops, datasize &usize, freesrc int) voidptr

// load_file_rw loads all the data from an SDL data stream.
//
// The data is allocated with a zero byte at the end (null terminated) for
// convenience. This extra byte is not included in the value reported via
// `datasize`.
//
// The data should be freed with SDL_free().
//
// `src` the SDL_RWops to read all available data from
// `datasize` if not NULL, will store the number of bytes read
// `freesrc` if non-zero, calls SDL_RWclose() on `src` before returning
// returns the data, or NULL if there was an error.
pub fn load_file_rw(src &RWops, datasize &usize, freesrc int) voidptr {
	return C.SDL_LoadFile_RW(src, datasize, freesrc)
}

fn C.SDL_LoadFile(file &char, datasize &usize) voidptr

// load_file loads all the data from a file path.
//
// The data is allocated with a zero byte at the end (null terminated) for
// convenience. This extra byte is not included in the value reported via
// `datasize`.
//
// The data should be freed with SDL_free().
//
// `file` the path to read all available data from
// `datasize` if not NULL, will store the number of bytes read
// returns the data, or NULL if there was an error.
pub fn load_file(file &char, datasize &usize) voidptr {
	return C.SDL_LoadFile(file, datasize)
}

// Read endian functions
//
// Read an item of the specified endianness and return in native format.
fn C.SDL_ReadU8(src &C.SDL_RWops) byte
pub fn read_u8(src &RWops) byte {
	return C.SDL_ReadU8(src)
}

fn C.SDL_ReadLE16(src &C.SDL_RWops) u16
pub fn read_le16(src &RWops) u16 {
	return C.SDL_ReadLE16(src)
}

fn C.SDL_ReadBE16(src &C.SDL_RWops) u16
pub fn read_be16(src &RWops) u16 {
	return C.SDL_ReadBE16(src)
}

fn C.SDL_ReadLE32(src &C.SDL_RWops) u32
pub fn read_le32(src &RWops) u32 {
	return C.SDL_ReadLE32(src)
}

fn C.SDL_ReadBE32(src &C.SDL_RWops) u32
pub fn read_be32(src &RWops) u32 {
	return C.SDL_ReadBE32(src)
}

fn C.SDL_ReadLE64(src &C.SDL_RWops) u64
pub fn read_le64(src &RWops) u64 {
	return C.SDL_ReadLE64(src)
}

fn C.SDL_ReadBE64(src &C.SDL_RWops) u64
pub fn read_be64(src &RWops) u64 {
	return C.SDL_ReadBE64(src)
}

// Write endian functions
//
// Write an item of native format to the specified endianness.
fn C.SDL_WriteU8(dst &C.SDL_RWops, value byte) usize
pub fn write_u8(dst &RWops, value byte) usize {
	return C.SDL_WriteU8(dst, value)
}

fn C.SDL_WriteLE16(dst &C.SDL_RWops, value u16) usize
pub fn write_le16(dst &RWops, value u16) usize {
	return C.SDL_WriteLE16(dst, value)
}

fn C.SDL_WriteBE16(dst &C.SDL_RWops, value u16) usize
pub fn write_be16(dst &RWops, value u16) usize {
	return C.SDL_WriteBE16(dst, value)
}

fn C.SDL_WriteLE32(dst &C.SDL_RWops, value u32) usize
pub fn write_le32(dst &RWops, value u32) usize {
	return C.SDL_WriteLE32(dst, value)
}

fn C.SDL_WriteBE32(dst &C.SDL_RWops, value u32) usize
pub fn write_be32(dst &RWops, value u32) usize {
	return C.SDL_WriteBE32(dst, value)
}

fn C.SDL_WriteLE64(dst &C.SDL_RWops, value u64) usize
pub fn write_le64(dst &RWops, value u64) usize {
	return C.SDL_WriteLE64(dst, value)
}

fn C.SDL_WriteBE64(dst &C.SDL_RWops, value u64) usize
pub fn write_be64(dst &RWops, value u64) usize {
	return C.SDL_WriteBE64(dst, value)
}

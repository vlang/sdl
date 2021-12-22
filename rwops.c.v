// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_rwops.h
//

const (
	rwops_unknown   = C.SDL_RWOPS_UNKNOWN // 0U, Unknown stream type
	rwops_winfile   = C.SDL_RWOPS_WINFILE // 1U, Win32 file
	rwops_stdfile   = C.SDL_RWOPS_STDFILE // 2U, Stdio file
	rwops_jnifile   = C.SDL_RWOPS_JNIFILE // 3U, Android asset
	rwops_memory    = C.SDL_RWOPS_MEMORY // 4U, Memory stream
	rwops_memory_ro = C.SDL_RWOPS_MEMORY_RO // 5U, Read-Only memory stream
)

const (
	rw_seek_set = C.RW_SEEK_SET // 0, Seek from the beginning of data
	rw_seek_cur = C.RW_SEEK_CUR // 1, Seek relative to current read point
	rw_seek_end = C.RW_SEEK_END // 2, Seek relative to the end of data
)

// Read/write macros
//
// Macros to easily read and write from an SDL_RWops structure.
fn C.SDL_RWsize(ctx &C.SDL_RWops) i64
fn C.SDL_RWseek(ctx &C.SDL_RWops, offset i64, whence int) i64
fn C.SDL_RWtell(ctx &C.SDL_RWops) i64
fn C.SDL_RWread(ctx &C.SDL_RWops, ptr voidptr, size usize, n usize) usize
fn C.SDL_RWwrite(ctx &C.SDL_RWops, ptr voidptr, size usize, n usize) usize
fn C.SDL_RWclose(ctx &C.SDL_RWops) int

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
	write fn (context &C.SDL_RWops, ptr voidptr, size usize, num usize) usize
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
pub fn (rwo &RWops) write(context &C.SDL_RWops, ptr voidptr, size usize, num usize) usize {
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
fn C.SDL_RWFromFile(file &char, mode &char) &C.SDL_RWops
pub fn rw_from_file(file string, mode string) &RWops {
	return C.SDL_RWFromFile(file.str, mode.str)
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

// Load all the data from an SDL data stream.
//
// The data is allocated with a zero byte at the end (null terminated)
//
// If `datasize` is not NULL, it is filled with the size of the data read.
//
// If `freesrc` is non-zero, the stream will be closed after being read.
//
// The data should be freed with SDL_free().
//
// returns the data, or NULL if there was an error.
fn C.SDL_LoadFile_RW(src &C.SDL_RWops, datasize &usize, freesrc int) voidptr
pub fn load_file_rw(src &RWops, datasize &usize, freesrc int) voidptr {
	return C.SDL_LoadFile_RW(src, datasize, freesrc)
}

fn C.SDL_LoadFile(file &char, datasize &usize) voidptr

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
pub fn write_le32(dst &C.SDL_RWops, value u32) usize {
	return C.SDL_WriteLE32(dst, value)
}

fn C.SDL_WriteBE32(dst &C.SDL_RWops, value u32) usize
pub fn write_be32(dst &C.SDL_RWops, value u32) usize {
	return C.SDL_WriteBE32(dst, value)
}

fn C.SDL_WriteLE64(dst &C.SDL_RWops, value u64) usize
pub fn write_le64(dst &C.SDL_RWops, value u64) usize {
	return C.SDL_WriteLE64(dst, value)
}

fn C.SDL_WriteBE64(dst &C.SDL_RWops, value u64) usize
pub fn write_be64(dst &C.SDL_RWops, value u64) usize {
	return C.SDL_WriteBE64(dst, value)
}

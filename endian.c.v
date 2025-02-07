// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_endian.h
//

// Functions converting endian-specific values to different byte orders.
//
// These functions either unconditionally swap byte order (SDL_Swap16,
// SDL_Swap32, SDL_Swap64, SDL_SwapFloat), or they swap to/from the system's
// native byte order (SDL_Swap16LE, SDL_Swap16BE, SDL_Swap32LE, SDL_Swap32BE,
// SDL_Swap32LE, SDL_Swap32BE, SDL_SwapFloatLE, SDL_SwapFloatBE). In the
// latter case, the functionality is provided by macros that become no-ops if
// a swap isn't necessary: on an x86 (littleendian) processor, SDL_Swap32LE
// does nothing, but SDL_Swap32BE reverses the bytes of the data. On a PowerPC
// processor (bigendian), the macros behavior is reversed.
//
// The swap routines are inline functions, and attempt to use compiler
// intrinsics, inline assembly, and other magic to make byteswapping
// efficient.

pub const lil_endian = C.SDL_LIL_ENDIAN
pub const big_endian = C.SDL_BIG_ENDIAN
pub const byteorder = C.SDL_BYTEORDER

// TODO: swap16 commented to workaround error: `/usr/local/include/SDL3/SDL_endian.h:255: error: unknown constraint 'Q'`.
// fn C.SDL_Swap16(x u16) u16
// pub fn swap16(x u16) u16 {
// 	return C.SDL_Swap16(x)
// }

fn C.SDL_Swap32(x u32) u32
pub fn swap32(x u32) u32 {
	return C.SDL_Swap32(x)
}

fn C.SDL_Swap64(x u64) u64
pub fn swap64(x u64) u64 {
	return C.SDL_Swap64(x)
}

fn C.SDL_SwapFloat(x f32) f32
pub fn swap_float(x f32) f32 {
	return C.SDL_SwapFloat(x)
}

// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_endian.h
//

pub const lil_endian = C.SDL_LIL_ENDIAN
pub const big_endian = C.SDL_BIG_ENDIAN
pub const byteorder = C.SDL_BYTEORDER

// TODO SDL_endian.h fails on `tcc` with:
// 2.0.18/include/SDL2/SDL_endian.h:125: error: unknown constraint 'Q'
// fn C.SDL_Swap16(x u16) u16
// swap16 swaps the byte order of a 16-bit value.
//
// `x` the value to be swapped.
// returns the swapped value.
//
// See also: SDL_SwapBE16
// See also: SDL_SwapLE16
// pub fn swap16(x u16) u16 {
//	return C.SDL_Swap16(x)
// }

fn C.SDL_Swap32(x u32) u32

// Use this function to swap the byte order of a 32-bit value.
//
// `x` the value to be swapped.
// returns the swapped value.
//
// See also: SDL_SwapBE32
// See also: SDL_SwapLE32
pub fn swap32(x u32) u32 {
	return C.SDL_Swap32(x)
}

fn C.SDL_Swap64(x u64) u64

// Use this function to swap the byte order of a 64-bit value.
//
// `x` the value to be swapped.
// returns the swapped value.
//
// See also: SDL_SwapBE64
// See also: SDL_SwapLE64
pub fn swap64(x u64) u64 {
	return C.SDL_Swap64(x)
}

fn C.SDL_SwapFloat(x f32) f32

// Use this function to swap the byte order of a floating point value.
//
// `x` the value to be swapped.
// returns the swapped value.
//
// See also: SDL_SwapFloatBE
// See also: SDL_SwapFloatLE
pub fn swap_float(x f32) f32 {
	return C.SDL_SwapFloat(x)
}

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

fn C.SDL_Swap16(x u16) u16
pub fn swap16(x u16) u16 {
	return C.SDL_Swap16(x)
}

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

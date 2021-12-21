// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_endian.h
//

pub const (
	lil_endian = C.SDL_LIL_ENDIAN
	big_endian = C.SDL_BIG_ENDIAN
	byteorder  = C.SDL_BYTEORDER
)

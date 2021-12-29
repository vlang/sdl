// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_bits.h
//
// NOTE not all distros include this file

/*
fn C.SDL_MostSignificantBitIndex32(x u32) int

// most_significant_bit_index32 gets the index of the most significant bit. Result is undefined when called
//  with 0. This operation can also be stated as "count leading zeroes" and
//  "log base 2".
//
//  returns index of the most significant bit, or -1 if the value is 0.
pub fn most_significant_bit_index32(x u32) int {
	return C.SDL_MostSignificantBitIndex32(x)
}

fn C.SDL_HasExactlyOneBitSet32(x u32) bool
pub fn has_exactly_one_bit_set32(x u32) bool {
	return C.SDL_HasExactlyOneBitSet32(x)
}
*/

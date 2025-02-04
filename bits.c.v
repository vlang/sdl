// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_bits.h
//

// Functions for fiddling with bits and bitmasks.

fn C.SDL_MostSignificantBitIndex32(x u32) int

// Get the index of the most significant (set) bit in a 32-bit number.
//
// Result is undefined when called with 0. This operation can also be stated
// as "count leading zeroes" and "log base 2".
//
// Note that this is a forced-inline function in a header, and not a public
// API function available in the SDL library (which is to say, the code is
// embedded in the calling program and the linker and dynamic loader will not
// be able to find this function inside SDL itself).
//
// `x` the 32-bit value to examine.
// returns the index of the most significant bit, or -1 if the value is 0.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn most_significant_bit_index32(x u32) int {
	return C.SDL_MostSignificantBitIndex32(x)
}

fn C.SDL_HasExactlyOneBitSet32(x u32) bool

// Determine if a unsigned 32-bit value has exactly one bit set.
//
// If there are no bits set (`x` is zero), or more than one bit set, this
// returns false. If any one bit is exclusively set, this returns true.
//
// Note that this is a forced-inline function in a header, and not a public
// API function available in the SDL library (which is to say, the code is
// embedded in the calling program and the linker and dynamic loader will not
// be able to find this function inside SDL itself).
//
// `x` the 32-bit value to examine.
// returns true if exactly one bit is set in `x`, false otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn has_exactly_one_bit_set32(x u32) bool {
	return C.SDL_HasExactlyOneBitSet32(x)
}

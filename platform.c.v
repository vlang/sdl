// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_platform.h
//

// get_platform gets the name of the platform.
fn C.SDL_GetPlatform() &char
pub fn get_platform() &char {
	return C.SDL_GetPlatform()
}

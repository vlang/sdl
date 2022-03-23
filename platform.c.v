// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_platform.h
//

fn C.SDL_GetPlatform() &char

// get_platform gets the name of the platform.
//
// Here are the names returned for some (but not all) supported platforms:
//
// - "Windows"
// - "Mac OS X"
// - "Linux"
// - "iOS"
// - "Android"
//
// returns the name of the platform. If the correct platform name is not
//          available, returns a string beginning with the text "Unknown".
//
// NOTE This function is available since SDL 2.0.0.
//
// NOTE the returned &char is const
pub fn get_platform() &char {
	return C.SDL_GetPlatform()
}

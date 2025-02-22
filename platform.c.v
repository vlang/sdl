// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_platform.h
//

// SDL provides a means to identify the app's platform, both at compile time
// and runtime.

// C.SDL_GetPlatform [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetPlatform)
fn C.SDL_GetPlatform() &char

// get_platform gets the name of the platform.
//
// Here are the names returned for some (but not all) supported platforms:
//
// - "Windows"
// - "macOS"
// - "Linux"
// - "iOS"
// - "Android"
//
// returns the name of the platform. If the correct platform name is not
//          available, returns a string beginning with the text "Unknown".
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_platform() &char {
	return &char(C.SDL_GetPlatform())
}

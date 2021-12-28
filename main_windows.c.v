// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_main.h
//

fn C.SDL_RegisterApp(name &char, style u32, h_inst voidptr) int

// register_app can be called to set the application class at startup
pub fn register_app(name string, style u32, h_inst voidptr) int {
	return C.SDL_RegisterApp(name.str, style, h_inst)
}

fn C.SDL_UnregisterApp()
pub fn unregister_app() {
	C.SDL_UnregisterApp()
}

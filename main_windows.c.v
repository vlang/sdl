// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_main.h
//

fn C.SDL_RegisterApp(name &char, style u32, h_inst voidptr) int

// register_app registers a win32 window class for SDL's use.
//
// This can be called to set the application window class at startup. It is
// safe to call this multiple times, as long as every call is eventually
// paired with a call to SDL_UnregisterApp, but a second registration attempt
// while a previous registration is still active will be ignored, other than
// to increment a counter.
//
// Most applications do not need to, and should not, call this directly; SDL
// will call it when initializing the video subsystem.
//
// `name` the window class name, in UTF-8 encoding. If NULL, SDL
//             currently uses "SDL_app" but this isn't guaranteed.
// `style` the value to use in WNDCLASSEX::style. If `name` is NULL, SDL
//              currently uses `(CS_BYTEALIGNCLIENT | CS_OWNDC)` regardless of
//              what is specified here.
// `hInst` the HINSTANCE to use in WNDCLASSEX::hInstance. If zero, SDL
//              will use `GetModuleHandle(NULL)` instead.
// returns 0 on success, -1 on error. SDL_GetError() may have details.
//
// NOTE This function is available since SDL 2.0.2.
pub fn register_app(name &char, style u32, h_inst voidptr) int {
	return C.SDL_RegisterApp(name, style, h_inst)
}

fn C.SDL_UnregisterApp()

// unregister_app deregisters the win32 window class from an SDL_RegisterApp call.
//
// This can be called to undo the effects of SDL_RegisterApp.
//
// Most applications do not need to, and should not, call this directly; SDL
// will call it when deinitializing the video subsystem.
//
// It is safe to call this multiple times, as long as every call is eventually
// paired with a prior call to SDL_RegisterApp. The window class will only be
// deregistered when the registration counter in SDL_RegisterApp decrements to
// zero through calls to this function.
//
// NOTE This function is available since SDL 2.0.2.
pub fn unregister_app() {
	C.SDL_UnregisterApp()
}

// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_main.h
//

// C.SDL_RegisterApp [official documentation](https://wiki.libsdl.org/SDL3/SDL_RegisterApp)
fn C.SDL_RegisterApp(const_name &char, style u32, h_inst voidptr) bool

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
// `name` name the window class name, in UTF-8 encoding. If NULL, SDL
//             currently uses "SDL_app" but this isn't guaranteed.
// `style` style the value to use in WNDCLASSEX::style. If `name` is NULL, SDL
//              currently uses `(CS_BYTEALIGNCLIENT | CS_OWNDC)` regardless of
//              what is specified here.
// `h_inst` hInst the HINSTANCE to use in WNDCLASSEX::hInstance. If zero, SDL
//              will use `GetModuleHandle(NULL)` instead.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn register_app(const_name &char, style u32, h_inst voidptr) bool {
	return C.SDL_RegisterApp(const_name, style, h_inst)
}

// C.SDL_UnregisterApp [official documentation](https://wiki.libsdl.org/SDL3/SDL_UnregisterApp)
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
// NOTE: This function is available since SDL 3.2.0.
pub fn unregister_app() {
	C.SDL_UnregisterApp()
}

// $if XBox GDK

/*

// C.SDL_GDKSuspendComplete [official documentation](https://wiki.libsdl.org/SDL3/SDL_GDKSuspendComplete)
fn C.SDL_GDKSuspendComplete()

// gdk_suspend_complete callbacks from the application to let the suspend continue.
//
// This function is only needed for Xbox GDK support; all other platforms will
// do nothing and set an "unsupported" error message.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn gdk_suspend_complete() {
	C.SDL_GDKSuspendComplete()
}

*/

// /END $if XBox GDK

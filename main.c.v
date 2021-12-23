// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_main.h
//

// set_main_ready is called by the real SDL main function to let the rest of the
// library know that initialization was done properly.
//
// Calling this yourself without knowing what you're doing can cause
// crashes and hard to diagnose problems with your application.
fn C.SDL_SetMainReady()
pub fn set_main_ready() {
	C.SDL_SetMainReady()
}

// NB: C.SDL_RegisterApp and C.SDL_UnregisterApp are not available on older SDL versions !!!
//
// register_app can be called to set the application class at startup
// fn C.SDL_RegisterApp(name &char, style u32, h_inst voidptr) int
// pub fn register_app(name &char, style u32, h_inst voidptr) int {
// 	return C.SDL_RegisterApp(name, style, h_inst)
//}
//
// fn C.SDL_UnregisterApp()
// pub fn unregister_app() {
//	C.SDL_UnregisterApp()
//}

// TODO
//$if winrt ? {
// fn C.SDL_WinRTRunApp((*main_function)(int, char* *) int, reserved voidptr) int
// win_rt_run_app Initializes and launches an SDL/WinRT application.
//
// `mainFunction` The SDL app's C-style main().
// `reserved` Reserved for future use; should be NULL
// returns 0 on success, -1 on failure.  On failure, use SDL_GetError to retrieve more
//     information on the failure.
// pub fn win_rt_run_app((*main_function)(int, char* *) int, reserved voidptr) int{
//	return C.SDL_WinRTRunApp((*main_function)(int, char* *), reserved)
//}
//}

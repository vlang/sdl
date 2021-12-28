// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_main.h
//

// The prototype for the application's main() function
// `typedef int (*SDL_main_func)(int argc, char *argv[]);`
type MainFunc = fn (argc int, argv &&char) int

// set_main_ready is called by the real SDL main function to let the rest of the
// library know that initialization was done properly.
//
// Calling this yourself without knowing what you're doing can cause
// crashes and hard to diagnose problems with your application.
fn C.SDL_SetMainReady()
pub fn set_main_ready() {
	C.SDL_SetMainReady()
}

// TODO
//$if winrt ? {
// fn C.SDL_WinRTRunApp(SDL_main_func MainFunc, reserved voidptr) int
// win_rt_run_app Initializes and launches an SDL/WinRT application.
//
// `mainFunction` The SDL app's C-style main().
// `reserved` Reserved for future use; should be NULL
// returns 0 on success, -1 on failure.  On failure, use SDL_GetError to retrieve more
//     information on the failure.
// pub fn win_rt_run_app(main_func MainFunc, reserved voidptr) int{
//	return C.SDL_WinRTRunApp(main_func, reserved)
//}
//}

// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_main.h
//

// The prototype for the application's main() function
// `typedef int (*SDL_main_func)(int argc, char *argv[]);`
pub type MainFunc = fn (argc int, argv &&char) int

fn C.SDL_SetMainReady()

// set_main_ready circumvents failure of SDL_Init() when not using SDL_main() as an entry
// point.
//
// This function is defined in SDL_main.h, along with the preprocessor rule to
// redefine main() as SDL_main(). Thus to ensure that your main() function
// will not be changed it is necessary to define SDL_MAIN_HANDLED before
// including SDL.h.
//
// NOTE: This function is available since SDL 2.0.0.
//
// See also: SDL_Init
pub fn set_main_ready() {
	C.SDL_SetMainReady()
}

// TODO
//$if winrt ? {
// fn C.SDL_WinRTRunApp(SDL_main_func MainFunc, reserved voidptr) int
// win_rt_run_app initializes and launch an SDL/WinRT application.
//
// `mainFunction` the SDL app's C-style main(), an SDL_main_func
// `reserved` reserved for future use; should be NULL
// returns 0 on success or -1 on failure; call SDL_GetError() to retrieve
//          more information on the failure.
//
// NOTE: This function is available since SDL 2.0.3.
// pub fn win_rt_run_app(main_func MainFunc, reserved voidptr) int{
//	return C.SDL_WinRTRunApp(main_func, reserved)
//}
//}

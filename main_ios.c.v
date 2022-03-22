// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_main.h
//

fn C.SDL_UIKitRunApp(argc int, argv &&char, main_function MainFunc) int

// ui_kit_run_app initializes and launches an SDL application.
//
// `argc` The argc parameter from the application's main() function
// `argv` The argv parameter from the application's main() function
// `mainFunction` The SDL app's C-style main(), an SDL_main_func
// returns the return value from mainFunction
//
// NOTE This function is available since SDL 2.0.10.
pub fn ui_kit_run_app(argc int, argv &&char, main_function MainFunc) int {
	return C.SDL_UIKitRunApp(argc, argv, main_function)
}

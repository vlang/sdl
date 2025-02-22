module callbacks

import sdl

#preinclude  "@VMODROOT/c/sdl_main_use_callbacks_preinclude.h"
#postinclude "@VMODROOT/c/sdl_main_use_callbacks_postinclude.h"
#include     "@VMODROOT/c/sdl_main_use_callbacks_include.h"

// on_init will make SDL3 call the passed function callback `f`,
// when it will call https://wiki.libsdl.org/SDL3/SDL_AppInit .
pub fn on_init(f sdl.AppInitFunc) {
	unsafe {
		*&sdl.AppInitFunc(&C.g_sdl_app_init) = voidptr(f)
	}
}

// on_quit will make SDL3 call the passed function callback `f`,
// when it will call https://wiki.libsdl.org/SDL3/SDL_AppQuit .
pub fn on_quit(f sdl.AppQuitFunc) {
	unsafe {
		*&sdl.AppQuitFunc(&C.g_sdl_app_quit) = voidptr(f)
	}
}

// on_event will make SDL3 call the passed function callback `f`,
// when it will call https://wiki.libsdl.org/SDL3/SDL_AppEvent .
pub fn on_event(f sdl.AppEventFunc) {
	unsafe {
		*&sdl.AppEventFunc(&C.g_sdl_app_event) = voidptr(f)
	}
}

// on_iterate will make SDL3 call the passed function callback `f`,
// when it will call https://wiki.libsdl.org/SDL3/SDL_AppIterate .
pub fn on_iterate(f sdl.AppIterateFunc) {
	unsafe {
		*&sdl.AppIterateFunc(&C.g_sdl_app_iterate) = voidptr(f)
	}
}

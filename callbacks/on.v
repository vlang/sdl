module callbacks

import sdl

#preinclude  "@VMODROOT/c/sdl_main_use_callbacks_preinclude.h"
#postinclude "@VMODROOT/c/sdl_main_use_callbacks_postinclude.h"
#include     "@VMODROOT/c/sdl_main_use_callbacks_include.h"

pub fn on_init(f sdl.AppInitFunc) {
	unsafe {
		*&sdl.AppInitFunc(&C.g_sdl_app_init) = voidptr(f)
	}
}

pub fn on_quit(f sdl.AppQuitFunc) {
	unsafe {
		*&sdl.AppQuitFunc(&C.g_sdl_app_quit) = voidptr(f)
	}
}

pub fn on_event(f sdl.AppEventFunc) {
	unsafe {
		*&sdl.AppEventFunc(&C.g_sdl_app_event) = voidptr(f)
	}
}

pub fn on_iterate(f sdl.AppIterateFunc) {
	unsafe {
		*&sdl.AppIterateFunc(&C.g_sdl_app_iterate) = voidptr(f)
	}
}

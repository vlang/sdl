// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module no_main

// NOTE: compile this example with `-d sdl_callbacks`.
// We use `module no_main` and do not define `fn main() {}` in any of the ported
// examples since they use the SDL3 `SDL_App*` callback scheme implemented as a shim in C.
// Read more about the setup and reasons for this in `examples/ports/README.md`.
import sdl

#postinclude "@VMODROOT/c/sdl_main_use_callbacks_shim.h"

struct SDLApp {
	window   &sdl.Window   = unsafe { nil }
	renderer &sdl.Renderer = unsafe { nil }
}

// app_init runs once at startup.
// NOTE: the exported name has significance since it is called from C so it should not be changed.
@[export: 'v_sdl_app_init']
pub fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {
	// Allocate / instantiate the state struct on the heap
	mut app := &SDLApp{}
	// Hand it over to SDL so it can be retreived in the other App* callbacks
	unsafe {
		*appstate = app
	}
	sdl.set_app_metadata('Example V + SDL3 No Main'.str, '1.0'.str, 'com.example.v-sdl-no-main'.str)
	if !sdl.init(sdl.init_video) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln('Could not initialize SDL: ${error_msg}')
		return .failure
	}
	if !sdl.create_window_and_renderer('examples/renderer/clear'.str, 640, 480, sdl.WindowFlags(0),
		&app.window, &app.renderer) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln('Could not create window/renderer: ${error_msg}')
		return .failure
	}
	return .continue
}

// app_event runs when a new event (mouse input, keypresses, etc) occurs.
// NOTE: the exported name has significance since it is called from C so it should not be changed.
@[export: 'v_sdl_app_event']
pub fn app_event(appstate voidptr, event &sdl.Event) sdl.AppResult {
	match event.type {
		.quit {
			return .success
		}
		else {}
	}
	return .continue
}

// app_iterate runs once per frame, and is the heart of the program.
// NOTE: the exported name has significance since it is called from C so it should not be changed.
@[export: 'v_sdl_app_iterate']
pub fn app_iterate(appstate voidptr) sdl.AppResult {
	mut app := unsafe { &SDLApp(appstate) } // Retreive the state struct we initialized in `app_init`.
	sdl.set_render_draw_color_float(app.renderer, 1.0, 0.0, 0.0, sdl.alpha_opaque)
	sdl.render_clear(app.renderer)
	sdl.render_present(app.renderer)
	return .continue
}

// app_quit runs once at shutdown.
// NOTE: the exported name has significance since it is called from C so it should not be changed.
@[export: 'v_sdl_app_quit']
pub fn app_quit(appstate voidptr, result sdl.AppResult) {
	// SDL will clean up the window/renderer for us.
}

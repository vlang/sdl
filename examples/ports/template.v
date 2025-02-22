// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module no_main

// We use `module no_main` and do not define `fn main() {}` in any of the ported examples.
// Instead, we do register our callback functions in the module's init function.
// The sdl.callbacks module, uses the SDL3 `SDL_App*` callback scheme.
// Read more about the setup and reasons for this in `examples/ports/README.md`.
import sdl
import sdl.callbacks

fn init() {
	callbacks.on_init(app_init)
	callbacks.on_quit(app_quit)
	callbacks.on_event(app_event)
	callbacks.on_iterate(app_iterate)
}

// SDLApp is dedicated to hold the complete state of the application.
struct SDLApp {
	window   &sdl.Window   = unsafe { nil }
	renderer &sdl.Renderer = unsafe { nil }
}

// app_init runs once at startup.
pub fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {
	// Allocate / instantiate the state struct on the heap
	mut app := &SDLApp{}
	// Hand it over to SDL so it can be retreived in the other App* callbacks
	unsafe {
		*appstate = app
	}
	sdl.set_app_metadata(c'Example V + SDL3 Template', c'1.0', c'com.example.template')
	if !sdl.init(sdl.init_video) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't initialize SDL: ${error_msg}")
		return .failure
	}
	if !sdl.create_window_and_renderer(c'examples/renderer/clear', 640, 480, sdl.WindowFlags(0),
		&app.window, &app.renderer) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't create window/renderer: ${error_msg}")
		return .failure
	}
	return .continue
}

// app_event runs when a new event (mouse input, keypresses, etc) occurs.
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
pub fn app_iterate(appstate voidptr) sdl.AppResult {
	mut app := unsafe { &SDLApp(appstate) } // Retreive the state struct we initialized in `app_init`.
	sdl.set_render_draw_color_float(app.renderer, 0.5, 0.5, 1.0, sdl.alpha_opaque)
	sdl.render_clear(app.renderer)
	sdl.render_present(app.renderer)
	return .continue
}

// app_quit runs once at shutdown.
pub fn app_quit(appstate voidptr, result sdl.AppResult) {
	// SDL will clean up the window/renderer for us.
}

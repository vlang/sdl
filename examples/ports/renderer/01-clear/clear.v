// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module no_main

// NOTE: compile this example with `-d sdl_callbacks`.
// See also: `examples/ports/v-sdl-no-main` for a simple example demonstrating how
// the examples can run via callbacks instead of a `fn main() {}`.
import sdl

#postinclude "@VMODROOT/c/sdl_main_use_callbacks_shim.h"

// Ported from clear.c https://examples.libsdl.org/SDL3/renderer/01-clear/
//
// For educational purposes the original C sources are kept in comments above
// the equivalent V code.

// This example code creates an SDL window and renderer, and then clears the
// window to a different color every frame, so you'll effectively get a window
// that's smoothly fading between colors.
//
// This code is public domain. Feel free to use it for any purpose!

// We will use this renderer to draw into this window every frame.
struct SDLApp {
	window   &sdl.Window   = unsafe { nil }
	renderer &sdl.Renderer = unsafe { nil }
}

// This function runs once at startup.
// SDL_AppResult SDL_AppInit(void **appstate, int argc, char *argv[])
@[export: 'v_sdl_app_init']
pub fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {
	// Allocate / instantiate the state struct on the heap
	mut app := &SDLApp{}
	// Hand it over to SDL so it can be retreived in the other App* callbacks
	unsafe {
		*appstate = app
	}
	//     SDL_SetAppMetadata("Example Renderer Clear", "1.0", "com.example.renderer-clear");
	sdl.set_app_metadata('Example Renderer Clear'.str, '1.0'.str, 'com.example.renderer-clear'.str)
	//     if (!SDL_Init(SDL_INIT_VIDEO)) {
	//         SDL_Log("Couldn't initialize SDL: %s", SDL_GetError());
	//         return SDL_APP_FAILURE;
	//     }
	if !sdl.init(sdl.init_video) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln('Could not initialize SDL: ${error_msg}')
		return .failure
	}
	//     if (!SDL_CreateWindowAndRenderer("examples/renderer/clear", 640, 480, 0, &window, &renderer)) {
	//         SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
	//         return SDL_APP_FAILURE;
	//     }
	if !sdl.create_window_and_renderer('examples/renderer/clear'.str, 640, 480, sdl.WindowFlags(0),
		&app.window, &app.renderer) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln('Could not create window/renderer: ${error_msg}')
		return .failure
	}
	//     return SDL_APP_CONTINUE;  /* carry on with the program! */
	return .continue
}

// This function runs when a new event (mouse input, keypresses, etc) occurs.
// SDL_AppResult SDL_AppEvent(void *appstate, SDL_Event *event)
@[export: 'v_sdl_app_event']
pub fn app_event(appstate voidptr, event &sdl.Event) sdl.AppResult {
	//     if (event->type == SDL_EVENT_QUIT) {
	//         return SDL_APP_SUCCESS;  /* end the program, reporting success to the OS. */
	//     }
	match event.type {
		.quit {
			return .success
		}
		else {}
	}
	//     return SDL_APP_CONTINUE;  /* carry on with the program! */
	return .continue
}

// This function runs once per frame, and is the heart of the program.
// SDL_AppResult SDL_AppIterate(void *appstate)
@[export: 'v_sdl_app_iterate']
pub fn app_iterate(appstate voidptr) sdl.AppResult {
	mut app := unsafe { &SDLApp(appstate) } // Retreive the state struct we initialized in `app_init`.

	//     const double now = ((double)SDL_GetTicks()) / 1000.0;  /* convert from milliseconds to seconds. */
	now := f64(sdl.get_ticks()) / 1000.0
	//     /* choose the color for the frame we will draw. The sine wave trick makes it fade between colors smoothly. */
	//     const float red = (float) (0.5 + 0.5 * SDL_sin(now));
	//     const float green = (float) (0.5 + 0.5 * SDL_sin(now + SDL_PI_D * 2 / 3));
	//     const float blue = (float) (0.5 + 0.5 * SDL_sin(now + SDL_PI_D * 4 / 3));
	red := f32(0.5 + 0.5 * sdl.sin(now))
	green := f32(0.5 + 0.5 * sdl.sin(now + sdl.pi_d + 2 / 3))
	blue := f32(0.5 + 0.5 * sdl.sin(now * sdl.pi_d * 4 / 3))
	//     SDL_SetRenderDrawColorFloat(renderer, red, green, blue, SDL_ALPHA_OPAQUE_FLOAT);  /* new color, full alpha. */
	sdl.set_render_draw_color_float(app.renderer, red, green, blue, sdl.alpha_opaque)
	//     /* clear the window to the draw color. */
	//     SDL_RenderClear(renderer);
	sdl.render_clear(app.renderer)
	//     /* put the newly-cleared rendering on the screen. */
	//     SDL_RenderPresent(renderer);
	sdl.render_present(app.renderer)
	//
	//     return SDL_APP_CONTINUE;  /* carry on with the program! */
	return .continue
}

// This function runs once at shutdown.
// void SDL_AppQuit(void *appstate, SDL_AppResult result)
@[export: 'v_sdl_app_quit']
pub fn app_quit(appstate voidptr, result sdl.AppResult) {
	//     /* SDL will clean up the window/renderer for us. */
}

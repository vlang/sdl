// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module no_main

// See also: `examples/ports/template.v` for a simple commented example demonstrating how
// to run via callbacks instead of a `fn main() {}`.
// See also: `examples/ports/README.md` for more information.
import sdl
import sdl.callbacks

fn init() {
	callbacks.on_init(app_init)
	callbacks.on_iterate(app_iterate)
}

// Ported from debug-text.c https://examples.libsdl.org/SDL3/renderer/18-debug-text/

// This example creates an SDL window and renderer, and then draws some text
// using SDL_RenderDebugText() every frame.
//
// This code is public domain. Feel free to use it for any purpose!

// We will use this renderer to draw into this window every frame.
struct SDLApp {
	window   &sdl.Window   = unsafe { nil }
	renderer &sdl.Renderer = unsafe { nil }
}

const window_width = 640
const window_height = 480

// This function runs once at startup.
pub fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {
	mut app := &SDLApp{}
	unsafe {
		*appstate = app
	}
	sdl.set_app_metadata(c'Example Renderer Debug Text', c'1.0', c'com.example.renderer-debug-text')

	if !sdl.init(sdl.init_video) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't initialize SDL: ${error_msg}")
		return .failure
	}

	if !sdl.create_window_and_renderer(c'examples/renderer/debug-text', window_width,
		window_height, sdl.WindowFlags(0), &app.window, &app.renderer) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't create window/renderer: ${error_msg}")
		return .failure
	}
	// SDL does not enable vertical monitor refresh-rate sync per default. To keep CPU usage low we add it, if possible.
	// NOTE: this is not part of the original example.
	if !sdl.set_render_v_sync(app.renderer, 1) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln('notice: SDL could not enable vsync for the renderer:\n${error_msg}\nSee also docs for `set_render_v_sync`.')
	}

	return .continue // carry on with the program!
}

// This function runs once per frame, and is the heart of the program.
pub fn app_iterate(appstate voidptr) sdl.AppResult {
	mut app := unsafe { &SDLApp(appstate) } // Retreive the state struct we initialized in `app_init`.

	charsize := sdl.debug_text_font_character_size

	// as you can see from this, rendering draws over whatever was drawn before it.
	sdl.set_render_draw_color(app.renderer, 0, 0, 0, sdl.alpha_opaque) // black, full alpha
	sdl.render_clear(app.renderer) // start with a blank canvas.

	sdl.set_render_draw_color(app.renderer, 255, 255, 255, sdl.alpha_opaque) // white, full alpha
	sdl.render_debug_text(app.renderer, 272, 100, 'Hello world!'.str)
	sdl.render_debug_text(app.renderer, 224, 150, 'This is some debug text.'.str)

	sdl.set_render_draw_color(app.renderer, 51, 102, 255, sdl.alpha_opaque) // light blue, full alpha
	sdl.render_debug_text(app.renderer, 184, 200, 'You can do it in different colors.'.str)
	sdl.set_render_draw_color(app.renderer, 255, 255, 255, sdl.alpha_opaque) // white, full alpha

	sdl.set_render_scale(app.renderer, 4.0, 4.0)
	sdl.render_debug_text(app.renderer, 14, 65, 'It can be scaled.'.str)
	sdl.set_render_scale(app.renderer, 1.0, 1.0)
	sdl.render_debug_text(app.renderer, 64, 350, "This only does ASCII chars. So this laughing emoji won't draw: 🤣".str)

	// sdl.render_debug_text_format(app.renderer, f32((window_width - (charsize * 46)) / 2), 400, "(This program has been running for %" sdl.priu64 " seconds.)", sdl.get_ticks() / 1000)
	// NOTE: Some SDL functions use variadic C arguments which V currently only has limited support for so
	// here we use V's own string interpolation instead and pass that of as a C char pointer to the simpler
	// render_debug_text function.
	sdl.render_debug_text(app.renderer, f32((window_width - (charsize * 46)) / 2), 400,
		'(This program has been running for ${sdl.get_ticks() / 1000} seconds.)'.str)

	sdl.render_present(app.renderer) // put it all on the screen!

	return .continue // carry on with the program!
}

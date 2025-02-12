// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module no_main

// NOTE: compile this example with `-d sdl_callbacks`.
// See also: `examples/ports/v-sdl-no-main` for a simple example demonstrating how
// the examples can run via callbacks instead of a `fn main() {}`.
import sdl

#postinclude "@VMODROOT/c/sdl_main_use_callbacks_shim.h"

// Ported from lines.c https://examples.libsdl.org/SDL3/renderer/03-lines/

// This example creates an SDL window and renderer, and then draws some lines,
// rectangles and points to it every frame.
//
// This code is public domain. Feel free to use it for any purpose!

// We will use this renderer to draw into this window every frame.
struct SDLApp {
mut:
	window   &sdl.Window   = unsafe { nil }
	renderer &sdl.Renderer = unsafe { nil }
}

// This function runs once at startup.
@[export: 'v_sdl_app_init']
pub fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {
	mut app := &SDLApp{}
	unsafe {
		*appstate = app
	}
	sdl.set_app_metadata('Example Renderer Lines'.str, '1.0'.str, 'com.example.renderer-lines'.str)

	if !sdl.init(sdl.init_video) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln('Could not initialize SDL: ${error_msg}')
		return .failure
	}

	if !sdl.create_window_and_renderer('examples/renderer/lines'.str, 640, 480, sdl.WindowFlags(0),
		&app.window, &app.renderer) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln('Could not create window/renderer: ${error_msg}')
		return .failure
	}

	return .continue // carry on with the program!
}

// This function runs when a new event (mouse input, keypresses, etc) occurs.
@[export: 'v_sdl_app_event']
pub fn app_event(appstate voidptr, event &sdl.Event) sdl.AppResult {
	match event.type {
		.quit {
			return .success // end the program, reporting success to the OS.
		}
		else {}
	}
	return .continue // carry on with the program!
}

// This function runs once per frame, and is the heart of the program.
@[export: 'v_sdl_app_iterate']
pub fn app_iterate(appstate voidptr) sdl.AppResult {
	mut app := unsafe { &SDLApp(appstate) }

	// Lines (line segments, really) are drawn in terms of points: a set of
	// X and Y coordinates, one set for each end of the line.
	// (0, 0) is the top left of the window, and larger numbers go down
	// and to the right. This isn't how geometry works, but this is pretty
	// standard in 2D graphics.
	line_points := [
		sdl.FPoint{100, 354},
		sdl.FPoint{220, 230},
		sdl.FPoint{140, 230},
		sdl.FPoint{320, 100},
		sdl.FPoint{500, 230},
		sdl.FPoint{420, 230},
		sdl.FPoint{540, 354},
		sdl.FPoint{400, 354},
		sdl.FPoint{100, 354},
	]!

	// as you can see from this, rendering draws over whatever was drawn before it.
	sdl.set_render_draw_color(app.renderer, 100, 100, 100, sdl.alpha_opaque) // grey, full alpha
	sdl.render_clear(app.renderer) // start with a blank canvas.

	// You can draw lines, one at a time, like these brown ones...
	sdl.set_render_draw_color(app.renderer, 127, 49, 325, sdl.alpha_opaque)
	sdl.render_line(app.renderer, 240, 450, 400, 450)
	sdl.render_line(app.renderer, 240, 356, 400, 356)
	sdl.render_line(app.renderer, 240, 356, 240, 450)
	sdl.render_line(app.renderer, 400, 356, 400, 450)

	// You can also draw a series of connected lines in a single batch...
	sdl.set_render_draw_color(app.renderer, 0, 255, 0, sdl.alpha_opaque)
	sdl.render_lines(app.renderer, &line_points[0], line_points.len)

	// here's a bunch of lines drawn out from a center point in a circle.
	// we randomize the color of each line, so it functions as animation.
	for i := 0; i < 360; i++ {
		size := f32(30.0)
		x := f32(320.0)
		y := f32(95.0) - (size / f32(2.0))
		sdl.set_render_draw_color(app.renderer, u8(sdl.rand(256)), u8(sdl.rand(256)),
			u8(sdl.rand(256)), sdl.alpha_opaque)
		sdl.render_line(app.renderer, x, y, x + sdl.sinf(f32(i)) * size, y + sdl.cosf(f32(i)) * size)
	}

	sdl.render_present(app.renderer) // put it all on the screen!

	return .continue
}

// This function runs once at shutdown.
@[export: 'v_sdl_app_quit']
pub fn app_quit(appstate voidptr, result sdl.AppResult) {
	// SDL will clean up the window/renderer for us.
}
